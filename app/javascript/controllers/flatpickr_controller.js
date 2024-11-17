import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    console.log("Connected to flatpickr stimulus", this.element)

    flatpickr(this.element.querySelector(".start-date"), {
      dateFormat: "F j, Y",
      mode: "range"
    });
    flatpickr(this.element.querySelector(".end-date"), {
      dateFormat: "F j, Y"
    });
  }
}
