# item_container.gd
@tool
extends Resource
class_name ItemContainer
## A class used to generate inventories with a specified number of slots that hold ItemStack Resources.



## The actual inventory array. This is what holds the data of the content of a container.
@export var item_array: Array[ItemStack] = []

## The size of the container
@export_range(1,100,1.0,"or_greater") var slot_amount: int = 1:
	set(new_val):
		slot_amount = new_val
		if item_array == null: item_array = []
		item_array.resize(new_val)
		notify_property_list_changed()

## Array of item stacks which have physics ticking
var _active_ticking_stacks: Array[ItemStack] = []

## Array of item stacks which have event listening
var _active_event_stacks: Dictionary[String, Array] = {}

## The context of this ItemContainer.[br]NOTE: ItemContaienr DOES NOT build its own context unlike WorldItem3D/2D because it's NOT a node. Hence it doesn't "own" the context, only whe owner of the ItemContainer does, hence It only limits itself to propagate it downwards.
var _context: Dictionary[String, Variant] = {}:
	set(new_context):
		if new_context == _context: return
		# Duplicate to prevent collision
		_context = new_context.duplicate()
		# Add itself as context
		_context[Item.CONTEXT_CONTAINER] = self

func initialize_inventory() -> void:
	if item_array == null: return
	if item_array.is_empty(): return
	for item_stack:ItemStack in item_array:
		_add_stack_to_caches(item_stack)

func set_slot(index: int, with: ItemStack) -> void:
	if index > slot_amount-1 or index < 0:
		push_error("WARNING: Trying to access an out of bound index ({index}) for container {container} with ItemStack \"{item_stack}\".".format({"index":index,"container":self, "item_stack":with}))
	
	# If the target slot contains something, remove that that stack from cache
	if item_array[index] != null:
		_remove_stack_from_caches(item_array[index])
	
	# Then insert new object
	item_array[index] = with
	
	# If the inserted object is not null, then proceed to add it to the cache
	if with != null:
		_add_stack_to_caches(with)




## Function that updates the physics process equivalent in items of the container
func _physics_process_items(delta: float) -> void:
	# Cache and edit context to pass to every item
	var item_context: Dictionary[String, Variant] = _context.duplicate(false)
	item_context[Item.CONTEXT_MODE] = Item.ITEM_MODE_CONTAINER
	# Cycle through the items in the ticking cache
	for item:ItemStack in _active_ticking_stacks:
		if item == null: continue
		# Set context IFF the ItemStack's context is different, no need to set the same context over and over
		if item._context != item_context: item._context = item_context
		item._physics_process_item(delta)

## Function used to propagate events onto items of such container
func _dispatch_event_items(event_name: String, event_context: Dictionary[String, Variant] = _context) -> void:
	# If no such event is present in the active item stacks, skip
	if !_active_event_stacks.has(event_name): return
	
	# Cache and edit context to pass to every item
	var item_context: Dictionary[String, Variant] = event_context.duplicate(false)
	item_context[Item.CONTEXT_MODE] = Item.ITEM_MODE_CONTAINER
	
	# Add event name to the context passed to the item. Could be redundant but adds strength to the code in case of future refactorings
	if !item_context.has(Item.CONTEXT_EVENT): item_context[Item.CONTEXT_EVENT] = event_name
	
	# Cycle through the items in the active event cache
	for item:ItemStack in _active_event_stacks[event_name]:
		if item == null: continue
		item._dispatch_event(event_name, item_context)




#region caching
## This function is responsible for adding the item stack in the correct cache/s
func _add_stack_to_caches(stack: ItemStack) -> void:
	if stack == null: return
	for component:ItemComponent in stack.item.components:
		if component is TickingComponent: _add_to_ticking(stack)
		if component is EventComponent: _add_to_events(stack, component) 

## This function adds the stack in the ticking cache if not already present
func _add_to_ticking(stack: ItemStack) -> void:
	# Skips the item if already present
	if _active_ticking_stacks.has(stack): return
	
	# So if the stack is not already present, it gets appended for later use.
	_active_ticking_stacks.append(stack)

## This function is responsible for adding the item stack in the correct lookup array of the corresponding event if not already present
func _add_to_events(stack:ItemStack, event_component: EventComponent) -> void:
	for event:String in event_component.listen_events:
		# If the corresponding event arary doesn't exist, create it
		if !_active_event_stacks.has(event): _active_event_stacks[event] = []
		# If the event already contains the target stack, skip it
		if !_active_event_stacks[event].has(stack): _active_event_stacks[event].append(stack)

func _remove_stack_from_caches(stack: ItemStack) -> void:
	for component:ItemComponent in stack.item.components:
		if component is TickingComponent: _remove_from_ticking(stack)
		if component is EventComponent: _remove_from_events(stack, component)

func _remove_from_ticking(stack:ItemStack) -> void:
	# Skip stack in case it's already missing from the cache
	if !_active_ticking_stacks.has(stack): return
	
	_active_ticking_stacks.erase(stack)

func _remove_from_events(stack:ItemStack, event_component: EventComponent) -> void:
	for event:String in event_component.listen_events:
		# If the event needed to remove the stack is missing skip, no need to remove anything
		if !_active_event_stacks.has(event): return
		# If the event is present but the stack is already missing skip, no need to remove anything
		if !_active_event_stacks[event].has(stack): return
		_active_event_stacks[event].erase(stack) # Removes the stack from the event
		# if the event is now empty, destroy the key
		if _active_event_stacks[event].is_empty(): _active_event_stacks.erase(event)
#endregion
