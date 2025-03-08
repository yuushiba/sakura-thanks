// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// アコーディオンの実装
document.addEventListener('DOMContentLoaded', () => {
  // 必要な要素を取得
  const details = document.querySelector('details');
  const icon = document.getElementById('accordion-icon');
  
  // 要素が見つかったら
  if (details && icon) {
    // アコーディオンの開閉時の処理を設定
    details.addEventListener('toggle', () => {
      // 開いているときは「－」、閉じているときは「＋」に変更
      icon.textContent = details.open ? '－' : '＋';
      
      if (details.open) {
        // 開いたとき：幅を画面の半分に設定
        const viewportWidth = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
        const halfWidth = Math.floor(viewportWidth * 0.5) + 'px';
        details.style.width = halfWidth;
        details.style.maxWidth = halfWidth;
      } else {
        // 閉じたとき：元の幅に戻す
        details.style.width = 'auto';
        details.style.maxWidth = '32rem';
      }
    });
  }
});
