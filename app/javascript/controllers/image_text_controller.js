// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"
console.log("Loading ImageTextController")  // 追加

export default class extends Controller {
  static targets = ["input", "xPosition", "yPosition", "fileInput"]

  initialize() {
    console.log("ImageTextController initialized")
    super.initialize()
  }
  
  connect() {
    console.log("Image Text Controller Connected!")
    this.currentX = parseInt(this.xPositionTarget.value || 0)
    this.currentY = parseInt(this.yPositionTarget.value || 0)
    
    // ファイル選択のイベントリスナーを設定
    const fileInput = this.element.querySelector('input[type="file"]')
    if (fileInput) {
      fileInput.addEventListener('change', this.handleFileChange.bind(this))
    }
  }

  handleFileChange(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const imagePreview = this.element.querySelector('#image-preview')
        imagePreview.innerHTML = `
          <img src="${e.target.result}" class="w-full h-full object-cover">
          <div class="overlay-text-container absolute top-0 left-0 w-full h-full pointer-events-none"></div>
        `
        this.updatePreview()
      }
      reader.readAsDataURL(file)
    }
  }

  updatePreview() {
    console.log("Updating preview")
    const imagePreview = this.element.querySelector('#image-preview')
    const overlayContainer = imagePreview.querySelector('.overlay-text-container')
    
    // 既存のテキストを削除
    const existingText = overlayContainer.querySelector('.overlay-text')
    if (existingText) {
      existingText.remove()
    }

    const text = this.inputTarget.value
    if (text) {
      const textOverlay = document.createElement('div')
      textOverlay.className = 'overlay-text absolute text-white text-6xl font-bold'
      textOverlay.style.cssText = `
        left: ${this.currentX}px;
        top: ${this.currentY}px;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
        font-family: "Yomogi", sans-serif;
      `
      textOverlay.textContent = text
      overlayContainer.appendChild(textOverlay)
    }
  }

  moveUp(event)  {
    event.preventDefault();
    console.log("Moving up from", this.currentY);
    this.currentY -= 20;
    this.updatePosition();
  }

  moveDown(event) {
    event.preventDefault()
    this.currentY += 20
    this.updatePosition()
  }

  moveLeft(event) {
    event.preventDefault()
    this.currentX -= 20
    this.updatePosition()
  }

  moveRight(event) {
    event.preventDefault()
    this.currentX += 20
    this.updatePosition()
  }

  updatePosition() {
    console.log("Updating position", {
      x: this.currentX,
      y: this.currentY
    });
    this.xPositionTarget.value = this.currentX;
    this.yPositionTarget.value = this.currentY;
    this.updatePreview();
  }
}
