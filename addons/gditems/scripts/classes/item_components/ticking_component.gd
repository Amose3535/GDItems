# ticking_component.gd
@abstract
extends ItemComponent
class_name TickingComponent
## An item component class designed to automatically call its execute function whenever an item tick passes. 


## This function runs only when called manually or when it's owner item is in a stack which ticks
@abstract func execute(context: Dictionary[String, Variant] = {}) -> void
