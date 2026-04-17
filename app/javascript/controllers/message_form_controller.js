import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit(event) {
    event.preventDefault()
    if (!this.inputTarget.value.trim()) return

    fetch(this.element.action, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: new URLSearchParams({ body: this.inputTarget.value })
    }).then(() => {
      this.inputTarget.value = ""
      this.inputTarget.focus()
    })
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submit(event)
    }
  }
}
