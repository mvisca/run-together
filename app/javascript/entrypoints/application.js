// This file is automatically compiled by esbuild
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import { initMapbox } from '../plugins/init_mapbox'

// Start ActiveStorage
ActiveStorage.start()

document.addEventListener('turbo:load', () => {
  initMapbox();
  console.log('DESDE TURBO LOAD');
})
