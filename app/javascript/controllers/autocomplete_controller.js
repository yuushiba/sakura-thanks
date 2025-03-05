// app/javascript/controllers/autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "results" ]

  connect() {
    console.log("Autocomplete controller connected!");  // デバッグ用
    this.resultsTarget.hidden = true
    this.inputTarget.addEventListener("input", this.search.bind(this))
    this.inputTarget.addEventListener("focus", this.search.bind(this))
    document.addEventListener("click", this.hideResults.bind(this))
  }
  
  hideResults(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.hidden = true
    }
  }

  async search() {
    console.log("Search triggered with:", this.inputTarget.value);  // デバッグ用
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.resultsTarget.hidden = true
      return
    }
    
    try {
      const response = await fetch(`/posts/autocomplete?term=${encodeURIComponent(query)}`)
      const data = await response.json()
      
      this.resultsTarget.innerHTML = ""
      
      if (data.length > 0) {
        this.resultsTarget.hidden = false
        data.forEach(item => {
          const element = document.createElement("div")
          element.classList.add("p-2", "hover:bg-gray-100", "cursor-pointer")
          element.textContent = item.value
          element.dataset.id = item.id
          element.addEventListener("click", () => this.selectResult(item))
          this.resultsTarget.appendChild(element)
        })
      } else {
        this.resultsTarget.hidden = true
      }
    } catch (error) {
      console.error("オートコンプリートエラー:", error)
    }
  }
  
  selectResult(item) {
    this.inputTarget.value = item.value
    this.resultsTarget.hidden = true
  }
}
