import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="read-more"
export default class extends Controller {
  static targets = ["icon"]

  connect() {
    super.connect()
  }

  toggle(event) {
    // Toggle icon up or down
    this.#toggle_icon()
  }

  #toggle_icon() {
    // Changer l'icone affichée
    if (this.iconTarget.classList.contains("fa-angle-down")) {
      this.iconTarget.classList.remove("fa-angle-down")
      this.iconTarget.classList.add("fa-angle-up")
    }
    else {
      this.iconTarget.classList.remove("fa-angle-up")
      this.iconTarget.classList.add("fa-angle-down")
    }
  }
}
