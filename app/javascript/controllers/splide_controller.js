import { Controller } from '@hotwired/stimulus';
import Splide from '@splidejs/splide';

export default class extends Controller {
  connect() {
    const splide = new Splide(this.element, {
      height: 400,
      perPage: 1,
      focus : 'center',
      type: "loop"
    });

    splide.mount();
  }
}
