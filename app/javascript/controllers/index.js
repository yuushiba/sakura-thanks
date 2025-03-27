// app/javascript/controllers/index.js
console.log("ドロップダウンコントローラー登録開始");
console.log("Loading controllers/index.js")

import { application } from "./application"
import ImageTextController from "./image_text_controller"
import AutocompleteController from "./autocomplete_controller"
import DropdownController from "./dropdown_controller"

console.log("Available controllers:", {
  "image-text": ImageTextController,
  "autocomplete": AutocompleteController,
})

application.register("image-text", ImageTextController)
application.register("autocomplete", AutocompleteController)
application.register("dropdown", DropdownController)
