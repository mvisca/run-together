import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    this.subscription = consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: this.conversationId },
      {
        received: (data) => {
          this.element.insertAdjacentHTML("beforeend", data.message)
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

  get conversationId() {
    return this.element.dataset.conversationId
  }
}
