// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

console.log('🚀 application.js が読み込まれました - バージョン: ' + new Date().toISOString());

// 既存のコードを修正
document.addEventListener('DOMContentLoaded', () => {
  console.log('🔍 DOMContentLoaded イベントが発火しました');
  
  // まず、必要な要素を取得
  const details = document.querySelector('details');
  const icon = document.getElementById('accordion-icon');
  
  console.log('要素チェック:', { 
    detailsFound: !!details, 
    iconFound: !!icon 
  });
  
  if (details && icon) {
    console.log("🎯 アコーディオン要素を発見しました！");
    
    // 初期状態を設定
    icon.textContent = details.open ? '－' : '＋';
    
    // 詳細の表示・非表示が変わったときの処理
    details.addEventListener('toggle', (event) => {
      console.log('📣 toggle イベントが発火しました', { isOpen: details.open });
      
      // 開いているかどうかをチェック
      if (details.open) {
        // 開いた時：アイコンを「－」に変更、幅を広げる
        icon.textContent = '－';
        console.log('アイコンを変更: －');
        
        // 画面幅の50%にする
        const viewportWidth = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
        const targetWidth = Math.floor(viewportWidth * 0.5) + 'px';
        console.log('新しい幅を設定:', targetWidth);
        details.style.width = targetWidth;
        details.style.maxWidth = targetWidth;
      } else {
        // 閉じた時：アイコンを「＋」に変更、幅を戻す
        icon.textContent = '＋';
        console.log('アイコンを変更: ＋');
        details.style.width = 'auto';
        details.style.maxWidth = '32rem';
      }
    });
  } else {
    console.error('❌ アコーディオン要素が見つかりませんでした');
  }
});
