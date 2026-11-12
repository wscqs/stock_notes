# 网页打开 App 股票编辑页接入文档

## 1. 功能说明

网页通过普通链接唤起「股票笔记」App，并进入指定股票的编辑页。

- App 本地已有该代码的股票：打开已有记录，展示计划、交易和笔记等内容。
- App 本地没有该股票：预填股票代码并尝试获取行情，用户确认后自行保存。
- 不传股票代码：打开空白股票编辑页。
- 网页唤起不会自动新增或修改本地股票。
- 用户未安装 App 时，自定义 Scheme 无法统一跳转到下载页；建议同时提供网页内容或下载入口。

当前 Android、iOS 使用自定义 URL Scheme。HTTPS Universal Links / App Links 需要另行配置域名和系统关联文件，本文不将自定义 Scheme 与 HTTPS 域名混用。

## 2. URL 格式

### 打开指定股票

```text
stocknote://stocknote.com/#/stockedit?code=000001
```

`#` 前的内容是 App 已注册的 Scheme 和 Host，原样保留；`code` 放在 `#/stockedit` 后面的查询参数中。

### 打开空白编辑页

```text
stocknote://stocknote.com/#/stockedit
```

### 参数

| 参数 | 必填 | 类型 | 说明 |
| --- | --- | --- | --- |
| `code` | 否 | string | 股票或基金代码。建议网页已经确定代码，例如 `000001`、`600519`、`00700`。不要传股票名称。 |

代码原样传入，不要为了补零擅自改变业务代码。多个查询参数使用 `&`，值需要经过 URL 编码。

## 3. 网页接入

### HTML 链接

```html
<a
  href="stocknote://stocknote.com/#/stockedit?code=000001"
  target="_self"
  rel="noopener"
>
  在股票笔记中编辑平安银行
</a>
```

推荐由用户点击链接直接唤起，不要在网页加载时自动循环尝试。

### JavaScript 封装

```js
export function openStockNoteEdit(code) {
  const normalizedCode = String(code ?? '').trim();
  const query = normalizedCode
    ? `?code=${encodeURIComponent(normalizedCode)}`
    : '';
  window.location.href =
    `stocknote://stocknote.com/#/stockedit${query}`;
}
```

调用示例：

```js
openStockNoteEdit('600519');
```

这里保留纯数字代码，不使用 `toUpperCase()`，避免改变可能包含字母的代码。

### Vue / React

无需专用 SDK，在按钮点击事件中调用上述方法即可：

```html
<button type="button" onclick="openStockNoteEdit('000001')">
  在 App 中编辑
</button>
```

## 4. 平台行为与限制

### Android

App 已配置可浏览的 `stocknote://stocknote.com` Intent Filter。Chrome 等浏览器通常可以直接拉起。

### iOS

App 已注册 `stocknote` URL Scheme。网页不需要也不能通过 `LSApplicationQueriesSchemes` 检测 App 是否安装。

### 微信、QQ 等内置浏览器

部分内置浏览器会拦截自定义 Scheme，Android 微信尤其常见。这是宿主浏览器限制，不是链接参数错误。建议：

1. 提示用户「使用系统浏览器打开」。
2. 保留当前网页作为降级页。
3. 不使用隐藏 iframe、频繁定时器或反复跳转绕过宿主限制。

### 桌面平台

本接入文档只承诺当前已配置的 Android、iOS。不要假定 Windows、macOS 网页浏览器能处理同一 Scheme。

## 5. 降级体验

自定义 Scheme 没有可靠的「是否安装成功」网页回调，不建议用短计时器判断安装状态后强制跳转，因为系统确认框、后台切换都可能造成误判。

推荐页面同时展示：

- 「在 App 中编辑」主按钮。
- 当前股票的网页信息，避免未安装时完全不可用。
- 「下载 App」或「查看网页版」普通 HTTPS 链接。

如必须使用下载兜底，应提供「未打开？前往下载」的手动按钮，而不是自动替换页面。

## 6. 本地验证

### Android

设备或模拟器安装当前 App 后执行：

```bash
adb shell am start \
  -a android.intent.action.VIEW \
  -d 'stocknote://stocknote.com/#/stockedit?code=000001'
```

在真实网页中点击链接，分别验证：

1. App 未运行时的冷启动。
2. App 已在后台时再次点击。
3. 本地已有该代码。
4. 本地没有该代码。
5. 不带 `code`。
6. 微信等内置浏览器的提示和系统浏览器降级流程。

### iOS

模拟器可执行：

```bash
xcrun simctl openurl booted \
  'stocknote://stocknote.com/#/stockedit?code=000001'
```

同时在 Safari 真机网页中验证实际点击拉起；模拟器命令不能代替内置浏览器兼容性测试。

## 7. 排错

| 现象 | 优先检查 |
| --- | --- |
| 点击没有反应 | 是否安装包含该功能的 App；是否被内置浏览器拦截；Scheme 是否写成 `stocknote`，不是 `stocknotes`。 |
| 打开空白编辑页 | `code` 是否放在 `#/stockedit` 后面；完整格式应为 `#/stockedit?code=000001`。 |
| 参数丢失 | 不要把 `?code=...` 放到 `#` 之前；多个参数用 `&` 连接。 |
| 打开了另一只股票 | 检查网页代码是否传错；App 按代码查询本地记录。 |
| 新股票未写入列表 | 这是预期行为，需要在编辑页主动保存。 |
| 未安装时无法自动下载 | 这是自定义 Scheme 的限制，请提供 HTTPS 降级页或手动下载按钮。 |

## 8. 推荐落点示例

```text
A 股：stocknote://stocknote.com/#/stockedit?code=600519
港股：stocknote://stocknote.com/#/stockedit?code=00700
空白：stocknote://stocknote.com/#/stockedit
```
