// This file is automatically compiled by esbuild
import "@rails/ujs"
import "turbolinks"
import "@rails/activestorage"
import "channels"
import "bootstrap"
import { initMapbox } from '../plugins/init_mapbox'

// Start Rails UJS
import Rails from "@rails/ujs"
Rails.start()

// Start Turbolinks
import Turbolinks from "turbolinks"
Turbolinks.start()

// Start ActiveStorage
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

document.addEventListener('turbolinks:load', () => {
  initMapbox();
  console.log('DESDE TURBOLINKS LOAD');
})
