extends Node2D

#signal OnMenuItemSelected

var g_menuButtons :Array[Button]
var g_previousLocation :Vector2
var g_previousFontSize :float
var g_currentButtonFocus = 0
var g_menuStack:Array[StringName]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Add a menu 
func LoadMenu(menuKey: String, location : Vector2 = get_viewport_rect().get_center(), fontSize : float = 15)-> bool:
	#Load the data for the menu.
	var menuData := DesignData.GetData(DesignData.CMenuData.m_tableName, menuKey) as DesignData.CMenuData
	if menuData == null:
		print(get_script().get_path(), "Failed to Load Menu ", DesignData.CMenuData.m_tableName, "[", menuKey, "]")
		return false
	
	#clear prev buttons
	ClearMenuItems()
	
	#print(self.getLargestButtonX())
	#menuData.m_header
	
	# set menu position and scale
	if g_previousLocation != location:
		g_previousLocation = location
	if g_previousFontSize != fontSize:
		g_previousFontSize = fontSize
	self.set_position(location)
	
	#For each menuItem in the menu data, add a menuItem UI object.
	var menuItemCount = 0
	for tableKey:DesignData.CTableKey in menuData.m_menuItems:
		var menuItemData := DesignData.GetDataByTableKey(tableKey) as DesignData.CMenuItemData
		if menuItemData != null:
			createMenuItemInterfaceElement(menuItemData, menuItemCount, fontSize)
			menuItemCount = menuItemCount + 1
	
	#TODO data should probably determine whether or not we maintain the stack.
	# also maybe menu data could also set whether or not the back button is auto generated instead of having to manually link it.
	InternalRecordMenuStack(menuKey)
	ChangeMenuItemFocus(0)
	
	return true

func createMenuItemInterfaceElement(menuItem: DesignData.CMenuItemData, index: int, fontSize: float) -> void:
	var text = menuItem.m_text
	var button = Button.new()
	var padding = 3
	
	button.text = text
	add_child(button)
	
	button.add_theme_font_size_override("font_size", fontSize as int)
	
	var xpos: float = -(button.get_rect().get_center().x)
	var ypos: float = index * (button.size.y + padding) 
	
	#print("xpos: ", xpos)
	#print("ypos: ", ypos)
	
	g_menuButtons.push_back(button) 
	button.set_position(Vector2(xpos, ypos))
	
	button.pressed.connect(self.buttonPressed.bind(menuItem.m_id))

func getLargestButtonX(buttonArray : Array = g_menuButtons) -> Button:
	if(!buttonArray.is_empty()):
		var largestButton : Button = buttonArray[0]
		var prevButton :Button = buttonArray[0]
		for button in buttonArray:
			if (button.get_rect().size.x > prevButton.get_rect().size.x):
				largestButton = button
		return largestButton
	else:
		return null

func getLargestButtonY(buttonArray : Array = g_menuButtons) -> Button:
	if(!buttonArray.is_empty()):
		var largestButton : Button = buttonArray[0]
		var prevButton :Button = buttonArray[0]
		for button in buttonArray:
			if buttonArray.find(button) == 0:
				continue
			if (button.get_rect().size.y > prevButton.get_rect().size.y):
				largestButton = button
		return largestButton
	else:
		return null

func buttonPressed(id:DesignData.CTableKey) -> void:
	var menuItemDef := DesignData.GetDataByTableKey(id) as DesignData.CMenuItemData
	
	if menuItemDef == null:
		print(get_script().get_path(), ":: unable to load MenuItemData for id: ", id)
		return
	
	var subMenu := menuItemDef.m_subMenu
	var callBack := menuItemDef.m_callBack
	var callBackParams := menuItemDef.m_callBackParams
	
	if (callBack.length() > 0):
		print(self.has_method(callBack))
		if (!self.has_method(callBack)):
			print(get_script().get_path(), ":: callback: ", callBack, " not found for id: ", id)
		else:
			self.call(callBack, callBackParams )
	
	if (subMenu.m_key.length() > 0):
		LoadMenu(subMenu.m_key, g_previousLocation, g_previousFontSize)

func quitGame(_params:String) -> void:
	get_tree().quit()

func fireEvent(params:String) -> void:
	var strArr := params.split(",")
	params.split()
	if strArr.size() > 0:
		var eventName:StringName = StringName(strArr[0])
		strArr.remove_at(0)
		if strArr.size() == 0:
			EventSystem.FireEvent(eventName, 0)
		elif strArr.size() == 1:
			EventSystem.FireEvent(eventName, strArr[0])
		else:
			EventSystem.FireEvent(eventName,strArr)

func ClearMenuItems() -> void:
	for button in g_menuButtons:
		remove_child(button)
	g_menuButtons.clear()

func ChangeMenuItemFocus(index:int) -> void:
	g_currentButtonFocus = index
	if g_menuButtons.size() > 0:
		g_menuButtons[g_currentButtonFocus].grab_focus()

func MenuItemIncrement() -> void:
	if g_menuButtons.size() > 1:
		if g_currentButtonFocus == 0:
			g_currentButtonFocus = g_menuButtons.size() - 1
		else:
			g_currentButtonFocus = g_currentButtonFocus - 1
		ChangeMenuItemFocus(g_currentButtonFocus)

func MenuItemDecrement() -> void:
	if g_menuButtons.size() > 1:
		g_currentButtonFocus = (g_currentButtonFocus + 1) % g_menuButtons.size()
		ChangeMenuItemFocus(g_currentButtonFocus)

func MenuItemSelect() -> void:
	if g_menuButtons.size() == 0:
		return
	if g_currentButtonFocus >= g_menuButtons.size():
		return
	g_menuButtons[g_currentButtonFocus].set_pressed_no_signal(true)

func MenuItemBack() -> void:
	if g_menuStack.size() > 1:
		g_menuStack.pop_front()
		LoadMenu(g_menuStack[0], g_previousLocation, g_previousFontSize)
		#print("menu pop")

func InternalRecordMenuStack(selectedMenu:StringName) -> void:
	if g_menuStack.has(selectedMenu):
		#Prevent back button feature from twiddling between menus. 
		var index := g_menuStack.find(selectedMenu,0)
		for i in range(0,index):
			#we've traversed to a node in our stack history before this node, so it's no longer relevant.
			g_menuStack.pop_front()
	else:
		g_menuStack.push_front(selectedMenu)

#######################################################################################
