# item_scene_interface.gd
extends Node
class_name ItemSceneInterface
## The node which bridges logic with vfx (animation, particles, etc).
##
## This is meant to be used as the root node of the item scene. Can be used as interface for animations and vfx.

## This function is the one called to interface with the scene
func interface(context: Dictionary[String, Variant]) -> void:
	pass
