extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var inventory: ItemInventory = ItemInventory.new()
@export var selected_index: int = 0:
	set(new_index):
		if new_index != selected_index: 
			scrolled(new_index)
			selected_index = new_index

## The context of the player. This contains useful information for all items downstream of the player
var _context: Dictionary[String, Variant] = {}

func _physics_process(delta: float) -> void:
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

func scroll(up:bool) -> void:
	if up: 
		selected_index += 1
	else:
		selected_index -= 1
	if selected_index >= inventory.slot_amount: selected_index = 0
	if selected_index < 0: selected_index = inventory.slot_amount-1

func scrolled(to_index: int) -> void:
	# Insert code to change 
	inventory.selected_index = to_index

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("slots_scroll_up"):
		scroll(true)
	elif Input.is_action_just_pressed("slots_scroll_down"):
		scroll(false)
