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
## How many times per second should the ItemStack tick (set it to -1 to be the same as physics process)
@export var tick_rate: int = -1

var ticking_cache: Array[TickingComponent]

var _context: Dictionary[String, Variant] = {}
var _internal_time: float = 0.0

func _init(_item:Item = null, _amount:int = 1) -> void:
	item = _item
	amount = _amount
	_cache_components()

func _physics_process_item(delta: float) -> void:
	_internal_time += delta
	var threshold: float = 1/(tick_rate as float)
	if _internal_time >= threshold:
		_internal_time -= threshold
		if ticking_cache.is_empty(): 
			var item_components: Array[ItemComponent] = item.components
			for component:ItemComponent in item_components:
				if component is TickingComponent:
					ticking_cache.append(component)
		for component:TickingComponent in ticking_cache:
			component.execute(_context)
		
		_physics_tick(delta)

func _cache_components() -> void:
	pass

func _physics_tick(delta: float) -> void:
	pass

func _item_input(event: InputEvent) -> void:
	pass
