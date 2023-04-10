import { Controller } from "@hotwired/stimulus"

import "../controllers"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
