// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "xPosition", "yPosition", "preview"]
  
  connect() {
    // 初期設定
    if (this.hasInputTarget && this.inputTarget.value) {
      this.updatePreview()
    }
  }

  updatePreview() {
    const text = this.inputTarget.value
    const x = parseInt(this.xPositionTarget.value || 0)
    const y = parseInt(this.yPositionTarget.value || 0)
    
    this.clearExistingText()
    if (text) {
      this.renderPreviewText(text, x, y)
    }
  }

  clearExistingText() {
    const existingText = this.element.querySelector('.overlay-text')
    if (existingText) {
      existingText.remove()
    }
  }

  renderPreviewText(text, x, y) {
    const imagePreview = this.element.querySelector('#image-preview')
    const previewText = document.createElement('div')
    previewText.className = 'overlay-text absolute text-white text-2xl font-bold break-words max-w-[80%]'
    previewText.style.cssText = `
      left: ${x + 20}px;
      top: ${y + 20}px;
      text-shadow: 2px 2px 2px rgba(0, 0, 0, 0.8);
      font-family: "Yomogi", sans-serif;
    `
    previewText.textContent = text
    imagePreview.appendChild(previewText)
  }

  moveUp() { this.move(0, -10) }
  moveDown() { this.move(0, 10) }
  moveLeft() { this.move(-10, 0) }
  moveRight() { this.move(10, 0) }

  move(dx, dy) {
    const x = parseInt(this.xPositionTarget.value || 0) + dx
    const y = parseInt(this.yPositionTarget.value || 0) + dy
    
    this.xPositionTarget.value = x
    this.yPositionTarget.value = y
    
    this.updatePreview()
  }
}
