# item.gd
extends Resource
class_name Item
## A special type of resource used to describe an item

enum ItemRarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHICAL
}

## The name of the item
@export var name: String
## The identifier of this item. Two items might have the same name. Use this to discern between differnt types.
@export var id: String
## The description of the item
@export var description: String
## The flavor text of the item
@export var flavor_text: String
## The rarity of the item
@export var rarity: ItemRarity
## Wether the item is stackable or not. If [code]stackable = false[/code], then the max item in a stack of such type is 1
@export_range(1, 256, 1.0, "or_greater") var max_stack: int = 1
## The icon of this item
@export var icon: Texture2D
## The Scene of this item. The root of the scene must be ItemSceneInterface in order to work properly.
@export var scene: PackedScene
## The array of components of this item. They define the behavior (E.g Equippable, Weapon, Consumable, etc)
@export var components: Array[ItemComponent]

func _init(_name: String, _id: String, _description: String, _flavor_text: String, _rarity: ItemRarity, _max_stack: int, _icon: Texture2D, _scene: PackedScene, _components: Array[ItemComponent]):
	name = _name
	id = _id
	description = _description
	flavor_text = _flavor_text
	rarity = _rarity
	max_stack = _max_stack
	icon = _icon
	scene = _scene
	components = _components
