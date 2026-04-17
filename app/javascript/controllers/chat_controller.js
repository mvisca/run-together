import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    this.subscription = consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: this.conversationId },
      {
        received: (data) => {
          this.element.insertAdjacentHTML("beforeend", this.buildMessage(data))
          this.scrollToBottom()
        }
      }
    )
  }

  disconnect() {
    this.subscription?.unsubscribe()
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  buildMessage(data) {
    const own = data.user_id === this.currentUserId
    const align = own ? "justify-content-end" : "justify-content-start"
    const textAlign = own ? "text-end" : "text-start"
    const bubble = own ? "bg-info text-white" : "bg-white text-dark"
    const timeColor = own ? "text-white-50" : "text-muted"
    const nameHtml = own ? "" : `<small class="text-muted fw-semibold d-block mb-1">${data.user_name}</small>`

    return `
      <div class="d-flex mb-3 ${align}">
        <div class="${textAlign}" style="max-width: 70%;">
          ${nameHtml}
          <div class="d-inline-block px-3 py-2 rt-rounded rt-shadow ${bubble}">
            <p class="mb-1">${data.body}</p>
            <small class="${timeColor}" style="font-size: 0.7rem;">${data.created_at}</small>
          </div>
        </div>
      </div>`
  }

  get conversationId() {
    return this.element.dataset.conversationId
  }

  get currentUserId() {
    return parseInt(this.element.dataset.currentUserId)
  }
}
