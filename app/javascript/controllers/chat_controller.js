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
    const bubbleClass = own ? "bg-info text-white" : "text-dark"
    const bubbleStyle = own ? "" : `style="background:${userColor};"`
    const timeColor = own ? "text-white-50" : "text-muted"

    const pastels = ["#ffd6d6","#ffd6f0","#e8d6ff","#d6e8ff","#d6f5ff","#d6ffd6","#fffbd6","#ffe8d6","#f0ffd6","#d6ffee","#ffd6e8","#d6f0ff","#fff0d6","#ead6ff","#d6fffa"]
    const userColor = pastels[data.user_id % pastels.length]
    const initials = data.user_name.split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase()
    const avatarHtml = data.avatar_url
      ? `<img src="${data.avatar_url}" style="width:28px;height:28px;border-radius:50%;object-fit:cover;flex-shrink:0;" />`
      : `<span style="width:28px;height:28px;border-radius:50%;background:${userColor};display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:600;flex-shrink:0;">${initials}</span>`
    const nameColor = own ? "#0dcaf0" : "#555"
    const nameHtml = `<small class="fw-semibold d-block mb-1" style="color:${nameColor};">${data.user_name}</small>`
    const avatarSlot = `<div class="${own ? 'ms-2' : 'me-2'} mt-1">${avatarHtml}</div>`

    return `
      <div class="d-flex mb-3 ${align}">
        ${own ? "" : avatarSlot}
        <div class="${textAlign}" style="max-width: 70%;">
          ${nameHtml}
          <div class="d-inline-block px-3 py-2 rt-rounded rt-shadow ${bubbleClass}" ${bubbleStyle}>
            <p class="mb-1">${data.body}</p>
            <small class="${timeColor}" style="font-size: 0.7rem;">${data.created_at}</small>
          </div>
        </div>
        ${own ? avatarSlot : ""}
      </div>`
  }

  get conversationId() {
    return this.element.dataset.conversationId
  }

  get currentUserId() {
    return parseInt(this.element.dataset.currentUserId)
  }
}
