# world_item3d.gd
@tool
extends Node3D
class_name WorldItem3D
## A class used to render / process a certain ItemStack in the world. This could be used for dropped items for example.

## The ItemStack of this WorldItem3D
@export var item_stack: ItemStack = null:
	set(new_stack):
		# Skip when the stack i'm trying to assign is the same as the current one
		if new_stack == item_stack: return
		item_stack = new_stack
		# If the item node is instantiate, delete it, clear it, then assign the new stack 
		_reset_item_node()
		_build_context()
		_link_item_context()
		_instantiate_item_scene()

@export_tool_button("Refresh Item","FlipWinding") var _refresh_item_button:= _refresh_item

## The actual node of the item
var _item_node: Node = null
## The context that WorldItem3D generates for himself which is lateched onto item stacks and then propagated to the item components
var _context: Dictionary[String, Variant] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_stack == null: item_stack.new()
	
	_build_context() # Create a first context
	_link_item_context() # Link the current context to the item_stack context
	_instantiate_item_scene()
	
	if Engine.is_editor_hint():
		# Insert Editor only code here
		return
	# Insert game only code here

# Called every physics frame. 'delta' is the elapsed time since the previous physics frame.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		# Editor only code
		return
	# Skips if item_stack is null
	if item_stack == null: return
	item_stack._physics_process_item(delta)

## Function responsible for propagating downstream the name of the event.
func _propagate_event(event:String) -> void:
	if Engine.is_editor_hint():
		# Editor only code
		return
	# Skips if the item_stack is null
	if item_stack == null: return
	item_stack._dispatch_event(event)

func _build_context() -> void:
	# The owner of that item is the dropped item instance
	_context[Item.CONTEXT_OWNER] = self
	# The mode of the item is dropped / ground mode
	_context[Item.CONTEXT_MODE] = Item.ITEM_MODE_WORLD

func _link_item_context() -> void:
	if item_stack == null: return
	# No need to do more than once considering dictionaries are passed by reference, so any modification here leads to a modification downstream.
	item_stack._context = _context 


func _instantiate_item_scene() -> void:
	# Skip if this node isn't inside tree yet.
	if !is_inside_tree(): return
	
	# Skip when no item is provided
	if item_stack == null: return
	
	# Skip when the item node has already been instanced
	if _item_node != null: return
	
	# Skip when the item stack doesn't have the necessary parameters
	if item_stack.item == null: return
	if item_stack.item.scenes.is_empty(): return
	if !item_stack.item.scenes.has(Item.ITEM_MODE_WORLD): return
	
	# Instantiate the item node looking for the world scene among the item' scenes
	_item_node = item_stack.item.scenes[Item.ITEM_MODE_WORLD].instantiate()
	
	# Add the node to the scene tree as a child of this WorldItem3D node
	add_child(_item_node)

func _reset_item_node() -> void:
	if _item_node != null:
			_item_node.queue_free()
			_item_node = null
	if Engine.is_editor_hint():
		# editor only code goes here
		return
	_context.clear()

func _refresh_item() -> void:
	_reset_item_node()
	_instantiate_item_scene()
