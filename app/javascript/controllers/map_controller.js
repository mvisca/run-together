import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";
// import "mapbox-gl/dist/mapbox-gl.css";

export default class extends Controller {
	static values = { view: String}

	connect() {
		// Configura el token de Mapbox
		mapboxgl.accessToken = this.element.dataset.mapboxApiKey;
		// Crea el mapa
		this.map = this.buildMap();
		// Obtiene markers del data attriute
		const markers = JSON.parse(this.element.dataset.markers || '[]'); 
		console.log('Markers data:', markers);

		this.map.on('load', () => {
			if (markers.length > 0) {
				// Si hay markers, agregar y ajustar vista de mapa
				if (this.viewValue === "index") {
					// Si es index mostrar con popups
					this.addMarkersWithPopup(markers);
				} else {
					this.addSimpleMarkers(markers);
				}
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
	
	addSimpleMarkers(markers) {
		markers.forEach(marker => 
			new mapboxgl.Marker()
				.setLngLat([marker.lng, marker.lat])
				.addTo(this.map)
		)
	}

	addMarkersWithPopup(markers) {
		markers.forEach(marker => {
			const popup = new mapboxgl.Popup({ offset: 25 })
				. setHTML(this.buildPopupHTML(marker));
				
			new mapboxgl.Marker()
				.setLngLat([marker.lng, marker.lat])
				.setPopup(popup)
				.addTo(this.map);
		});
	}

	buildPopupHTML(marker) {
		const avatarHTML = marker.creator_avatar
			? `<img src="${marker.creator_avatar}" class="popup-avatar" alt="${marker.creator_name}">`
			: `<div class="popup-avatar-placeholder">${marker.creator_name[0]}</div>`;

			return `
				<div class="race-popup">
					<h3 class="popup-title">${marker.name}</h3>

					<div class="popup-info">
						<p><strong>📍</strong> ${marker.meet_point}</p>
				        <p><strong>📏</strong> ${marker.distance} km</p>
				        <p><strong>📅</strong> ${marker.date}</p>
				        <p><strong>👥</strong> ${marker.runners_count} runners</p>
					</div>

					<div class="popup-creator">
        				${avatarHTML}
        				<span>Creado por ${marker.creator_name}</span>
      				</div>

					<a href="${marker.url}" class="popup-btn">Ver detalles →</a>
				</div>
  			`;
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