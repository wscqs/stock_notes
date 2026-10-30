/* ==========================================
   股票笔记官网 · 交互脚本
   ========================================== */

/* ---------- 站点配置（发版脚本 sync-release.sh 会自动改这里） ---------- */
const SITE = {
  version: '4.0.0',
  /* 发布日期（发版脚本自动更新） */
  releaseDate: '2026-10-30',
  /* 三平台文件：固定文件名，不含版本号，永远指向最新版 */
  files: {
    android: 'stocknote-android.apk',
    windows: 'stocknote-windows.zip',
    macos:   'stocknote-macos.zip'
  },
  apkSize: '28.0 MB',
  github: 'https://github.com/wscqs/stock_notes',
  /* 是否提供本站本地镜像（workbuddy 托管版 true / GitHub Pages 版 false） */
  localMirror: false,
  /* GitHub Releases 永久链接：永不失效、自动跟随最新版、微信内可下载 */
  release: {
    android: 'https://github.com/wscqs/stock_notes/releases/latest/download/android_stocknote.apk',
    windows: 'https://github.com/wscqs/stock_notes/releases/latest/download/windows-stocknote.zip',
    macos:   'https://github.com/wscqs/stock_notes/releases/latest/download/macos-stocknote.zip'
  }
};

/* ---------- 导航 ---------- */
function initNav() {
  const nav = document.getElementById('nav');
  const toggle = document.getElementById('navToggle');
  const links = document.getElementById('navLinks');

  const onScroll = () => nav.classList.toggle('scrolled', window.scrollY > 12);
  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });

  if (toggle && links) {
    toggle.addEventListener('click', () => {
      const open = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
    });
    links.addEventListener('click', (e) => {
      if (e.target.tagName === 'A') {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });
    document.addEventListener('click', (e) => {
      if (!links.contains(e.target) && !toggle.contains(e.target)) {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });
  }
}

/* ---------- 填充 APK 体积与版本号 ---------- */
function applyVersion() {
  const sizeEl = document.getElementById('heroSize');
  if (sizeEl) sizeEl.textContent = SITE.apkSize;

  // 下载页的当前版本标注
  const verEl = document.querySelector('[data-ver]');
  if (verEl) verEl.textContent = 'v' + SITE.version;

  const dateEl = document.querySelector('[data-ver-date]');
  if (dateEl) {
    dateEl.textContent = SITE.releaseDate
      ? SITE.releaseDate + ' 更新'
      : '最新版本';
  }
}

/* ---------- 下载提示 ---------- */
const FILE_LABEL = {
  'stocknote-android.apk': 'Android 安装包',
  'stocknote-windows.zip': 'Windows 安装包',
  'stocknote-macos.zip': 'macOS 安装包'
};

const PLATFORM_LABEL = {
  android: 'Android 安装包',
  windows: 'Windows 安装包',
  macos: 'macOS 安装包'
};

const PLATFORM_KEY = {
  'stocknote-android.apk': 'android',
  'stocknote-windows.zip': 'windows',
  'stocknote-macos.zip': 'macos'
};

/* 解析下载按钮所属平台：优先用 data-platform，其次从文件名反推 */
function platformOf(el) {
  const explicit = el.getAttribute('data-platform');
  if (explicit && SITE.release[explicit]) return explicit;
  const href = el.getAttribute('href') || '';
  const name = decodeURIComponent(href.split('/').pop().split('?')[0]);
  return PLATFORM_KEY[name] || null;
}

function initDownloadPage() {
  const btns = document.querySelectorAll('[data-apk], [data-dl]');
  if (!btns.length) return;

  let toast;
  const show = (msg) => {
    if (!toast) {
      toast = document.createElement('div');
      toast.className = 'toast';
      document.body.appendChild(toast);
    }
    toast.textContent = msg;
    toast.classList.add('show');
    clearTimeout(toast._t);
    toast._t = setTimeout(() => toast.classList.remove('show'), 3600);
  };

  btns.forEach((btn) => {
    const key = platformOf(btn);
    const localHref = SITE.localMirror && key ? 'downloads/' + SITE.files[key] : null;

    // 站点自带镜像时优先用本地直链（速度快、不经第三方）；
    // 纯 GitHub Pages 部署则改指 Release 永久链接
    // （微信内可达、链接永不失效、自动跟随最新版）
    if (localHref) {
      btn.setAttribute('href', localHref);
    } else if (key && SITE.release[key]) {
      btn.setAttribute('href', SITE.release[key]);
      btn.removeAttribute('download');
    }

    btn.addEventListener('click', () => {
      const href = btn.getAttribute('href') || '';
      const name = decodeURIComponent(href.split('/').pop().split('?')[0]);
      const label = FILE_LABEL[name] || (key ? PLATFORM_LABEL[key] : '安装包');
      show(`开始下载 ${label}（v${SITE.version}）…`);
    });
  });

  // 备用下载源：始终指向 GitHub Releases 永久链接
  document.querySelectorAll('[data-release-link]').forEach((el) => {
    const key = el.getAttribute('data-release-link');
    if (SITE.release[key]) el.setAttribute('href', SITE.release[key]);
  });

  // 无本地镜像时（GitHub Pages 版），说明文案改为「官方发布页直链」
  if (!SITE.localMirror) {
    const note = document.querySelector('[data-note="android"]');
    if (note) note.textContent = '来自官方 GitHub 发布页，始终是最新版';
  }
}

/* ---------- 滚动入场动画 ---------- */
function initReveal() {
  const targets = document.querySelectorAll('.card, .shot, .flow-step, .step, .loop-note');
  if (!targets.length) return;

  if (!('IntersectionObserver' in window)) return;

  const io = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        e.target.style.opacity = '1';
        e.target.style.transform = 'none';
        io.unobserve(e.target);
      }
    });
  }, { threshold: 0.08, rootMargin: '0px 0px -40px 0px' });

  targets.forEach((el, i) => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(16px)';
    el.style.transition = `opacity .55s ease ${(i % 6) * 0.05}s, transform .55s cubic-bezier(.22,1,.36,1) ${(i % 6) * 0.05}s`;
    io.observe(el);
  });
}

/* ---------- 微信内置浏览器提示 ---------- */
function initWechatTip() {
  const ua = navigator.userAgent.toLowerCase();
  if (!/micromessenger/.test(ua)) return;
  const tip = document.getElementById('wxTip');
  if (tip) tip.hidden = false;
}

document.addEventListener('DOMContentLoaded', () => {
  initNav();
  applyVersion();
  initDownloadPage();
  initReveal();
  initWechatTip();
});