import { Application } from "@hotwired/stimulus"
import ImagesController from "./images_controller"

const application = Application.start()
application.register("images", ImagesController)

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
