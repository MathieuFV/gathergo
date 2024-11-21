import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-checked"
export default class extends Controller {
  static targets = ["scrollArea", "checkedCell"];

  connect() {
    // Récupère toutes les cellules cochées
    const checkedCells = this.checkedCellTargets;

    if (checkedCells.length > 0) {
      // Trouve la cellule avec la position la plus à gauche
      const leftmostCell = checkedCells.reduce((leftmost, current) => {
        // Compare les positions horizontales des cellules
        return current.getBoundingClientRect().left < leftmost.getBoundingClientRect().left
          ? current
          : leftmost;
      });

      // Scroll vers la cellule la plus à gauche
      leftmostCell.scrollIntoView({
        behavior: 'smooth',
        block: 'center',
        inline: 'center'
      });
    }
  }
}
