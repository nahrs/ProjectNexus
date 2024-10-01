extends Node

var m_DesignData : IDesignDataManager
const cIdField = "Id"
var CMenuItem : IMenuItemDefines
var CMenu : IMenuDefines

func IsValidData(data:Variant, expectedType:int) -> bool:
	if data == null:
		print("DesignData.IsValidData null data! " )
		return false
	elif typeof(data) != expectedType:
		print("DesignData.IsValidData expected type ", type_string(expectedType), " actual: ", type_string(typeof(data)) )
		return false
	else:
		return true

func GetData(table:String, definition:String, field:String)->Variant:
	return m_DesignData.GetData(table, definition, field)
	
func GetString(table:String, definition:String, field:String)->String:
	var data:Variant = m_DesignData.GetData(table, definition, field)
	if IsValidData(data, TYPE_STRING):
		return data;
	else:
		print("DesignData.GetString - failed! ", m_DesignData.GetFieldPath(table, definition, field))
		return "ERROR"

func GetFloat(table:String, definition:String, field:String)->float:
	var data:Variant = m_DesignData.GetData(table, definition, field)
	if IsValidData(data, TYPE_FLOAT):
		return data;
	else:
		print("DesignData.GetFloat - failed! ", m_DesignData.GetFieldPath(table, definition, field))
		return 0.0

func GetInt(table:String, definition:String, field:String)->int:
	var data:Variant = m_DesignData.GetData(table, definition, field)
	if IsValidData(data, TYPE_INT):
		return data;
	else:
		print("DesignData.GetInt - failed! ", m_DesignData.GetFieldPath(table, definition, field))
		return 0

func GetArray(table:String, definition:String, field:String)->Array:
	var data:Variant = m_DesignData.GetData(table, definition, field)
	if IsValidData(data, TYPE_ARRAY):
		return data;
	else:
		print("DesignData.GetArray - failed! ", m_DesignData.GetFieldPath(table, definition, field))
		return []

func GetDefinition(table:String, definition:String) ->Dictionary:
	var data:Variant = m_DesignData.GetDefinition(table, definition)
	if IsValidData(data, TYPE_DICTIONARY):
		return data;
	else:
		print("DesignData.GetDefinition - failed! ", m_DesignData.GetTableLink(table,definition))
		return {}

func GetDataByTableLink(tableLink:String, field:String)->Variant:
	var sArr := tableLink.split("/")
	if sArr.size() == 2:
		return GetData(sArr[0], sArr[1], field)
	else:
		return null

func GetStringByTableLink(tableLink:String, field:String)->String:
	var sArr := tableLink.split("/")
	if sArr.size() == 2:
		return GetString(sArr[0], sArr[1], field)
	else:
		return "ERROR"

func GetIntByTableLink(tableLink:String, field:String)->int:
	var sArr := tableLink.split("/")
	if sArr.size() == 2:
		return GetInt(sArr[0], sArr[1], field)
	else:
		return 0

func GetFloatByTableLink(tableLink:String, field:String)->int:
	var sArr := tableLink.split("/")
	if sArr.size() == 2:
		return GetFloat(sArr[0], sArr[1], field)
	else:
		return 0.0

# A table link is a composite string of the tableName and the definitionName such as "MenuItem/MainMenu.Options"
# A common data pattern will be for one system to hold an array of tableLinks to its children.
func GetDefinitionByTableLink(tableLink:String)->Dictionary:
	var sArr := tableLink.split("/")
	if sArr.size()==2:
		return	m_DesignData.GetDefinition(sArr[0], sArr[1])
	else:
		print("DesignData.GetDefinitionByTableLink - ERROR! invalid table link, not formatted correctly: ", tableLink )
		return {}

func LoadDesignData(fileName:String) -> bool:
	return m_DesignData.LoadTable(fileName)

