import { application } from "./application"
import MapController from "./map_controller"
import DropdownController from "./dropdown_controller"

application.register("map", MapController)
application.register("dropdown", DropdownController)

export { application }