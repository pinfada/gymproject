import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="gymhouse"
export default class extends Controller {
    connect() {
        console.log("Controller > Gymhouse : ", this.element.dataset);
    }
    readDescription(e) {
        e.preventDefault();

        document.getElementById('gymhouse-description-trigger').click();
    }
}