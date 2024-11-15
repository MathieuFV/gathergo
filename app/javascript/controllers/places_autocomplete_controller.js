// app/javascript/controllers/places_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "form", "hiddenInput", "modal", "destinationName", "proposalsList", "noResults", "addDestination", "separator", "searchSeparator"]

  connect() {
    this.performSearch = this.performSearch.bind(this)
    this.debouncedSearch = this.debounce(this.performSearch, 300)
    this.initModal()
    
    // Ajouter un event listener pour le blur
    this.inputTarget.addEventListener('blur', () => {
      // On utilise setTimeout pour permettre la sélection d'un résultat avant de les cacher
      setTimeout(() => {
        this.hideResults()
      }, 200)
    })
  }

  initModal() {
    if (typeof bootstrap !== 'undefined') {
      this.modal = new bootstrap.Modal(this.modalTarget)
    } else {
      console.error('Bootstrap is not loaded')
    }
  }

  onInput(event) {
    const query = event.target.value.trim().toLowerCase()
    
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
    const proposals = this.proposalsListTarget.querySelectorAll('.proposal-section')
    let visibleCount = 0

    // Gérer l'affichage des séparateurs
    this.separatorTargets.forEach(separator => {
      if (query.length > 0) {
        separator.classList.add('d-none')
      } else {
        separator.classList.remove('d-none')
      }
    })

    // Gérer l'affichage du séparateur de recherche
    if (query.length > 0) {
      this.searchSeparatorTarget.classList.remove('d-none')
    } else {
      this.searchSeparatorTarget.classList.add('d-none')
    }

    proposals.forEach(proposal => {
      const searchableName = proposal.dataset.searchableName.toLowerCase()
      if (searchableName.startsWith(query)) {
        proposal.classList.remove('d-none')
        visibleCount++
      } else {
        proposal.classList.add('d-none')
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
    console.log('Showing results:', data)
    
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
    
    this.hideResults()
    this.filterExistingDestinations(mainText.toLowerCase())
    
    // Si aucune destination ne correspond, afficher le bouton d'ajout
    if (this.noResultsTarget.classList.contains('d-none') === false) {
      this.addDestinationTarget.classList.remove('d-none')
      this.addDestinationTarget.querySelector('span').textContent = mainText
    } else {
      this.addDestinationTarget.classList.add('d-none')
    }
  }

  confirmDestination() {
    this.modal.hide()
    this.formTarget.submit()
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
}
