import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
window.Stimulus = application

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
