extends GridContainer

@export var player_node: Node
@export var slot_scene: PackedScene
@export var items_amount: int = 1


var _slots: Array[Control] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_node.inventory == null: pass
	items_amount = (player_node.inventory as ItemContainer).slot_amount
	
	for i in range(items_amount):
		_slots.append((slot_scene.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) as PackedScene).instantiate())
		add_child(_slots[i])


func _unhandled_key_input(event: InputEvent) -> void:
	pass
