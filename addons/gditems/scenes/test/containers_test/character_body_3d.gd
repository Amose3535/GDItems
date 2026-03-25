extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var hand_marker: HandItem3D = $HandMarker

@export var inventory: ItemInventory = ItemInventory.new()
@export var selected_index: int = 0:
	set(new_index):
		if new_index != selected_index: 
			selected_index = new_index
			print("Index: ",new_index)

## The context of the player. This contains useful information for all items downstream of the player
var _context: Dictionary[String, Variant] = {}

func _ready() -> void:
	inventory.initialize_inventory()
	_context = build_context()
	inventory._context = _context

func _physics_process(delta: float) -> void:
	inventory._physics_process_items(delta)
	
	if Input.is_action_just_pressed("slots_scroll_up"):
		scroll(false)
		#print("Scrolled up")
	elif Input.is_action_just_pressed("slots_scroll_down"):
		scroll(true)
		#print("scrolled down")
	
	
	if Input.is_action_just_pressed("interact"):
		_context = build_context()
		#print("tried interacting")
		inventory._dispatch_event_items("use_event",_context)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

## Function used to get an ItemStack at a certain index of the invnetory and passing it to the HandItem3D known as hand_marker.[br]
## No need to do any weird stuff since Resources are passed by REFERENCE, not VALUE, henceforth it's completely fine passing it like that and won't generate duplicates.
func _grab_slot(index: int) -> void:
	var stack:ItemStack = inventory.item_array[index] # Get reference of the resource in slot "index" of the inventory.
	hand_marker.item_stack = stack

func scroll(up:bool) -> void:
	if up: 
		selected_index += 1
	else:
		selected_index -= 1
	if selected_index > inventory.slot_amount-1: selected_index = 0
	if selected_index < 0: selected_index = inventory.slot_amount-1
	
	inventory.selected_index = selected_index
	_grab_slot(selected_index)

func build_context() -> Dictionary[String, Variant]:
	var context: Dictionary[String, Variant] = {
		Item.CONTEXT_OWNER: self
	}
	return context

func _unhandled_input(event: InputEvent) -> void:
	pass
