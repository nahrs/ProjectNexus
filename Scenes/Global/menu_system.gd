extends Node2D

signal OnMenuItemSelected

var MenuDataManager := CMenuDataManager.new()
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
	var menuDefinition := DesignData.GetDefinition(DesignData.CMenu.cTableName, definitionName)
	
	#Get the properties from the menu.
	var headerText:String = menuDefinition[DesignData.CMenu.cFieldHeader]
	var menuItemArr:Array = menuDefinition[DesignData.CMenu.cTableLinkArrayMenuItems]
	
	#For each menuItem in the menu definition, add a menuItem UI object.
	var menuItemCount = 0
	for tableLink:Variant in menuItemArr:
		var menuItemDefinition := DesignData.GetDefinitionByTableLink(tableLink)
		createMenuItemInterfaceElement(menuItemDefinition,menuItemCount, menuItemArr.size())
		menuItemCount = menuItemCount + 1
	
	#var jsonFile := FileAccess.open("res://GameData/DesignData/Design.MenuData.json", FileAccess.READ)
	#var jsonParser:JSON = JSON.new()
	#var jsonArrParser:JSON = JSON.new()
	#jsonParser.parse(jsonFile.get_as_text())
	#
	##poops hehe.
	#
	#print("data:", type_string(typeof(jsonParser.data)) )
	#for menuObj:Variant in jsonParser.data:
		#print("menuObj: ", type_string(typeof(menuObj)))
		#var subObj = jsonParser.data[menuObj]
		#print("subObj: ", type_string(typeof(subObj)))
		#if typeof(subObj) == TYPE_ARRAY:
			#print("\t",menuObj, ":")
			#for element in subObj:
				#print("element:", type_string(typeof(element)))
				#if typeof(element) == TYPE_DICTIONARY:
					#for subElement in element:
						#print("\t\t", subElement, ": ", element[subElement])
				#else:
					#print(element)
		#else:
			#print(menuObj, " ", subObj)
			#
	return true

func createMenuItemInterfaceElement(menuItem: Dictionary, index: int, totalButtons: int) -> void:
	var text = menuItem[DesignData.CMenuItem.cFieldText]
	var id = menuItem[DesignData.cIdField]
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
	var tableLink :String = DesignData.GetString(DesignData.CMenuItem.cTableName,id, DesignData.CMenuItem.cTableLinkSubMenu)
	var callBack :String = DesignData.GetString(DesignData.CMenuItem.cTableName,id, DesignData.CMenuItem.cFieldCallback)
	
	if (callBack.length() > 0):
		print(self.has_method(callBack))
		if (!self.has_method(callBack)):
			print(get_script().get_path(), ":: callback: ", callBack, " not found for id: ", id)
		else:
			self.call(callBack)
	
	if (tableLink.length() > 0):
		if (DesignData.IsValidData(tableLink, typeof(tableLink))):
			var menuTable: String = DesignData.GetStringByTableLink(tableLink,DesignData.cIdField)
			if (menuTable.length() > 0 && menuTable != "ERROR"):
				LoadMenu(menuTable)
		else:
			print(get_script().get_path(), ":: table link: ", tableLink, " not found for id: ", id)

func quitGame() -> void:
	get_tree().quit()

func ClearMenuItems() -> void:
	pass

#######################################################################################

class CMenuDataManager:
	var m_menusById = {}
	var m_menuItemsById = {}
	
	func GetMenu( id:int )->CMenu:
		if m_menusById.has(id):
			return m_menusById[id]
		else:
			return null
		
	func GetMenuItem(id:int)->CMenuItem:
		if m_menuItemsById.has(id):
			return m_menuItemsById[id]
		else:
			return null
			
	func AddMenuData( id:int, obj:CMenu) -> void:
		if m_menusById.has(id):
			print("ERROR")
		else:
			m_menusById[id] = obj
		
	func AddMenuItemData( id:int, obj:CMenuItem) -> void:
		if m_menuItemsById.has(id):
			print("ERROR")
		else:
			m_menuItemsById[id] = obj

#######################################################################################

class CMenu:
	var m_id:int
	var m_displayName:String
	var m_objects:Array[int]
	
	func AddMenuObject(id:int) ->void:
		if m_objects.has(id):
			print("CMenu::AddMenuObject - trying to add menu object that already exists: ", id)
		else:
			m_objects.append(id)

#######################################################################################

class CMenuItem:
	var m_id:int
	var m_displayName:String
	var m_subMenu:int
	var m_callBack:String
