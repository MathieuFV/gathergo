import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = [ "toggableElement" ]
  connect() {
    console.log('hello from toggle controller')
    console.log('this.toggableElementTarget')
  }
  fire(){
    this.toggableElementTarget.classList.toggle("d-none")
  }
}
