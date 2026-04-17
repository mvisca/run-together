import { application } from "./application"
import MapController from "./map_controller"
import DropdownController from "./dropdown_controller"
import ChatController from "./chat_controller"
import MessageFormController from "./message_form_controller"

application.register("map", MapController)
application.register("dropdown", DropdownController)
application.register("chat", ChatController)
application.register("message-form", MessageFormController)

export { application }