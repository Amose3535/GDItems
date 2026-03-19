extends Node3D

@onready var world_item_3d: WorldItem3D = $WorldItem3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		world_item_3d._propagate_event("hello_event")
