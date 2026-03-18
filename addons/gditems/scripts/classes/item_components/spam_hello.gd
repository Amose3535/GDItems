extends TickingComponent
class_name SpamHelloComponent
## This is a testing class used to check if the Tickingcomponent class works properly. If it does it should spam in the debugger "hello" over and over until stopped.



func execute(context: Dictionary[String, Variant] = {}) -> void:
	var msg: String = ""
	if context.has(Item.CONTEXT_MODE_ID):
		msg = "Hello! "
		match context[Item.CONTEXT_MODE_ID]:
			Item.ITEM_MODE_WORLD:
				msg += "I'm a world item."
			
			Item.ITEM_MODE_HELD:
				msg += "I'm a held item."
			
			Item.ITEM_MODE_WORN:
				msg += "I'm an equipped item."
	if msg == "":
		print("Uh oh, something went wrong")
	else:
		print(msg)
