// app/javascript/controllers/image_text_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textPreview"]

  connect() {
    this.updatePreview()
  }

  updatePreview() {
    if (this.hasTextPreviewTarget) {
      this.textPreviewTarget.classList.remove('hidden')
    }
  }
}
