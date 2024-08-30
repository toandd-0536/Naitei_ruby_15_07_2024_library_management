import { Controller } from '@hotwired/stimulus';
import '../settings/quill';

export default class extends Controller {
  static targets = ['form', 'quillTextarea', 'starRatingInput', 'hiddenRating'];

  connect() {
    this.setupQuill();
    this.setupStarRating();

    if (!this.hasUserRating()) {
      this.resetForm();
    }
  }

  setupQuill() {
    const initialContent = document.getElementById('hidden-body-field')?.value || '';
    this.initializeQuill(initialContent);
  }

  initializeQuill(initialContent) {
    this.quillTextareaTargets.forEach(element => {
      if (!element.__quill) {
        element.classList.add('quill-editor');
        element.__quill = new Quill(element, { theme: 'snow' });
      }

      if (initialContent) {
        element.__quill.root.innerHTML = initialContent;
        console.log('Initial Content:', initialContent);
      }

      element.__quill.on('text-change', () => {
        const hiddenBodyField = document.getElementById('hidden-body-field');
        if (hiddenBodyField) {
          hiddenBodyField.value = element.__quill.root.innerHTML;
          console.log('Textarea Value:', hiddenBodyField.value);
        }
      });
    });
  }

  setupStarRating() {
    const ratingValue = this.hiddenRatingTarget?.value || '';
    if (ratingValue) {
      const starInput = document.getElementById(`star_${ratingValue}`);
      if (starInput) {
        starInput.checked = true;
      }
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
      this.quillTextareaTargets.forEach(element => {
        if (element.__quill) {
          element.__quill.root.innerHTML = '';
        }
      });
      this.starRatingInputTargets.forEach(radio => {
        radio.checked = false;
      });
      if (this.hiddenRatingTarget) {
        this.hiddenRatingTarget.value = '';
      }
    }
  }

  reset_form() {
    this.resetForm();
  }

  hasUserRating() {
    const userRatingElement = document.querySelector('[data-user-rating]');
    return userRatingElement?.dataset.userRating === 'true';
  }
}
