import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configuracion para desarrollo
application.debug = false;
window.Stimulus = application;

export { application };