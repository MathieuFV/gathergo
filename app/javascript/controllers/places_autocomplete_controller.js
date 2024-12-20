// app/javascript/controllers/places_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "form", "hiddenInput", "proposalsList", "noResults", "addDestination", "separator", "searchSeparator", "overlay"]

  static outlets = ["places-autocomplete"]

  connect() {
    this.performSearch = this.performSearch.bind(this)
    this.debouncedSearch = this.debounce(this.performSearch, 300)
    
    // Ajouter un event listener pour le blur
    this.inputTarget.addEventListener('blur', () => {
      // On utilise setTimeout pour permettre la sélection d'un résultat avant de les cacher
      setTimeout(() => {
        this.hideResults()
      }, 200)
    })
  }

  onInput(event) {
    const query = event.target.value.trim().toLowerCase()
    
    // On cache systématiquement le bouton d'ajout dès qu'on tape
    this.addDestinationTarget.classList.add('d-none')
    
    // Filtrer les destinations existantes
    this.filterExistingDestinations(query)
    
    // Gérer l'autocomplete
    if (query.length >= 3) {
      this.debouncedSearch(query)
    } else {
      this.hideResults()
    }
  }

  filterExistingDestinations(query) {
    // Trouver les séparateurs dans proposalsList comme pour les proposals
    const separators = this.proposalsListTarget.querySelectorAll('[data-places-autocomplete-target="separator"]')
    const proposals = this.proposalsListTarget.querySelectorAll('.proposal-section')
    let visibleCount = 0

    console.log("Nombre de séparateurs trouvés:", separators.length)

    // Gérer les séparateurs
    separators.forEach(separator => {
      console.log("Traitement du séparateur:", separator)
      if (query.length > 0) {
        console.log("Masquage du séparateur de classement")
        separator.classList.add('d-none')
      } else {
        console.log("Affichage du séparateur de classement")
        separator.classList.remove('d-none')
      }
    })

    // Gérer le séparateur de recherche
    if (query.length > 0) {
      console.log("Affichage du séparateur de recherche")
      this.searchSeparatorTarget.classList.remove('d-none')
    } else {
      console.log("Masquage du séparateur de recherche")
      this.searchSeparatorTarget.classList.add('d-none')
    }

    // Gérer les proposals
    proposals.forEach(proposal => {
      const searchableName = proposal.dataset.searchableName.toLowerCase()
      const proposalCard = proposal.querySelector('.proposal-card')
      
      if (searchableName.startsWith(query)) {
        proposal.classList.remove('d-none')
        proposalCard.classList.add('search-match')
        visibleCount++
      } else {
        proposal.classList.add('d-none')
        proposalCard.classList.remove('search-match')
      }
    })

    // Gérer l'affichage du message "No results"
    if (visibleCount === 0) {
      this.noResultsTarget.classList.remove('d-none')
    } else {
      this.noResultsTarget.classList.add('d-none')
    }
  }

  async performSearch(query) {
    try {
      const response = await fetch(`/api/places/autocomplete?input=${encodeURIComponent(query)}`)
      if (!response.ok) throw new Error('Erreur réseau')
      
      const data = await response.json()
      this.showResults(data)
    } catch (error) {
      console.error('Error searching places:', error)
    }
  }

  showResults(data) {
    const predictions = data.predictions || []

    if (!predictions.length) {
      this.hideResults()
      return
    }

    this.resultsTarget.innerHTML = `
      <div class="results-list is-active">
        ${predictions.map(place => `
          <button
            type="button"
            class="result-item"
            data-action="click->places-autocomplete#selectResult"
            data-place-id="${place.place_id}"
          >
            <i class="fa-solid fa-location-dot"></i>
            <div class="result-content">
              <div class="result-main">${place.structured_formatting.main_text}</div>
              <div class="result-secondary">${place.structured_formatting.secondary_text}</div>
            </div>
          </button>
        `).join('')}
      </div>
    `
  }

  hideResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ''
      this.resultsTarget.classList.remove('is-active')
    }
  }

  selectResult(event) {
    const placeId = event.currentTarget.dataset.placeId
    const mainText = event.currentTarget.querySelector('.result-main').textContent
    
    this.inputTarget.value = mainText
    this.hiddenInputTarget.value = mainText
    this.lastSelectedSuggestion = mainText
    
    this.hideResults()
    this.filterExistingDestinations(mainText.toLowerCase())
    this.onSearchBlur()
    
    // Si aucune destination ne correspond, afficher le bouton d'ajout
    if (this.noResultsTarget.classList.contains('d-none') === false) {
      this.addDestinationTarget.classList.remove('d-none')
      this.addDestinationTarget.querySelector('span').textContent = mainText
      this.addDestinationTarget.querySelector('button').setAttribute('data-action', 'click->places-autocomplete#submitForm')
    } else {
      this.addDestinationTarget.classList.add('d-none')
    }
  }

  submitForm(event) {
    event.preventDefault()
    this.formTarget.requestSubmit()
  }

  onKeydown(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      const selectedResult = this.resultsTarget.querySelector('.result-item')
      if (selectedResult) {
        selectedResult.click()
      }
    }
  }

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }

  disconnect() {
    this.hideResults()
  }

  focusSearch() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })

    setTimeout(() => {
      this.inputTarget.focus()
    }, 300)
  }

  onSearchFocus() {
    console.log("Focus event triggered")
    this.overlayTarget.classList.remove('d-none')
    console.log("d-none removed")
    setTimeout(() => {
      this.overlayTarget.classList.add('active')
      console.log("active class added")
    }, 0)
  }

  onSearchBlur() {
    console.log("Blur event triggered")
    this.overlayTarget.classList.remove('active')
    
    // Nettoyer les classes search-match sur les cards
    const proposalCards = this.proposalsListTarget.querySelectorAll('.proposal-card')
    proposalCards.forEach(card => {
      card.classList.remove('search-match')
    })

    setTimeout(() => {
      this.overlayTarget.classList.add('d-none')
      console.log("d-none added back")
    }, 300)
  }
}
