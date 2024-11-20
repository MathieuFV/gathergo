import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]
  static values = {
    startDate: String,
    endDate: String,
    currentUserDates: Array,
  };

  connect() {
    console.log("Connected to flatpickr stimulus", this.element)
    console.log("values:" + this.currentUserDatesValue)

    // this.startDateTarget.value

    this.calendar = flatpickr(this.startDateTarget, {
      // dateFormat: "F j, Y",
      inline: true,
      mode: "multiple",
      minDate: this.startDateValue,
      maxDate: this.endDateValue,
      position: "auto center",
      closeOnSelect: true,
      // mode: "multiple",
      defaultDate: this.currentUserDatesValue,
      dateFormat: "Y-m-d",
      onClose: (selectedDates) => {
        console.log("end date:" + selectedDates)
      }
    });
  }

  // Désactiver les dates en dehors des dates du trip
    // Récupération des dates du trip dans le controller
    // Envoie des dates au controller stimulus
    // Activation de l'option du calendrier pour activer seulement ces dates là
    // = Centrer le calendrier sur la première date du trip

  // Afficher les dates déjà entrées par l'utilisateur
  // Permettre d'ajouter 1 à X disponibilités

  openCalendar = () => {
    console.log("coucou");
  }
}

// clickOpens: false  //Whether clicking on the input should open the picker. You could disable this if you wish to open the calendar manually with.open()
