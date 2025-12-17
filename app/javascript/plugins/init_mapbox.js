import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const buildMap = (mapElement) => {
	mapboxgl.accessToken = ProcessingInstruction.env.MAPBOX_API_KEY || mapElement.dataset.mapboxApiKey;
	
	return new mapboxgl.Map({
		container: 'map',
		style: 'mapbox://styles/mapbox/streets-v12',
		center: [2.154007, 41.390205],
		zoom: 9
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
	map.fitBounds(bounds, {
		padding: 70, 
		maxZoom: 15
	});
};

// Inicailizar con error handling
const initMapbox = () => {
	const mapElement = document.getElementById('map');
	if (!mapElement) return;
	
	try {
		// Crea el mapa
		const map = buildMap(mapElement);
		
		// Lee los markers desde el data-markers del 'map' element
		const markers = JSON.parse(mapElement.dataset.markers);
		
		
		// Espera que cargue el mapa y después los marcadores
		map.on('load', () => {
			console.log('Mapa cargado ✌️');
			
			// Valida
			if (markers.length > 0) {
				addMarkersToMap(map, markers);
				fitMapToMarkers(map, markers);
				console.log('Mapa inicializado con 📍:', markers.length, ' marcadores');
			} else {
				// Centrar mapa BCN
				map.setCenter([2.154007, 41.390205]);
				map.setZoom(5);
				console.warn('Mapa no tiene 📍 marcadores');
				// TODO : get user long lat y centrar ahí
			}
		});
		
		map.on('error', (err) => {
			console.error('Mapbox error 🔧: ', err.error);
		});
		
	} catch (err) {
		console.error('Error iniciando Mapbox 🕳️')
	}
};

export { initMapbox };
