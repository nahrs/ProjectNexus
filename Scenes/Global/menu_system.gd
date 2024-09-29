extends Node2D

signal OnMenuItemSelected

var MenuDataManager := CMenuDataManager.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Add a menu 
func LoadMenu(fileName: String) -> bool:
	var jsonFile := FileAccess.open("res://GameData/DesignData/Design.MenuData.json", FileAccess.READ)
	var jsonParser:JSON = JSON.new()
	var jsonArrParser:JSON = JSON.new()
	jsonParser.parse(jsonFile.get_as_text())
	
	#poops hehe.
	
	print("data:", type_string(typeof(jsonParser.data)) )
	for menuObj:Variant in jsonParser.data:
		print("menuObj: ", type_string(typeof(menuObj)))
		var subObj = jsonParser.data[menuObj]
		print("subObj: ", type_string(typeof(subObj)))
		if typeof(subObj) == TYPE_ARRAY:
			print("\t",menuObj, ":")
			for element in subObj:
				print("element:", type_string(typeof(element)))
				if typeof(element) == TYPE_DICTIONARY:
					for subElement in element:
						print("\t\t", subElement, ": ", element[subElement])
				else:
					print(element)
		else:
			print(menuObj, " ", subObj)
			
	return true

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
