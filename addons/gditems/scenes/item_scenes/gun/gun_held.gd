extends ItemSceneInterface3D

@export var animation_player: AnimationPlayer

## Function called when this script recieves the shoot signal.
func on_shoot(amount:int) -> void:
	print("PEW x {amount}".format({"amount":amount}))
	animation_player.stop(true)
	animation_player.play(&"shoot",)
	pass
