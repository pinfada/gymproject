import { Controller } from "@hotwired/stimulus"
import { getDistance, convertDistance } from 'geolib';
import { isEmpty } from 'lodash-es';

// Connects to data-controller="geolocation"
export default class extends Controller {
  static targets = ["GymLocation"]

  connect() {
    console.log("Controller > Géolocation : ", this.element);
    if (isEmpty(this.element.dataset.latitude) && isEmpty(this.element.dataset.longitude)) {
      window.navigator.geolocation.getCurrentPosition((position) => {
        this.setUserCoordinates(position.coords);
        this.setDistanceText()
      });
    } else {
      this.setDistanceText();
    }
  }

  setUserCoordinates(coordinates) {
    this.element.dataset.latitude = coordinates.latitude;
    this.element.dataset.longitude = coordinates.longitude;
  }

  getUserCoordinates() {
    return {
      latitude: this.element.dataset.latitude,
      longitude: this.element.dataset.longitude,
    };
  }

  setDistanceText() {
    this.GymLocationTargets.forEach((GymLocationTarget) => {
      let distanceFrom = getDistance(
        this.getUserCoordinates(),
        { latitude: GymLocationTarget.dataset.latitude, longitude: GymLocationTarget.dataset.longitude },
      );

      GymLocationTarget.querySelector('[data-distance-away]').innerHTML = `${Math.round(convertDistance(distanceFrom, 'km'))} km de distance `;
    });
  }

}
