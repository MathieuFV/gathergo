import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="zoom"
export default class extends Controller {
  static targets = ["photo"]

  connect() {
    console.log("Zoom controller")
  }

  zoom = () => {
    // event.target.classList.toggle("zoomed")
    console.log(this.photoTargets)
    this.photoTargets.forEach(photo => {
      photo.classList.toggle("zoomed")
    })
  }
}
