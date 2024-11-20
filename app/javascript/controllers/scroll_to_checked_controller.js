import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-checked"
export default class extends Controller {
  static targets = ["scrollArea", "checkedCell"];

  connect() {
    const stickyColumnWidth = document.querySelector('.user-cell').offsetWidth;

    console.log(stickyColumnWidth);

    const firstCheckedCell = this.checkedCellTargets[0];
    if (firstCheckedCell) {
      firstCheckedCell.scrollIntoView({
        behavior: 'smooth', // Défilement fluide
        block: 'center',    // Centré verticalement
        inline: 'nearest'    // Centré horizontalement
      });
    }
  }
}
