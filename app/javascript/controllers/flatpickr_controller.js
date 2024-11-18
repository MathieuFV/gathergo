import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]

  connect() {
    console.log("Connected to flatpickr stimulus", this.element)

    this.startDateTarget.value

    this.calendar = flatpickr(this.startDateTarget, {
      dateFormat: "F j, Y",
      mode: "range",
      inline: true,
      position: "above center",
      closeOnSelect: true,
      onClose: (selectedDates) => {
        this.startDateTarget.value = selectedDates[0]
        this.endDateTarget.value = selectedDates[1]
        console.log("end date:" + this.endDateTarget.value)
      }
    });
  }

  openCalendar = () => {
    console.log("coucou");
  }
}

// clickOpens: false  //Whether clicking on the input should open the picker. You could disable this if you wish to open the calendar manually with.open()
