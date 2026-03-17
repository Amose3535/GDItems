# event_component.gd
@abstract
extends ItemComponent
class_name EventComponent
## This is a special type of item component which is triggered through an event instead of every custom tick like TickingComponent

## The list of events which the execute functino should lsiten to. The exact implementation however is up to the user.[br]
## How i intrerpret it is: If ANY of the following events appear in the context of the execute, then it should run.
@export var listen_events: Array[String] = []

## In this class, execute gets called when an event is triggered. However, the way this happens (input event, custom game event, etc) is handled from the container of this item.
@abstract func execute(context: Dictionary[String, Variant] = {}) -> void
