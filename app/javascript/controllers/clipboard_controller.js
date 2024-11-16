import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [ "source", "button"]

  connect() {
    super.connect()
    this.sourceTarget.value = window.location.href + "/join"
  }

  copy = () => {
    this.buttonTarget.innerHTML = '<i class="fa-solid fa-check"></i>';
  }
}