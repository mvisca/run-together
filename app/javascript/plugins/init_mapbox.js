import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10',
    center: [-74.5, 40], // starting position [lng, lat]
  });
};

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    new mapboxgl.Marker()
      .setLngLat([marker.lng, marker.lat])
      .addTo(map);
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    const map = buildMap(mapElement);
    const markers = JSON.parse(mapElement.dataset.markers);

    console.log('Mapbox initializing with', markers.length, 'markers');

    // Wait for map to load before adding markers
    map.on('load', () => {
      console.log('Map loaded successfully');

      if (markers.length > 0) {
        addMarkersToMap(map, markers);
        fitMapToMarkers(map, markers);
      } else {
        console.warn('No markers to display on map');
        // Center on Spain if no markers
        map.setCenter([-3.7038, 40.4168]); // Madrid, España
        map.setZoom(5);
      }
    });

    // Handle map errors
    map.on('error', (e) => {
      console.error('Mapbox error:', e);
    });
  }
};

export { initMapbox };
