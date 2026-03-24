# ammo_component.gd
extends DataComponent
class_name AmmoComponent
## A component used to define how much ammo can this item store, how much does it have, and what type does this use. This could be potentially used by far more than just weapons.

@export var type: StringName = &""
@export_range(0,10000,1.0,"or_greater","hide_slider") var amount: int = 0
@export_range(1,10000,1.0,"or_greater","hide_slider") var max: int = 1
