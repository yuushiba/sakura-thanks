// app/javascript/controllers/dropdown_controller.js
console.log("ドロップダウンコントローラーファイル読み込み成功");
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    console.log("ドロップダウンコントローラー接続完了")
  }

  toggle() {
    console.log("トグル実行")
    if (this.contentTarget.style.display === 'block') {
      this.contentTarget.style.display = 'none'
    } else {
      this.contentTarget.style.display = 'block'
    }
  }
}
