# item.gd
extends Resource
class_name Item
## A special type of resource used to describe an item and its functionality.


## The name for the context id of the owner.
const CONTEXT_OWNER: String = "owner"
## The name for the context id of the events.
const CONTEXT_EVENT: String = "event"
## The name for the context id of the item mode.
const CONTEXT_MODE: String = "item_mode"
## The name for the context id of the ItemContainer.
const CONTEXT_CONTAINER: String = "item_container"
## The name for the context id of the ItemStack in which Item lives.
const CONTEXT_STACK: String = "item_stack"

## The name that string properties should try to access when referring to world mode / dropped mode.
const ITEM_MODE_WORLD: String = "drop"
## The name that string properties should try to access when referring to hand mode / held mode.
const ITEM_MODE_HELD: String = "hand"
## The name that string properties should try to access when referring to equipped mode / worn mode.
const ITEM_MODE_WORN: String = "equip"
## The name that string properties should try to access when referring to inventory / container mode.
const ITEM_MODE_CONTAINER: String = "container"


## The rarity of the item. It doesn't do anything on its own other than deco.
enum ItemRarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHICAL
}

## The identifier of this item. Two items might have the same name. Use this to discern between differnt types.
@export var id: String
## The name of the item
@export var name: String
## The description of the item
@export_multiline var description: String
## The flavor text of the item
@export var flavor_text: String
## The rarity of the item
@export var rarity: ItemRarity
## Wether the item is stackable or not. If [code]stackable = false[/code], then the max item in a stack of such type is 1, therefore considered "unstackable".
@export_range(1, 256, 1.0, "or_greater") var max_stack: int = 1
## The icon of this item
@export var icon: Texture2D
## The Scene of this item. The root of the scene must be ItemSceneInterface in order to work properly.[br]
## [b]SUGGESTION[/b]:[br]- "drop" for the ground item[br]
## - "hand" for the hand item[br]
## - "equip" for the worn item[br]
@export var scenes: Dictionary[String, PackedScene] = {}
## The array of components of this item. They define the behavior (E.g Equippable, Weapon, Consumable, etc)
@export var components: Array[ItemComponent]

func _init(_name: String = "", _id: String = "", _description: String = "", _flavor_text: String = "", _rarity: ItemRarity = ItemRarity.COMMON, _max_stack: int = 1, _icon: Texture2D = null, _scenes: Dictionary[String, PackedScene] = {}, _components: Array[ItemComponent] = []):
	name = _name
	id = _id
	description = _description
	flavor_text = _flavor_text
	rarity = _rarity
	max_stack = _max_stack
	icon = _icon
	scenes = _scenes
	components = _components
