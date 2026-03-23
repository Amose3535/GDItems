# item_stack.gd
extends Resource
class_name ItemStack
## The middleman between everything for the Item.
##
## Item is the data, ItemStack is the instance.

## The item held by the stack
@export var item: Item
	#set(new_item):
		#if new_item == item: return
		#item = new_item
		#_is_cached = false
		#_cache_components()
## How many items are there for that specific item
@export var amount: int = 1
## How many times per second should the ItemStack tick (set it to -1 to be the same as physics process and 0 to not tick)
@export var tick_rate: int = 10

var _is_cached: bool = false

var ticking_cache: Array[TickingComponent] = []
var event_cache: Dictionary[String, Array] = {}

var _context: Dictionary[String, Variant] = {}:
	set(new_context):
		# If it's the same memory address as the dictionary i already have, skip
		if new_context == _context: return
		# Duplicate the given context to prevent collisions with other ItemStacks in the same inventory
		_context = new_context.duplicate()
		# Add self to the context in Item.CONTEXT_STACK
		_context[Item.CONTEXT_STACK] = self

var _internal_time: float = 0.0


func _init(_item:Item = null, _amount:int = 1) -> void:
	item = _item
	amount = _amount
	_cache_components()


## This is the equivalent of _physics_process(delta: float) but for Item resources. Considering that resources don't have a native _physics_process() then it's up to the container to call this function.
func _physics_process_item(delta: float) -> void:
	_internal_time += delta
	var threshold: float = (0 if tick_rate == -1 or tick_rate == 0 else (1/(tick_rate as float)))
	var should_tick: bool = (true if tick_rate != 0 else false)
	if _internal_time >= threshold && should_tick:
		_internal_time = ((_internal_time - threshold) if threshold > 0 else 0.000001)
		_cache_components()
		for component:TickingComponent in ticking_cache:
			component.execute(_context)


## The function which is triggered when an even happens. Depending on the container
func _dispatch_event(event_name: String, event_context: Dictionary[String, Variant] = _context.duplicate()) -> void:
	#print("Recieved event "+event_name+" and context"+str(event_context))
	if event_cache.is_empty(): 
		if !_is_cached: _cache_components()
		else: return # Early return if there's no event component and the cache is already built
	# Skips unneeded events
	if !event_cache.has(event_name): return
	# Add event name to the context passed to the event component. Could be redundant but adds strength to the code in case of future refactorings
	if !event_context.has(Item.CONTEXT_EVENT): event_context[Item.CONTEXT_EVENT] = event_name
	if !event_context.has(Item.CONTEXT_STACK): event_context[Item.CONTEXT_STACK] = self
	
	# Finally call the execute function of such component with the proper event context
	for event_component in event_cache[event_name]:
		event_component.execute(event_context)



#region caching
## Function to cache components. Calls the functions for each specific component type
func _cache_components() -> void:
	# Skips caching if there's no item to cache
	if item == null: return
	# Skips cachinf if it's already cached
	if _is_cached: return
	
	_is_cached = true
	
	# Cache ticking components
	if ticking_cache.is_empty(): 
		_cache_ticking_components()
	
	# Cache event components
	if event_cache.is_empty():
		_cache_event_components()

## Caches TickingComponents of the relative Item. Whenever a new resource is created or it's processing the components of the item for the first time, it's gonna save the ticking components into an array and process them if there's any. For this reason, the lesser the amount of items which require a ticking component, the better.
func _cache_ticking_components() -> void:
	if item == null: return # Redundant check
	var item_components: Array[ItemComponent] = item.components
	for component:ItemComponent in item_components:
		if component is TickingComponent:
			ticking_cache.append(component)

## Caches EventComponents of the relative Item. Whenever a new resource is created or it's processing the components of the item for the first time, it's gonna save the event components into an array and process them during the corresponding event.
func _cache_event_components() -> void:
	if item == null: return # Redundant check
	var item_components: Array[ItemComponent] = item.components
	for component:ItemComponent in item_components:
		if component is EventComponent:
			for event:String in component.listen_events:
				if !event_cache.has(event): event_cache[event] = []
				event_cache[event].append(component)
#endregion
