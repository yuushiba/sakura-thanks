// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "input", "xPosition", "yPosition"]
  
  connect() {
    this.x = parseInt(this.xPositionTarget.value) || 0
    this.y = parseInt(this.yPositionTarget.value) || 0
    this.setupImagePreview()
  }
  
  drawImage(imageSrc) {
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    const img = new Image()
    
    img.onload = () => {
      canvas.width = img.width
      canvas.height = img.height
      
      // 画像を描画
      ctx.drawImage(img, 0, 0)
      
      // テキストを描画
      const text = this.inputTarget.value
      if (text) {
        ctx.font = '24px YOMOGI'
        ctx.fillStyle = 'white'
        ctx.strokeStyle = 'black'
        ctx.lineWidth = 4
        ctx.strokeText(text, this.x, this.y)
        ctx.fillText(text, this.x, this.y)
      }
      
      document.querySelector('#image-preview').innerHTML = 
        `<img src="${canvas.toDataURL()}" class="w-full h-full object-cover">`
    }
    
    img.src = imageSrc
  }
}
