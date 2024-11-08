import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share-trip"
export default class extends Controller {
  connect() {
    console.log("Controller stimulus pour share button ajouté");
  }

  copy_trip_url = () => {
    navigator.clipboard.writeText(window.location.href);
    console.log("Lien copié")
  }
}
