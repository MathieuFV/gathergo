// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

// Clipboard
import Clipboard from "@stimulus-components/clipboard"
Stimulus.register("clipboard", Clipboard)

// Read more
import ReadMore from "@stimulus-components/read-more"
Stimulus.register("read-more", ReadMore)

// import SplideController from './splide_controller'
// application.register('splide', SplideController)
