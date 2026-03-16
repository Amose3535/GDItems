# item_stack.gd
extends Resource
class_name ItemStack
## The middleman between everything for the Item.
##
## Item is the data, ItemStack is the instance.

## The item held by the stack
@export var item: Item
## How many items are there for that specific item
@export var amount: int = 1
