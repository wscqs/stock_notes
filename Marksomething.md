## 一些备注
dart pub global activate get_cli
getx,shell建页面。 get create page:chatdetail

flutter pub cache repair
flutter clean
flutter pub get
flutter build

cd macos
rm -rf Pods Podfile.lock
pod repo update
pod install
cd ..

dart run build_runner build
dart run build_runner watch

## 修改 .gitignore
git add .gitignore
git commit -m "Add or modify .gitignore file"

git rm -r --cached android/app/.cxx/Debug
git add .
git commit -m "Update .gitignore to exclude unpackage except res"

## 包名 com.wlsp.carrotcards

## 打包flutter
https://mp.weixin.qq.com/s/qYK_MX9BpGd_Wrm-Q04AXw
Android 分包：flutter build apk --split-per-abi --release
一般只用arm64-v8a （64位，99%以上机型）
web打包：flutter build web --release --wasm --tree-shake-icons
https://docs.flutter.cn/deployment/android
https://www.jianshu.com/p/f13f4f996e2a
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool -genkey -v -keystore ~/carrot-keystore.jks -keyalg RSA \
-keysize 2048 -validity 10000 -alias carrot
密钥 stocknotesstocknotes  后面问题1,2,3,4,5,6

storePassword=stocknotesstocknotes
keyPassword=stocknotesstocknotes
keyAlias=stocknotes
storeFile=/Users/cqs/stocknotes-keystore.jks
https://blog.csdn.net/wsyx768/article/details/136319899


## 错误
这是 sqlite3 3.3.1 引入的 build.dart 钩子导致的。它在构建时会尝试从 GitHub 下载预编译的 Android SO
文件，但在国内网络下很容易失败。

你已经有 sqlite3_flutter_libs 依赖（它自带了 SQLite
原生库），只需设置一个环境变量让它直接使用本地已有的库，跳过下载：

本地打包：
export SQLITE3_FLUTTER_LIBS_USE_OOT=1
flutter build apk --release

## icon与splash
flutter pub run flutter_launcher_icons
dart run flutter_native_splash:create

iPhone市场图用 ProMax 截图









## other

代码混淆
https://docs.flutter.cn/deployment/obfuscate
Flutter代码补全
option+j  https://juejin.cn/post/7296660227545104435


必备复习文章
https://blog.csdn.net/winni_a/category_12617274.html


页面刷新
启动白屏问题

内购
https://blog.csdn.net/panghaha12138/article/details/138534488


主题
https://ducafecat.com/blog/flutter-flex-color-scheme
https://ducafecat.com/blog/flutter-app-theme-switch

getX
https://developer.aliyun.com/article/1265115

一些封装
https://www.jianshu.com/p/52e870040636

对getx二次封装
https://juejin.cn/post/7390341683619381282


全平台分发（后面研究）
https://github.com/leanflutter/flutter_distributor

github 自动打包研究
https://github.com/wscqs/stock_notes/actions/runs/15065843479/job/42350382968
https://github.com/localsend/localsend/tree/main/.github/workflows
https://github.com/flutter/flutter/issues/156304
https://developer.android.com/studio/releases?hl=zh-cn

导航返回拦截
WillPopScope(
onWillPop: () async {
// your logic        
return false;
},
)
改
PopScope(
canPop: false,
onPopInvoked : (didPop){
// logic
},
)