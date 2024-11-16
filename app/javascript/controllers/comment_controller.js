import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
  static targets=["input", "button", "icon", "list"]

  static values = {
    commentableType: String,
    commentableId: Number
  }

  connect() {
    console.log("Comment controller ON");
    console.log(this.inputTarget.value)
    console.log(this.buttonTarget)

    this.inputTarget.addEventListener('input', () => {
      console.log('Texte mis à jour:', this.inputTarget.value);
    });
  }

  send_comment(event) {
    event.preventDefault();

    const content = this.inputTarget.value.trim();
    if (!content) return;

    fetch('/comments', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        comment: {
          content: content,
          commentable_type: this.commentableTypeValue,
          commentable_id: this.commentableIdValue
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.html) {
        console.log(data)
        // Ajouter le nouveau commentaire au DOM
        this.listTarget.insertAdjacentHTML('beforeend', data.html);

        // Réinitialiser l'input et l'icône
        this.inputTarget.value = '';
        this.deactivate_send_icon();
      } else if (data.errors) {
        console.error("Erreurs:", data.errors);
      }
    })
    .catch(error => console.error("Erreur:", error));
  }

  write_comment = () => {
    console.log(this.inputTarget.value)

    this.adjustTextareaHeight();

    this.inputTarget.value.trim().length > 0 ? this.activate_send_icon() : this.deactivate_send_icon()
  }

  activate_send_icon = () => {
    this.iconTarget.classList.replace("fa-regular", "fa-solid");
  }

  deactivate_send_icon = () => {
    this.iconTarget.classList.replace("fa-solid", "fa-regular");
  }

  adjustTextareaHeight() {
    // Réinitialiser la hauteur pour ajuster correctement
    this.inputTarget.style.height = 'auto';
    this.inputTarget.style.height = `${this.inputTarget.scrollHeight}px`;
  }
}
