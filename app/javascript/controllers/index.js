// app/javascript/controllers/index.js
console.log("Loading controllers/index.js")

import { application } from "./application"
import ImageTextController from "./image_text_controller"
import AutocompleteController from "./autocomplete_controller"
application.register("autocomplete", AutocompleteController)

console.log("Available controllers:", {
  "image-text": ImageTextController,
  "autocomplete": AutocompleteController
})

application.register("image-text", ImageTextController)
application.register("autocomplete", AutocompleteController)
