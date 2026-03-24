# hand_item3d.gd
@tool
extends Marker3D
class_name HandItem3D
## Similar in behavior to WorldItem3D.
##
## Unlike its brother WorldItem3D it automatically instantiates the scene required (in this case the Item.ITEM_MODE_HELD) AND connects the necessary signals from the components of the item onto the callables of the inherited ItemSceneInterface3D script.
## [br] One of the main differences between HandItem3D and WorldItem3D is the fact that this class lacks the context creation and linking since this is DESIGNED to be only a middleman between the player / player's inventory and the actual item scene, this should NOT have its own context and item resource, but only copy those of the player / owner.


## The ItemStack of this WorldItem3D
@export var item_stack: ItemStack = null:
	set(new_stack):
		# Skip when the stack i'm trying to assign is the same as the current one
		if new_stack == item_stack: return
		# If the item node is instantiate, delete it, clear it, then assign the new stack 
		_reset_item_scene()
		item_stack = new_stack
		_instantiate_item_scene()

## This button refreshes the item in case it didn't update.
@export_tool_button("Refresh Item","FlipWinding") var _refresh_item_button:= _refresh_item

## The actual node of the item
var _item_node: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_stack == null: item_stack = ItemStack.new()
	
	_instantiate_item_scene()
	
	if Engine.is_editor_hint():
		# Insert Editor only code here
		return
	# Insert game only code here

# ------------------------------------------------------------------------------
# No need to call the physics process and the propagate event functions here...
# ------------------------------------------------------------------------------


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
	if !item_stack.item.scenes.has(Item.ITEM_MODE_HELD): return
	
	# Instantiate the item node looking for the hand scene among the item' scenes
	_item_node = item_stack.item.scenes[Item.ITEM_MODE_HELD].instantiate()
	
	# Add the node to the scene tree as a child of this WorldItem3D node
	add_child(_item_node)
	
	# After the node is added as child of HandItem3D, connect all the required signals from the item resource onto ItemSceneInterface
	_connect_signals()

func _reset_item_scene() -> void:
	_disconnect_signals()
	if _item_node != null:
			_item_node.queue_free()
			_item_node = null
	if Engine.is_editor_hint():
		# editor only code goes here
		return

func _refresh_item() -> void:
	_reset_item_scene()
	_instantiate_item_scene()

## Connects the signals of the Item components onto the ItemSceneInterface callables
func _connect_signals() -> void:
	# Skip execution if i'm in the editor
	if Engine.is_editor_hint(): return
	
	if !_item_node is ItemSceneInterface3D: return
	if (_item_node as ItemSceneInterface3D).required_signals == null: return
	var signals_dict: Dictionary[StringName,StringName] = (_item_node as ItemSceneInterface3D).required_signals
	# Skip if signals dict is empty
	if signals_dict.is_empty(): return
	var item_components: Array[ItemComponent] = item_stack.item.components
	# Skip if no components or parameter is null
	if item_components == null or item_components.is_empty(): return
	# Cycle in every component of the item
	for component in item_components:
		for _signal in signals_dict:
			var _function_name:StringName = signals_dict[_signal]
			if !component.has_signal(_signal): continue
			if !_item_node.has_method(_function_name): continue
			# Connect the component signal to the item node callable
			var _callable: Callable = Callable(_item_node, _function_name)
			component.connect(_signal,_callable)
	

## Disonnects the signals of the Item components from the ItemSceneInterface callables
func _disconnect_signals() -> void:
	# Skip execution if i'm in the editor
	if Engine.is_editor_hint(): return
	
	if !_item_node is ItemSceneInterface3D: return
	if (_item_node as ItemSceneInterface3D).required_signals == null: return
	var signals_dict: Dictionary[StringName,StringName] = (_item_node as ItemSceneInterface3D).required_signals
	# Skip if signals dict is empty
	if signals_dict.is_empty(): return
	var item_components: Array[ItemComponent] = item_stack.item.components
	# Skip if no components or parameter is null
	if item_components == null or item_components.is_empty(): return
	# Cycle in every component of the item
	for component in item_components:
		for _signal in signals_dict:
			var _function_name:StringName = signals_dict[_signal]
			if !component.has_signal(_signal): continue
			#if !_item_node.has_method(_function_name): continue # Unnecessary
			var _callable: Callable = Callable(_item_node, _function_name)
			# Check if the connection exists before disconnecting
			if !component.is_connected(_signal,_callable): continue
			# Disconnect the component signal to the item node callable
			component.disconnect(_signal,_callable)
