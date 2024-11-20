import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]
  static values = {
    startDate: String,
    endDate: String
  };

  connect() {
    console.log("Connected to flatpickr stimulus", this.element)
    console.log("value:" + this.endDateValue)

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
      // defaultDate: ["2024-11-20", "2024-11-04", "2024-11-23", "2024-11-25"],
      dateFormat: "Y-m-d",
      onClose: (selectedDates) => {
        this.startDateTarget.value = selectedDates[0]
        this.endDateTarget.value = selectedDates[1]
        console.log("end date:" + this.endDateTarget.value)
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

  range = () => {
    console.log("Range")
    // this.calendar.clear();
    this.calendar.set('mode', 'range'); // Change le mode en "range"
  }

  openCalendar = () => {
    console.log("coucou");
  }
}

// clickOpens: false  //Whether clicking on the input should open the picker. You could disable this if you wish to open the calendar manually with.open()
