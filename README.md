# GDItems
A simple godot addon aimed to be used as a starting point to develop items in godot

---
## Installation

1) Clone / download the repo
2) Add the folder GDItems into your local godot addons folder
3) In the Project settings menu enable this addon from the toggle

---
## How to use
It's easy. Really (I put a lot of effort into making items and containers in an intuitive and flexible way)!

1) Create a new Item resource
2) Compile the form-like fields in the tab that appears when the "your_item.tres" opens in the inspector.[br]
2.a) If your item appears in the world make sure that the proper scenes are set up in the scenes array in your item resource.[br]
2.b) If your item has behavior make sure to create and add your custom component to your item resource (if the resource is shared among verious items it's a good idea to make it local to that resource in order not to trigger unwanted behavior from other items with the same resource).[br]
3) Add your item in the world using WorldItem3D or to an inventory using ItemContainer / ItemInventory and you're good to go!

To have a general overview of what each class does, make sure to read the in-editor documentation of each class.
For a more in-depth explanation keep reading the following text.

---
## Addon description

### Item
- This is your base class for any item.
- This is a resource used to define what is your item and what does it do.
- The custom scenes for the item are GENERALLY NOT instantiated automatically and the developer should instantiate them depending on the current CONTEXT.
- The only exception to the previous rule is WorldItem3D which its sole purpose is to render the "drop" scene of your item is present, for nay other scene you should probably do it yourself unless a new update of this addon comes around.
- To allow for an easier creation of the context, this class also contains some constants called \"CONTEXT_\[field\]\" which map to strings, so that the user doesn't need to remember what each field of the context is called.

### ItemStack
- This can be considered the "instantiated" Item resource (even if in reality it's not really what that is).
- This is the interface between the owner of such item and the item resource itself. Any TickingComponent and EventCompoent are called through this class.
- This contains the info of the item (Item resource) and the amount of such item (not exceeding Item's max_stack property).
- Thanks to component caching, it skips execution of "inert" components (components which do not tick nor recieve an event, in other words, components which inherit from the base ItemComponent class. Useful for "data" components).

### ItemSceneInterface3D
- This is a simple interface between the owner and one of the item scenes that has been instantiated.
- It has a custom method "interface(context: Dictionary[String, Variant]) -> void" which allows for an easy implementation of the logic and behavior of the item with the decorative, graphical part.
- It can be viewed as the logical bridge between the item resource and the physical scene and / or animations of such item.
- Its function "interface" DOES NOT get called automatically and requires the owner to manually call it when needed.

### WorldItem3D
- This is a simple way to automatically instantiate the "drop" scene among the scenes of the Item resource.
- This node automatically builds its context and passes it onto its ItemStack.
- The Item.CONTEXT_MODE in the context is by default set to Item.ITEM_MODE_WORLD due to the fact that this is the world instance of the item.
- This is a tool script because when adding an item from the editor the user can actually tell what item he added in the scene before starting the game. If the item doesn't appear to have been added or updated, try clicking the "Refresh Item" button in the inspector.

### ItemContainer
- Inherits from Resource.
- This is a simple container for some amount of items. It's basically a wrapper for an array of ItemStack(s)
- IT has ONE context and it gets passed to ALL items in the container. By default the Item.CONTEXT_MODE is set to Item.ITEM_MODE_CONTAINER (duh).
- Thanks to item caching it automatically skips execution of "inert" items to improve performance (items which do not have Ticking nor Event components).
- It has a method to add items to the container which first checks for compatible stacks to stack upon the stack that's getting inserted, then cyucles through all slots, until one is empty, therefore getting emptied there.

### ItemInventory
- Inherits from ItemContainer.
- This is a simple inventory for some amount of items. Like the parent ItemContainer, this resource has an array of ItemStack(s).
- It has a property called "selected_index" which equates to the selected slot in the inventory. For example, if you want to be able to select slots from 0-9 in your inventory that goes from 0-29, the owner of that inventory should limit the selected_index only between 0 and 9.
- Unlike the parent class, this one doesn't have a unique context for all items: The items which correspond to the selected index, have Item.CONTEXT_MODE set to Item.ITEM_MODE_HELD, every other item has Item.CONTEXT_MODE set to Item.ITEM_MODE_CONTAINER.

### ItemComponent
- Inherits from Resource.
- The base class of all components.
- Doesn't do anything on its own, other than grouping all child classes. Useful for data-only components.

### TickingCompoent
- Inherits from ItemComponent
- It's a component designed to run constantly at fixed intervals
- Its execution rate can be configured through tick_rate. It can either tick at every physics frame, don't tick at all, or tick at determined intervals (E.g: tick_rate = 10, means that this component runs 10 times each second)

### EventComponent
- Inherits from ItemComponent
- It's a component designed to run only when it recieves an event (a string of characters).
- It has a property called "listen_events" which is the list of all events which this component should listen for. It doesn't do anything on its own and the developer should specify how this list works. By design, it was though the be used as a list where ONLY ONE event among the list is needed to trigger execution, however developers should feel free to edit the architecture to allow for multiple-events-required architecture.

---
## What is context??
Well, on its own context doesn't mean that much, but in this context (pun intended) it's meant to be used as all the useful information that items need to trigger their execution in different ways.
As of today, context is comprised of:
- Item.CONTEXT_OWNER which is the owner of the item. When the script which builds the context is at the same level of the owner's script, you usually see something like "context[Item.CONTEXT_OWNER] = self"
- Item.CONTEXT_EVENT which is the event that gets passed onto the item. Not always present in the context but it's what allows for items to recieve events
- Item.CONTEXT_MODE which is the mode of the item. As of today, all possible modes are:
  1) Item.ITEM_MODE_WORLD
  2) Item.ITEM_MODE_HELD
  3) Item.ITEM_MODE_WORN
  4) Item.ITEM_MODE_CONTAINER
  But feel free to add as many as you need.
- Item.CONTEXT_CONTAINER which is the ItemContainer where this item is contained if present. This is useful to access other items in the same container without much hassle.
- Item.CONTEXT_STACK which is the ItemStack of this item. It can be useful to easily access / increment / decrement the current item stack without much hassle.
