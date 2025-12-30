import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	toggle(event) {
		event.preventDefault()
		event.stopImmediatePropagation()

		const dropdown = bootstrap.Dropdown.getOrCreateInstance(this.element)
		dropdown.toggle()
	}
}