func UnloadDesignData(fileName:String) -> bool:
	return m_DesignData.UnloadTable(fileName)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_DesignData = IDesignDataManager.new()
	#CDefine = IMenuItemDefines.new()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class IDesignDataManager :
	var m_dataTablesByName : Dictionary
	
	func GetDesignName(fileName:String) -> String:
		return fileName.get_file().trim_suffix(".json").trim_prefix("DesignData.")
	
	func GetFieldPath(table:String, definition:String, field:String) -> String:
		return table + "/" + definition + "/" + field
	
	func GetTableLink(table:String, definition:String) -> String:
		return table + "/" + definition
	
	func LoadTable(fileName:String)->bool:
		#m_dataTablesByName.make_read_only()
		var designName := GetDesignName(fileName)
		if m_dataTablesByName.has(designName):
			print("IDesignDataManager::LoadTable - ERROR! tried to load table that has already been loaded ", designName )
			return false
		else:
			var jsonFile := FileAccess.open(fileName, FileAccess.READ)
			if jsonFile == null:
				print("IDesignDataManager::LoadTable - failed to read file: ", fileName )
				return false
			
			var jsonParser:JSON = JSON.new()
			var errorCode := jsonParser.parse(jsonFile.get_as_text())
			if errorCode != OK:
				print("IDesignDataManager::LoadTable - load failure: ", designName, " ErrorCode: ", errorCode )
				return false
			else:
				#Store this design data in our lookup table. strip all the json bullshit.
				if typeof(jsonParser.data) == TYPE_DICTIONARY:
					m_dataTablesByName[designName] = jsonParser.data.duplicate(true)
					var table:Dictionary = m_dataTablesByName[designName]
					#Loop through the table to grab all the definition keys.
					for defKey in table:
						var definition:Dictionary = table[defKey]
						#this should be a definition if the data was formatted correctly, which should be of type dictionary.
						if typeof(definition) == TYPE_DICTIONARY:
							if !definition.has(cIdField):
								#Add the id field if it does not exist.
								definition[cIdField] = table.find_key(definition)
							#This will prevent a user from accidentally changing definition data, which could cause very strange behavior.
							definition.make_read_only()
						else:
							print("IDesignDataManager::LoadTable - failure definition should be of type dictionary")
					print("IDesignDataManager::LoadTable - load success: ", designName )
				else:
					print("IDesignDataManager::LoadTable - load failure: ", designName, " expected root type dictionary, got ", type_string(typeof(jsonParser.data)))
			return false
	
	func UnloadTable(fileName:String)->bool:
		var designName := GetDesignName(fileName)
		if m_dataTablesByName.has(designName):
			m_dataTablesByName.erase(designName)
			print("IDesignDataManager::Unloaded - successfully unloaded ", designName )
			return true
		else:
			print("IDesignDataManager::Unloaded - ERROR! file not loaded: ", fileName )
			return false
	
	func GetDataByDesignPath(designPath:String) -> Variant:
		var arr := designPath.split("/")
		if arr.size() == 3:
			return GetData(arr[0], arr[1], arr[2])
		else:
			print("IDesignDataManager::GetDataByDesignPath - ERROR! invalid design path: ", designPath, " correct format = <tableName>/<definitionName>/<fieldName>")
			return null
	
	func GetData(table:String, definition:String, field:String) -> Variant:
		if m_dataTablesByName.has(table) == true:
			var t:Dictionary = m_dataTablesByName[table]
			if t.has(definition):
				var d:Dictionary = t[definition]
				if d.has(field):
					return d[field]
				else:
					print("IDesignDataManager::GetData - ERROR! could not locate field", table, "/", definition, "/", field)
			else:
				print("IDesignDataManager::GetData - ERROR! could not locate definition ", table, "/", definition, "/", field)
		else:
			print("IDesignDataManager::GetData - ERROR! could not locate table: ", table, "/", definition, "/", field)
		return 0
	
	func GetDefinition(table:String, definition:String) -> Dictionary:
		if m_dataTablesByName.has(table) == true:
			var t:Dictionary = m_dataTablesByName[table]
			if t.has(definition):
				var d:Dictionary = t[definition]
				if typeof(d) == TYPE_DICTIONARY:
					return d
				else:
					print("IDesignDataManager::GetDefinition - ERROR! incorrect type! ", type_string(typeof(d)), " ", table, "/", definition)
			else:
				print("IDesignDataManager::GetDefinition - ERROR! could not locate definition ", table, "/", definition)
		else:
			print("IDesignDataManager::GetDefinition - ERROR! could not locate table: ", table, "/", definition)
		return {}

#defines the functionality, display, and name of a single item in the menu.
class IMenuItemDefines:
	const cFileName := "res://GameData/DesignData/DesignData.MenuItem.json"
	const cTableName := "MenuItem"
	const cFieldText := "text"
	const cFieldSubText := "subText"
	const cFieldCallback := "callback"
	const cTableLinkSubMenu := "subMenu"

#Defines the list of items that a menu displays
class IMenuDefines:
	const cFileName := "res://GameData/DesignData/DesignData.Menu.json"
	const cTableName := "Menu"
	const cFieldHeader := "header"
	const cTableLinkArrayMenuItems := "menuItems"
