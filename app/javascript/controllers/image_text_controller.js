// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 操作対象となる要素のターゲット定義
  static targets = ["input", "xPosition", "yPosition", "fileInput"]

  // コントローラーの初期化処理
  initialize() {
    super.initialize()
  }
  
  // 要素に接続したときに実行される処理
  connect() {
    console.log("テキスト配置コントローラーが接続されました")
    // 現在の位置情報を取得（なければ0をデフォルト値として使用）
    this.currentX = parseInt(this.xPositionTarget.value || 0)
    this.currentY = parseInt(this.yPositionTarget.value || 0)
    
    // 文字入力欄に20文字の制限を設定
    if (this.inputTarget) {
      // maxLengthは入力欄の最大文字数を指定するHTML属性
      this.inputTarget.maxLength = 20;
      // ユーザーが入力するたびにhandleTextInput関数を呼び出す
      this.inputTarget.addEventListener('input', this.handleTextInput.bind(this));
    }
    
    // ファイル選択時の処理を設定
    const fileInput = this.element.querySelector('input[type="file"]')
    if (fileInput) {
      fileInput.addEventListener('change', this.handleFileChange.bind(this))
    }
  }
  
  // テキスト入力時の処理
  handleTextInput(event) {
    // 20文字を超えたら切り詰める（念のためJavaScriptでも制限）
    if (event.target.value.length > 20) {
      event.target.value = event.target.value.substring(0, 20);
    }
    // プレビュー表示を更新
    this.updatePreview();
  }

  // ファイル選択時の処理
  handleFileChange(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      // ファイル読み込み完了時の処理
      reader.onload = (e) => {
        const imagePreview = this.element.querySelector('#image-preview')
        // プレビュー用の画像とテキスト表示エリアを作成
        imagePreview.innerHTML = `
          <img src="${e.target.result}" class="w-full h-full object-cover">
          <div class="overlay-text-container absolute top-0 left-0 w-full h-full pointer-events-none"></div>
        `
        // プレビュー表示を更新
        this.updatePreview()
      }
      // ファイルの読み込みを開始
      reader.readAsDataURL(file)
    }
  }

  // プレビュー表示の更新処理
  updatePreview() {
    // プレビュー表示エリアを取得
    const imagePreview = this.element.querySelector('#image-preview');
    const overlayContainer = imagePreview?.querySelector('.overlay-text-container');
    
    // オーバーレイコンテナがなければ何もしない
    if (!overlayContainer) return;
    
    // 既存のテキストがあれば削除（更新のため）
    const existingText = overlayContainer.querySelector('.overlay-text');
    if (existingText) {
      existingText.remove();
    }
  
    // 入力されたテキストを取得
    const text = this.inputTarget.value;
    if (text) {
      // デバイスタイプを取得（スマホかPCか）
      const isMobile = window.matchMedia("(max-width: 768px)").matches;
      
      // テキスト表示用の要素を作成
      const textOverlay = document.createElement('div');
      
      // デバイスに合わせてテキストサイズを調整（スマホではさらに小さく）
      const textSizeClass = isMobile ? 'text-lg' : 'text-5xl'; // text-6xl から text-5xl へ縮小
      textOverlay.className = `overlay-text absolute text-white ${textSizeClass}`;
      
      // テキスト表示のスタイル設定
      textOverlay.style.cssText = `
        left: ${this.currentX}px;
        top: ${this.currentY}px;
        position: absolute;
        white-space: nowrap; /* 改行させない */
        overflow: hidden;    /* はみ出た部分を隠す */
        text-overflow: ellipsis; /* はみ出た場合は...で表示 */
        max-width: 780px;     /* 最大幅を設定 */
        text-shadow: 2px 2px 4px rgba(0,0,0,0.7); /* 文字の縁取り効果 */
      `;
      
      // 編集中であることを示すクラスを追加
      textOverlay.classList.add('editing');
      
      // テキストを設定して表示エリアに追加
      textOverlay.textContent = text;
      overlayContainer.appendChild(textOverlay);
    }
  }

  // 上ボタンが押された時の処理
  moveUp(event) {
    event.preventDefault(); // ページのスクロールを防止
    this.currentY -= 20;    // 上に20ピクセル移動
    this.updatePosition();  // 位置情報を更新
  }

  // 下ボタンが押された時の処理
  moveDown(event) {
    event.preventDefault();
    this.currentY += 20;    // 下に20ピクセル移動
    this.updatePosition();
  }

  // 左ボタンが押された時の処理
  moveLeft(event) {
    event.preventDefault();
    this.currentX -= 20;    // 左に20ピクセル移動
    this.updatePosition();
  }

  // 右ボタンが押された時の処理
  moveRight(event) {
    event.preventDefault();
    this.currentX += 20;    // 右に20ピクセル移動
    this.updatePosition();
  }

  // 位置情報の更新処理（重要な部分）
  updatePosition() {
    // デバイスの種類を判定（スマホかPCか）
    const isMobile = window.matchMedia("(max-width: 768px)").matches;
    console.log("デバイスタイプ:", isMobile ? "モバイル" : "PC");
    
    // プレビュー画像の取得
    const imagePreview = this.element.querySelector('#image-preview img');
    
    // 画像がなければ処理を中断
    if (!imagePreview) {
      console.log("画像が見つかりません");
      this.xPositionTarget.value = this.currentX;
      this.yPositionTarget.value = this.currentY;
      this.updatePreview();
      return;
    }
  
    // PC版の場合、Y軸の位置を調整（調査結果から得られたずれを補正）
    let adjustedCurrentX = this.currentX;
    let adjustedCurrentY = this.currentY;
    
    if (!isMobile && this.currentY > 0) {
      // 実測値に基づいて120pxに変更
      const yOffset = 120; // 調査結果から得られた値を更新
      adjustedCurrentY = Math.max(0, this.currentY - yOffset);
    } else if (isMobile) {
      // モバイル向けの位置オフセット（実測値に基づく）
      // ここで1回だけ適用する
      adjustedCurrentX = Math.max(0, this.currentX - 20); // X座標を左に20px調整（ただし0未満にはしない）
      adjustedCurrentY = Math.max(0, this.currentY - 40); // Y座標を上に40px調整（ただし0未満にはしない）
    }
    
    // プレビュー画像のサイズを取得
    const previewWidth = imagePreview.clientWidth;
    const previewHeight = imagePreview.clientHeight;
    
    // サーバー側で処理する画像の最大サイズ
    const targetWidth = 800;
    const targetHeight = 800;
    
    // 表示サイズと処理サイズの比率を計算（補正係数）
    let xScale = previewWidth > 0 ? targetWidth / previewWidth : 1.0;
    let yScale = previewHeight > 0 ? targetHeight / previewHeight : 1.0;
    
    // デバイスによって補正係数を調整
    if (isMobile) {
      // モバイル向けの補正を実験結果に基づいて逆方向に調整
      xScale = xScale * 0.85; // 0.9から0.85へ変更
      yScale = yScale * 0.85; // 0.9から0.85へ変更
    }
    
    // 補正後の座標を計算
    const adjustedX = Math.round(adjustedCurrentX * xScale); // 調整済みのX座標を使用
    const adjustedY = Math.round(adjustedCurrentY * yScale); // 調整済みのY座標を使用
    
    console.log("座標情報:", {
      元のX: this.currentX,
      元のY: this.currentY,
      調整後X: adjustedCurrentX,
      調整後Y: adjustedCurrentY,
      補正後X: adjustedX,
      補正後Y: adjustedY,
      X補正係数: xScale.toFixed(2),
      Y補正係数: yScale.toFixed(2)
    });
    
    // フォームに補正後の値をセット（サーバーに送る値）
    this.xPositionTarget.value = adjustedX;
    this.yPositionTarget.value = adjustedY;
    
    // プレビューを更新（プレビューでは元の値を使用）
    this.updatePreview();
  }
}
