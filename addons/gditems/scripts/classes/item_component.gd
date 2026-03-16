# item_component.gd
@abstract
extends Resource
class_name ItemComponent
## The base component class which defines a trait of an item.

## The function to be inherited in all child classes of the ItemComponent class. This defines WHAT does the item do.
@abstract func execute(context: Dictionary[String, Variant]) -> void
