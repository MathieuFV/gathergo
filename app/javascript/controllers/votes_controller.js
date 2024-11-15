import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  add(event) {
    event.preventDefault()
    const form = event.target
    const tripId = form.dataset.tripId
    const destinationId = form.dataset.destinationId
    const proposalSection = this.element.closest('.proposal-section')

    fetch(`/trips/${tripId}/destinations/${destinationId}/votes`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.replaceButton(true, tripId, destinationId)
        this.updateVoteCount(data.votes_count, proposalSection)
      }
    })
    .catch(error => console.error('Error:', error))
  }

  remove(event) {
    event.preventDefault()
    const form = event.target
    const tripId = form.dataset.tripId
    const destinationId = form.dataset.destinationId
    const proposalSection = this.element.closest('.proposal-section')

    fetch(`/trips/${tripId}/destinations/${destinationId}/votes`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.replaceButton(false, tripId, destinationId)
        this.updateVoteCount(data.votes_count, proposalSection)
      }
    })
    .catch(error => console.error('Error:', error))
  }

  replaceButton(voted, tripId, destinationId) {
    const wrapper = document.createElement('div')
    const buttonHtml = voted ? 
      `<form class="button_to" method="post" action="/trips/${tripId}/destinations/${destinationId}/votes" data-controller="votes" data-action="submit->votes#remove" data-trip-id="${tripId}" data-destination-id="${destinationId}">
        <input type="hidden" name="_method" value="delete">
        <button class="btn btn-danger vote-btn" type="submit">Downvote</button>
        <input type="hidden" name="authenticity_token" value="${document.querySelector('[name="csrf-token"]').content}">
      </form>` :
      `<form class="button_to" method="post" action="/trips/${tripId}/destinations/${destinationId}/votes" data-controller="votes" data-action="submit->votes#add" data-trip-id="${tripId}" data-destination-id="${destinationId}">
        <button class="btn btn-primary vote-btn" type="submit">Upvote</button>
        <input type="hidden" name="authenticity_token" value="${document.querySelector('[name="csrf-token"]').content}">
      </form>`

    wrapper.innerHTML = buttonHtml
    const newForm = wrapper.firstElementChild
    this.element.replaceWith(newForm)
    
    // Réinitialiser Stimulus sur le nouveau formulaire
    const application = this.application
    application.getControllerForElementAndIdentifier(newForm, "votes")
  }

  updateVoteCount(count, proposalSection) {
    const statsItem = proposalSection.querySelector('.fa-heart').closest('.stats-item')
    statsItem.innerHTML = `<i class="fa-regular fa-heart"></i> ${count}`
  }
} 