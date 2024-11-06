import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["element"] // L'élément que tu veux observer

  connect() {
    console.log("Scroll controller connecté")
    window.addEventListener("scroll", this.handleScroll.bind(this))
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll.bind(this))
  }

  handleScroll() {
    // Vérifie si l'élément est au niveau du haut de la page
    const elementPosition = this.elementTarget.getBoundingClientRect()

    if (elementPosition.top <= 0) {
      this.elementTarget.classList.add("--on-top") // Ajoute la classe
    } else {
      this.elementTarget.classList.remove("--on-top") // Retire la classe
    }
  }

  // connect() {
  //   console.log("Scroll controller");

  //   // Configuration de l'IntersectionObserver
  //   this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
  //     root: null, // par rapport au viewport
  //     rootMargin: "-100% 0px 0px 0px", // Décalage pour déclencher en haut du viewport
  //     // threshold: 0 // déclenché dès que l'élément atteint le haut
  //   })

  //   // Observer l'élément cible
  //   this.observer.observe(this.elementTarget)
  // }

  // disconnect() {
  //   this.observer.disconnect() // Déconnecte l'observateur lorsque le contrôleur est déconnecté
  // }

  // handleIntersect(entries) {
  //   entries.forEach(entry => {
  //     console.log("Intersection Observed", entry);
  //     if (entry.isIntersecting) {
  //       console.log("En haut")
  //       this.elementTarget.classList.add("fixed-style") // Ajoute la classe
  //     } else {
  //       console.log("Pas en haut")
  //       this.elementTarget.classList.remove("fixed-style") // Retire la classe
  //     }
  //   })
  // }
}
