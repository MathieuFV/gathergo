import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["element", "carouselImage"]

  connect() {
    console.log("Scroll controller connecté")
    window.addEventListener("scroll", this.handleScroll.bind(this))
  }

  disconnect() {
    // Nettoyage des écouteurs
    window.removeEventListener("scroll", this.handleScroll.bind(this))
  }

  handleScroll() {
    // Récupère la position de l'élément cible
    const elementPosition = this.elementTarget.getBoundingClientRect()

    // Vérifie si l'élément est en haut de la fenêtre
    if (elementPosition.top <= 0) {
      console.log("En haut")
      this.elementTarget.classList.add("--on-top")
    } else {
      console.log("Pas en haut")
      this.elementTarget.classList.remove("--on-top")
    }
  }
}
