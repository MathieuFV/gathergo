import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets=["input", "button", "icon"]

  connect() {
    console.log("Comment controller ON");
    console.log(this.inputTarget.value)
    console.log(this.buttonTarget)

    this.inputTarget.addEventListener('input', () => {
      console.log('Texte mis à jour:', this.inputTarget.value);
    });
  }

  send_comment = () => {
    console.log("coucouilles")
  }

  write_comment = () => {
    console.log(this.inputTarget.value)
    this.inputTarget.value.trim().length > 0 ? this.activate_send_icon() : this.deactivate_send_icon()
  }

  activate_send_icon = () => {
    this.iconTarget.classList.replace("fa-regular", "fa-solid");
  }

  deactivate_send_icon = () => {
    this.iconTarget.classList.replace("fa-solid", "fa-regular");
  }
}
