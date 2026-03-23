extends Node
class_name ItemManagerAutoload
## The ItemManager autoload is a script accessible at any time which allows for ease of use of Items

## This is the directory which contains all item resources. If you want to specify another directory, edit this constant
const ITEM_DIR: StringName = &"res://addons/gditems/resources/demo_items"

## This is the dictionary containing all items in a dictionary of type "item_id":ItemResource
var _item_db: Dictionary[String, Item] = {}

func _ready() -> void:
	_register_items()

## This is the function resposible for registering all items in the item directory into the item database
func _register_items() -> void:
	var dir: DirAccess = DirAccess.open(ITEM_DIR)
	if dir == null: push_error("No directory found."); return
	var files: PackedStringArray = dir.get_files()
	for file:String in files:
		var path: String = ITEM_DIR.path_join(file)
		if path.contains(".remap") || path.contains(".import"):
			path = path.replace(".remap","")
			path = path.replace(".import","")
		if !path.ends_with(".tres"): continue
		var resource: Resource = ResourceLoader.load(path)
		if !resource is Item: continue
		_item_db[(resource as Item).id] = resource

## API used to get ALL items in the database
func get_items() -> Array[Item]:
	return _item_db.keys()

## API used to get the Item resource with the specified id in the dictionary . Wrapper for ItemManager._item_db.get(id)
func get_item(id: String) -> Item:
	return _item_db.get(id, null)

## API to get a new ItemStack resource with the specified item at the specified id in the dictionary.
func give_item(id: String, amount: int) -> ItemStack:
	var item: Item = _item_db.get(id)
	if !item: return null
	if amount <= 0: return null
	
	var item_stack: ItemStack = ItemStack.new(item,amount)
	return item_stack
