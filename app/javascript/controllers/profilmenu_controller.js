import { Controller } from "@hotwired/stimulus"
import { toggle } from "el-transition"

// Connects to data-controller="profilmenu"
export default class extends Controller {
  static targets = ["MobileMenu", "DesktopMenu"]
  connect() {
    console.log("Controller > Profil Menu : ", this.element);
  }

  toggleDesktopMenu() {
//    this.DesktopMenuTarget.classList.toggle("hidden")
    toggle(this.DesktopMenuTarget);
  }

  toggleMobileMenu() {
//    this.MobileMenuTarget.classList.toggle("hidden")
    toggle(this.MobileMenuTarget);
  }

}
