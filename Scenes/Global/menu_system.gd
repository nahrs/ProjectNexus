extends Node2D

signal OnMenuItemSelected

var g_menuButtons :Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Add a menu 
func LoadMenu(menuKey: String) -> bool:
	#Load the data for the menu.
	var menuData := DesignData.GetData(DesignData.CMenuData.m_tableName, menuKey) as DesignData.CMenuData
	if menuData == null:
		print(get_script().get_path(), "Failed to Load Menu ", DesignData.CMenuData.m_tableName, "[", menuKey, "]")
		return false
	
	#clear prev buttons
	ClearMenuItems()
	
	#menuData.m_header
	
	#For each menuItem in the menu data, add a menuItem UI object.
	var menuItemCount = 0
	for tableKey:DesignData.CTableKey in menuData.m_menuItems:
		var menuItemData := DesignData.GetDataByTableKey(tableKey) as DesignData.CMenuItemData
		if menuItemData != null:
			createMenuItemInterfaceElement(menuItemData, menuItemCount, menuData.m_menuItems.size())
			menuItemCount = menuItemCount + 1

	return true

func createMenuItemInterfaceElement(menuItem: DesignData.CMenuItemData, index: int, totalButtons: int) -> void:
	var text = menuItem.m_text
	var button = Button.new()
	var padding = 3
	
	button.text = text
	add_child(button)
	
	var xpos: float = 0 - (button.size.x / 2) #get_viewport().get_visible_rect().size.x / 2 # + (((index * button.size.x) - (totalButtons * button.size.x)/2) - (totalButtons * button.size.x)/2)	add this to x after getting the middle to align buttons horizontally
	var ypos: float = index * (button.size.y + padding) * button.scale.y  #- (totalButtons * button.size.y * button.scale.y / 2) #get_viewport().get_visible_rect().size.y / 2 + (index * button.size.y) - (totalButtons * button.size.y)/2
	
	button.set_position(Vector2(xpos, ypos))
	button.pressed.connect(self.buttonPressed.bind(menuItem.m_id))
	
	g_menuButtons.append(button)

func buttonPressed(id:DesignData.CTableKey) -> void:
	var menuItemDef := DesignData.GetDataByTableKey(id) as DesignData.CMenuItemData
	
	if menuItemDef == null:
		print(get_script().get_path(), ":: unable to load MenuItemData for id: ", id)
		return
	
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
	for button in g_menuButtons:
		remove_child(button)
	g_menuButtons.clear()

#######################################################################################
