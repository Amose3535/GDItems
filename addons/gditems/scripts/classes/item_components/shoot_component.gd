extends EventComponent
class_name ShootComponent

signal shoot(amount: int)

## How much does it cost to shoot. By default it's 1 since normally ranged weapons only consume 1 projectile at a time. However this freedom is left to the dev.
@export var cost: int = 1
## Wether it should check for bullets before shooting (If set to false it will behave like in Ultrakill /Devil may cry / Bayonetta)
@export var needs_bullets: bool = true
## The expected mode that this component expects in order to trigger its oepration. by default it's Item.ITEM_MODE_HELD (=> "hand")
@export_enum(Item.ITEM_MODE_WORLD,Item.ITEM_MODE_HELD,Item.ITEM_MODE_WORN,Item.ITEM_MODE_CONTAINER,"any") var mode: String = Item.ITEM_MODE_HELD


## This component will only emit the shoot signal IF EVERY condition is met
@export var shoot_conditions: Dictionary[String, bool] = {
"active": true
}

var ammo_component: AmmoComponent = null
var ammo_saved: bool = false


func execute(context: Dictionary[String, Variant] = {}) -> void:
	if\
	context.has(Item.CONTEXT_EVENT) &&\
	context[Item.CONTEXT_EVENT] in listen_events &&\
	context.has(Item.CONTEXT_MODE) &&\
	context.has(Item.CONTEXT_STACK):
		# Guard clause
		if mode != "any" and context[Item.CONTEXT_MODE] != mode: return
		
		# Cache component only when needed
		if !ammo_saved && needs_bullets: save_ammo_component(context)
		
		try_shoot()

## Does some checks, and then shoots
func try_shoot() -> void:
	if ammo_component == null && needs_bullets: return
	var can_shoot: bool = (needs_bullets == false or ammo_component.amount-cost >= 0) && !(false in shoot_conditions.values())
	if can_shoot:
		if needs_bullets: ammo_component.amount -= cost
		shoot.emit(cost)

## Function used to cache the ammo component into a a variable to be reused later.
func save_ammo_component(context: Dictionary[String, Variant]) -> void:
	var data_components: Array[DataComponent] = (context[Item.CONTEXT_STACK] as ItemStack).data_cache
	for data_component:DataComponent in data_components:
		if data_component is AmmoComponent:
			ammo_component = data_component
			ammo_saved = true
