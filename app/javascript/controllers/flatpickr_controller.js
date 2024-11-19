import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]

  connect() {
    console.log("Connected to flatpickr stimulus", this.element)

    this.startDateTarget.value

    this.calendar = flatpickr(this.startDateTarget, {
      // dateFormat: "F j, Y",
      inline: true,
      // mode: "multiple",
      mode: "range",
      position: "auto center",
      closeOnSelect: true,
      mode: "multiple",
      dateFormat: "Y-m-d",
      onClose: (selectedDates) => {
        this.startDateTarget.value = selectedDates[0]
        this.endDateTarget.value = selectedDates[1]
        console.log("end date:" + this.endDateTarget.value)
      }
    });
  }

  range = () => {
    console.log("Range")
    this.calendar.clear();
    this.calendar.set('mode', 'range'); // Change le mode en "range"
  }

  openCalendar = () => {
    console.log("coucou");
  }
}

// clickOpens: false  //Whether clicking on the input should open the picker. You could disable this if you wish to open the calendar manually with.open()
