import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["startDate", "submitButton"];
  static values = {
    startDate: String,
    endDate: String,
    currentUserDates: Array,
  };

  connect() {
    this.initFlatpickr();
  }

  initFlatpickr() {
    this.calendar = flatpickr(this.startDateTarget, {
      dateFormat: "Y-m-d",
      inline: true,
      mode: "multiple",
      minDate: this.startDateValue,
      maxDate: this.endDateValue,
      position: "auto center",
      closeOnSelect: true,
      defaultDate: this.currentUserDatesValue,
      onChange: this.updateDates
    });

    // Cacher le bouton initialement
    this.submitButtonTarget.classList.add("invisible");
  }

  formatDate = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  datesHaveChanged = (selectedDates, originalDates) => {
    const formattedSelectedDates = selectedDates.map(this.formatDate);

    if (formattedSelectedDates.length !== originalDates.length) {
      return true;
    }

    const sortedSelected = [...formattedSelectedDates].sort();
    const sortedOriginal = [...originalDates].sort();

    return sortedSelected.some((date, index) => date !== sortedOriginal[index]);
  };

  updateDates = (selectedDates) => {
    const hasChanged = this.datesHaveChanged(selectedDates, this.currentUserDatesValue);
    this.submitButtonTarget.classList.toggle("invisible", !hasChanged);

    const formattedDates = selectedDates.map(this.formatDate).join(',');
    this.startDateTarget.value = formattedDates;
  };
}
