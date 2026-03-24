# item_scene_interface3d.gd
extends Node3D
class_name ItemSceneInterface3D
## The node which bridges logic with vfx (animation, particles, etc).
##
## This is meant to be used as the root node of the item scene. Can be used as interface for animations and vfx.

## When tuple composed by signal_name:callable_name is present, the owner of this node, will look for the signal (first string field) inside every item components of the Item which contains this scene, and then will try to connect that to a callable with the specified name inside an extended script of this class
@export var required_signals: Dictionary[StringName, StringName] = {}

## This function is the one called to interface with the scene
func interface(context: Dictionary[String, Variant]) -> void:
	pass
