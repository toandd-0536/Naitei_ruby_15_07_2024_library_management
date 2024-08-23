import { Controller } from '@hotwired/stimulus';
import '../settings/quill';

export default class extends Controller {
  static targets = ['form', 'quillTextarea', 'starRatingInput', 'hiddenRating'];

  connect() {
    this.initializeQuill();
    this.setupStarRating();
    this.resetForm();
  }

  initializeQuill() {
    this.quillTextareaTargets.forEach(element => {
      if (!element.__quill) {
        element.__quill = new Quill(element, { theme: 'snow' });
      }
    });
  }

  setupStarRating() {
    const ratingValue = this.hiddenRatingTarget.value;
    if (ratingValue) {
      document.getElementById(`star_${ratingValue}`).checked = true;
    }

    this.starRatingInputTargets.forEach(radio => {
      radio.addEventListener('change', () => {
        this.hiddenRatingTarget.value = radio.value;
      });
    });
  }

  resetForm() {
    if (this.formTarget) {
      this.formTarget.reset();
      // Resetting Quill content
      this.quillTextareaTargets.forEach(element => {
        if (element.__quill) {
          element.__quill.root.innerHTML = '';
        }
      });
      // Unchecking star rating inputs
      this.starRatingInputTargets.forEach(radio => {
        radio.checked = false;
      });
      // Resetting hidden rating field
      if (this.hiddenRatingTarget) {
        this.hiddenRatingTarget.value = '';
      }
    }
  }
}
