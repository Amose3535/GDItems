# spam_hello.gd
extends TickingComponent
class_name SpamHelloComponent
## This is a testing class used to check if the Tickingcomponent class works properly. If it does it should spam in the debugger "hello" over and over until stopped.

@export var print_pos: bool = true

func execute(context: Dictionary[String, Variant] = {}) -> void:
	var msg: String = ""
	if context.has(Item.CONTEXT_MODE):
		var item_mode: String = context[Item.CONTEXT_MODE]
		msg = "Hello! "
		match item_mode:
			Item.ITEM_MODE_WORLD:
				msg += "I'm a world item."
			
			Item.ITEM_MODE_HELD:
				msg += "I'm a held item."
			
			Item.ITEM_MODE_WORN:
				msg += "I'm an equipped item."
		if context.has(Item.CONTEXT_OWNER):
			var owner: Node = context[Item.CONTEXT_OWNER]
			var pos = str(owner.get("global_position")); if pos == null || pos == "": pos = "NONE"
			
			msg += "\nI'm located at {pos}".format({"pos":pos})
	if msg == "":
		print("Uh oh, something went wrong")
	else:
		print(msg)
