import { Controller } from '@hotwired/stimulus'
import { Datepicker } from 'vanillajs-datepicker';
import { isEmpty } from 'lodash-es';
import Swal from 'sweetalert2';

// Connects to data-controller="reservation"
export default class extends Controller {
  static targets = ['checkin', 'checkout', 'numOfSeances', 'seanceTotal', 'serviceFee', 'total'];

  connect() {
    console.log("Controller > Reservation : ", this.element.dataset);
    const checkinPicker = new Datepicker(this.checkinTarget, {
      minDate: this.element.dataset.defaultCheckinDate,
      datesDisabled: ['11/27/2022','11/28/2022']
    });

    const checkoutPicker = new Datepicker(this.checkoutTarget, {
      minDate: this.element.dataset.defaultCheckoutDate,
      datesDisabled: ['11/27/2022','11/28/2022']
    });

    this.checkinTarget.addEventListener('changeDate', (e) => {
      const date = new Date(e.target.value);
      date.setDate(date.getDate() + 1);
      checkoutPicker.setOptions({
        minDate: date
      });
      this.updateseanceTotal();
    });

    this.checkoutTarget.addEventListener('changeDate', (e) => {
      const date = new Date(e.target.value);
      date.setDate(date.getDate() - 1);
      checkinPicker.setOptions({
        maxDate: date
      });
      this.updateseanceTotal();
    });
  }

  calculateseanceTotal() {
    return this.numberOfSeances() * this.element.dataset.seancePrice;
    //return this.numberOfSeances() * 0,5;
  }

  updateseanceTotal() {
    this.numOfSeancesTarget.textContent = this.numberOfSeances();
    this.seanceTotalTarget.textContent = this.calculateseanceTotal();
    this.updateServiceFee();
  }

  calculateServiceFee() {
    //return (this.calculateseanceTotal() * this.element.dataset.serviceFeePercentage).toFixed(2);
    return (this.calculateseanceTotal() * 0.05).toFixed(2);
  }

  updateServiceFee() {
    this.serviceFeeTarget.textContent = this.calculateServiceFee();
    this.updateTotal();
  }

  calculateTotal() {
    return (+this.calculateseanceTotal() + +this.calculateServiceFee()).toFixed(2);
  }

  updateTotal() {
    this.totalTarget.textContent = this.calculateTotal();
  }

  numberOfSeances() {
    if (isEmpty(this.checkinTarget.value) || isEmpty(this.checkoutTarget.value)) {
      return 0;
    }
    const DAY_TIME = 24 * 60 * 60 * 1000;
    const arr = [
      new Date('12/05/2022'),
      new Date('12/08/2022'),
    ];

    const checkinDate = new Date(this.checkinTarget.value);
    const checkoutDate = new Date(this.checkoutTarget.value);

    var loop = new Date(checkinDate);
    var number = 0;

    while(loop <= checkoutDate){
      //console.log('text', loop.getTime())   
      //console.log('text', loop)         
      const date = arr.find(
        date => date.getTime() === loop.getTime()
      );
      if (date !== undefined) {
        number++;
      }
    
      var newDate = loop.setDate(loop.getDate() + 1);
      loop = new Date(newDate);
    }

    // To calculate the time difference of two dates
    // And calculate the no. of days between two dates
    return ((checkoutDate - checkinDate) / (DAY_TIME) - number);
  }

  buildReservationParams() {
    const params = {
      checkin_date: this.checkinTarget.value,
      checkout_date: this.checkoutTarget.value,
      subtotal: this.calculateseanceTotal(),
      service_fee: this.calculateServiceFee(),
      total: this.calculateTotal(),
    };

    const searchParams = new URLSearchParams(params);
    return searchParams.toString();
  }

  buildSubmitUrl(url) {
    return `${url}?${this.buildReservationParams()}`;
  }

  submitReservation(e) {
    if (isEmpty(this.checkinTarget.value) || isEmpty(this.checkoutTarget.value)) {
      Swal.fire({
        text: 'Please select both the checkin and the checkout dates',
        icon: 'error'
      });
      return;
    }

    Turbo.visit(this.buildSubmitUrl(e.target.dataset.submitUrl));
  }
}