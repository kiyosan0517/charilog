import { Application } from "@hotwired/stimulus"
import { Autocomplete } from "stimulus-autocomplete"
import ImagesController from "./images_controller"

const application = Application.start()
application.register('autocomplete', Autocomplete)
application.register("images", ImagesController)

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
