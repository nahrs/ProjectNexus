extends Node2D

signal OnMenuItemSelected

var menuButtons :Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Add a menu 
func LoadMenu(definitionName: String) -> bool:
	#clear prev buttons
	for button in menuButtons:
		remove_child(button)
	menuButtons.clear()
	
	#Load the definition for the menu.
	var menuDefinition := DesignData.GetDefinition(DesignData.CMenuDefinition.m_tableName, definitionName) as DesignData.CMenuDefinition
	
	menuDefinition.m_header
	
	#For each menuItem in the menu definition, add a menuItem UI object.
	var menuItemCount = 0
	for tableKey:DesignData.CTableKey in menuDefinition.m_menuItems:
		var menuItemDef := DesignData.GetDefinitionByTableKey(tableKey) as DesignData.CMenuItemDefinition
		if menuItemDef != null:
			createMenuItemInterfaceElement(menuItemDef, menuItemCount, menuDefinition.m_menuItems.size())
			menuItemCount = menuItemCount + 1

	return true

func createMenuItemInterfaceElement(menuItem: DesignData.CMenuItemDefinition, index: int, totalButtons: int) -> void:
	var text = menuItem.m_text
	var id = menuItem.m_id.m_key
	var button = Button.new()
	var padding = 3
	
	button.text = text
	add_child(button)
	
	var xpos: float = 0 - (button.size.x / 2) #get_viewport().get_visible_rect().size.x / 2 # + (((index * button.size.x) - (totalButtons * button.size.x)/2) - (totalButtons * button.size.x)/2)	add this to x after getting the middle to align buttons horizontally
	var ypos: float = index * (button.size.y + padding) * button.scale.y  #- (totalButtons * button.size.y * button.scale.y / 2) #get_viewport().get_visible_rect().size.y / 2 + (index * button.size.y) - (totalButtons * button.size.y)/2
	
	button.set_position(Vector2(xpos, ypos))
	button.pressed.connect(self.buttonPressed.bind(id))
	
	menuButtons.append(button)

func buttonPressed(id: String) -> void:
	var menuItemDef := DesignData.GetDefinition(DesignData.CMenuItemDefinition.m_tableName, id) as DesignData.CMenuItemDefinition
	var subMenu := menuItemDef.m_subMenu
	var callBack := menuItemDef.m_callBack
	
	if (callBack.length() > 0):
		print(self.has_method(callBack))
		if (!self.has_method(callBack)):
			print(get_script().get_path(), ":: callback: ", callBack, " not found for id: ", id)
		else:
			self.call(callBack)
	
	if (subMenu.m_key.length() > 0):
		LoadMenu(subMenu.m_key)

func quitGame() -> void:
	get_tree().quit()

func ClearMenuItems() -> void:
	pass

#######################################################################################
