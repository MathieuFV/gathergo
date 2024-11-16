import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "input"]

  connect() {
    console.log("Trip index search controller connected")
  }

  onSearchFocus() {
    console.log("Focus event triggered")
    this.overlayTarget.classList.remove('d-none')
    setTimeout(() => {
      this.overlayTarget.classList.add('active')
    }, 0)
  }

  onSearchBlur() {
    console.log("Blur event triggered")
    this.overlayTarget.classList.remove('active')
    
    const tripCards = this.element.querySelectorAll('.trip-card')
    tripCards.forEach(card => {
      card.classList.remove('search-match')
    })

    setTimeout(() => {
      this.overlayTarget.classList.add('d-none')
    }, 300)
  }

  onInput(event) {
    console.log("Input event triggered")
    const query = event.target.value.toLowerCase()
    console.log("Searching for:", query)
    this.filterTrips(query)
  }

  filterTrips(query) {
    console.log("Filtering trips")
    const tripCards = this.element.querySelectorAll('.trip-card-link')
    console.log("Found trip cards:", tripCards.length)
    
    tripCards.forEach(cardLink => {
      const card = cardLink.querySelector('.trip-card')
      const searchableName = card.dataset.searchableName
      console.log("Trip name:", searchableName, "Query:", query)
      
      if (searchableName.startsWith(query)) {
        console.log("Match found for:", searchableName)
        cardLink.classList.remove('d-none')
        card.classList.add('search-match')
      } else {
        console.log("No match for:", searchableName)
        cardLink.classList.add('d-none')
        card.classList.remove('search-match')
      }
    })
  }
} 