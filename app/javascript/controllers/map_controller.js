import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";

export default class extends Controller {
	connect() {
		// Configura el token de Mapbox
		mapboxgl.accessToken = this.element.dataset.mapboxApiKey;
		
		// Crea el mapa
		this.map = this.buildMap();
		
		// Obtiene markers del data attriute
		const markers = JSON.parse(this.element.dataset.markers || '[]'); 
		
		this.map.on('load', () => {
			if (markers.length > 0) {
				// Si hay markers, agregar y ajustar vista de mapa
				this.addMarkers(markers);
				this.fitBounds(markers);
			} else {
				// Sin markers centra en punto default
				this.map.setCenter([2.15400, 41.390205]);
				this.map.setZoom(5);
			} 
		});
	}
	
	buildMap() {
		return new mapboxgl.Map({
			container: this.element,
			style: 'mapbox://styles/mapbox/streets-v12',
			center: [2.154007, 41.390205],
			zoom: 9
		});		
	}
	
	addMarkers(markers) {
		markers.forEach(marker => 
			new mapboxgl.Marker()
				.setLngLat([marker.lng, marker.lat])
				.addTo(this.map)
		)
	}
	
	fitBounds(markers) {
		const bounds = new mapboxgl.LngLatBounds();
		markers.forEach(marker => bounds.extend([marker.lng, marker.lat]))
	
		this.map.fitBounds(bounds, {
			padding: 70,
			maxZoom: 15
		});
	}

	disconnect() {
		if (this.map) {
			this.map.remove();
		}
	}
}