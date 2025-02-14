// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = true  // デバッグモードを有効化

// 開発環境でのデバッグ支援
if (process.env.NODE_ENV === 'development') {
  console.log("Stimulus application starting in development mode")
}

window.Stimulus = application
export { application }
