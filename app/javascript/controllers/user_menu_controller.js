import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["offcanvas", "overlay"]

  toggleMenu() {
    this.offcanvasTarget.classList.remove("d-none")
    this.overlayTarget.classList.remove("d-none")
    
    // Animation
    requestAnimationFrame(() => {
      this.offcanvasTarget.classList.add("active")
      this.overlayTarget.classList.add("active")
    })
  }

  closeMenu() {
    this.offcanvasTarget.classList.remove("active")
    this.overlayTarget.classList.remove("active")
    
    setTimeout(() => {
      this.offcanvasTarget.classList.add("d-none")
      this.overlayTarget.classList.add("d-none")
    }, 300)
  }
} 