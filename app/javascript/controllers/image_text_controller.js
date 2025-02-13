// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "xPosition", "yPosition"]
  
  connect() {
    if (this.hasInputTarget && this.inputTarget.value) {
      this.updatePreview()
    }
  }

  updatePreview() {
    // プレビューの更新は不要になったので、
    // 位置の値だけを更新して自動的にサーバーサイドでプレビューを生成
    const form = this.element.closest('form')
    if (form) {
      Rails.fire(form, 'submit')
    }
  }

  moveUp() {
    this.move(0, -20)  // 移動幅を大きく
  }

  moveDown() {
    this.move(0, 20)
  }

  moveLeft() {
    this.move(-20, 0)
  }

  moveRight() {
    this.move(20, 0)
  }

  move(dx, dy) {
    const x = parseInt(this.xPositionTarget.value || 0) + dx
    const y = parseInt(this.yPositionTarget.value || 0) + dy
    
    this.xPositionTarget.value = x
    this.yPositionTarget.value = y
    
    this.updatePreview()
  }
}
