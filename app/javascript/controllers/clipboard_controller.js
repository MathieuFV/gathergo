import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [ "source", "button"]

  connect() {
    super.connect()
    this.sourceTarget.value = window.location.href + "/join"
  }

  copy = () => {
    console.log(this.sourceTarget.value)
  }
}
