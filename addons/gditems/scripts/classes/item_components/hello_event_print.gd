# hello_event_print.gd 
extends EventComponent
class_name HelloEventComponent

## If "any" is selected, then it will work independently of the mode of the item. If anything else then it will only work in taht context.
@export_enum(Item.ITEM_MODE_WORLD,Item.ITEM_MODE_HELD,Item.ITEM_MODE_WORN,Item.ITEM_MODE_CONTAINER,"any") var mode: String = "any"

func execute(context: Dictionary[String, Variant] = {}) -> void:
	# No event recieved? Skip
	if !context.has(Item.CONTEXT_EVENT): return
	var event: String = context[Item.CONTEXT_EVENT]
	
	# No mode recieved? Skip
	if !context.has(Item.CONTEXT_MODE): return
	var item_mode:String = context[Item.CONTEXT_MODE]
	
	if !context.has(Item.CONTEXT_OWNER): return
	var item_owner:Node = context[Item.CONTEXT_OWNER]
	
	# Wrong item mode? Skip
	if item_mode != mode and mode != "any": return
	print("Hello! I recieved event \"{event}\" from {owner}. I am currently in mode {mode}".format({"event":event,"owner":item_owner,"mode":item_mode}))
