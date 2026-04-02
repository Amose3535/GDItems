# item_inventory.gd
@tool
extends ItemContainer
class_name ItemInventory
## A specialized ItemContainer class which allows for a selection of a specific slot of the inventory, that allows to pass two different contexts depending if the item is selected or not.

## Signal emitted when the index of the selected slot changes to a different one.
signal selected_index_changed(from:int, to:int)


## Variable that represents the index of the currently selected item.
@export var selected_index: int = 0:
	set(new_index):
		if new_index == selected_index: return
		selected_index_changed.emit(selected_index,new_index)
		selected_index = new_index



## Function that updates the physics process equivalent in items of the container
func _physics_process_items(delta: float) -> void:
	# Cache and edit context to pass to every item
	var item_context: Dictionary[String, Variant] = _context.duplicate(false)
	
	# Cycle through EVERY item (Can't use caching here or the indexes would mismatch between each cache's index and the real inventory index)
	for item:ItemStack in _active_ticking_stacks:
		if item == null: continue
		
		var item_index: int = item_array.find(item)
		
		item_context[Item.CONTEXT_MODE] = (Item.ITEM_MODE_HELD if item_index == selected_index else Item.ITEM_MODE_CONTAINER)
		
		# Set context IFF the ItemStack's context is different, no need to set the same context over and over
		#if item._context != item_context:
		item._context = item_context
		item._physics_process_item(delta)

## Function used to propagate events onto items of such container
func _dispatch_event_items(event_name: String, event_context: Dictionary[String, Variant] = _context) -> void:
	# If no such event is present in the active item stacks, skip
	if !_active_event_stacks.has(event_name): return
	
	# Cache and edit context to pass to every item
	var item_context: Dictionary[String, Variant] = event_context.duplicate(false)
	# Add event name to the context passed to the item. Could be redundant but adds strength to the code in case of future refactorings
	if !item_context.has(Item.CONTEXT_EVENT): item_context[Item.CONTEXT_EVENT] = event_name
	
	# Finally call the dispatch function of every item with the proper event context
	for item:ItemStack in _active_event_stacks[event_name]:
		if item == null: continue
		
		var item_index: int = item_array.find(item)
		
		item_context[Item.CONTEXT_MODE] = (Item.ITEM_MODE_HELD if item_index == selected_index else Item.ITEM_MODE_CONTAINER)
		item._context = item_context
		item._dispatch_event(event_name, item_context)

## This public function (acts as API) lets any script get the REFERENCE of an item at a certain index. Pay attention: REFERENCE, NOT VALUE.
func get_item_stack(index: int) -> ItemStack:
	return item_array[index]
