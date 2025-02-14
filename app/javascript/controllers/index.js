// app/javascript/controllers/index.js
console.log("Loading controllers/index.js")

import { application } from "./application"
import ImageTextController from "./image_text_controller"

console.log("Available controllers:", {
  "image-text": ImageTextController
})

application.register("image-text", ImageTextController)
