// app/javascript/controllers/places_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "form", "hiddenInput"]

  connect() {
    this.performSearch = this.performSearch.bind(this)
    this.debouncedSearch = this.debounce(this.performSearch, 300)
  }

  onInput(event) {
    const query = event.target.value.trim()
    if (query.length < 2) {
      this.hideResults()
      return
    }
    this.debouncedSearch(query)
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
