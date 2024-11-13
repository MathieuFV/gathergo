import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="zoom"
export default class extends Controller {
  connect() {
    console.log("Zoom controller")
  }

  zoom = (event) => {
    event.target.classList.toggle("zoomed")
  }
}
