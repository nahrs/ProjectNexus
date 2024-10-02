extends Node

#var m_DesignData : IDesignDataManager
var m_DesignData : CDesignDataManager

func IsTableLoaded(table:StringName) -> bool:
	return m_DesignData.IsTableLoaded(table)

func LoadTable(table:StringName) -> bool:
	return m_DesignData.LoadTable(table)

func UnloadTable(table:String) -> bool:
	return m_DesignData.UnloadTable(table)

func GetDefinition( table:StringName, key:StringName) -> CBaseDefinition:
	return m_DesignData.GetDefinition(table, key)

func GetDefinitionByTableKey( tableKey:CTableKey ) -> CBaseDefinition:
	return GetDefinition(tableKey.m_table, tableKey.m_key)

func RegisterDefinitions() -> void:
	m_DesignData.RegisterDefinitionType(CMenuDefinition.m_tableName, CMenuDefinition.m_fileName, CMenuDefinition )
	m_DesignData.RegisterDefinitionType(CMenuItemDefinition.m_tableName, CMenuItemDefinition.m_fileName, CMenuItemDefinition )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_DesignData = CDesignDataManager.new()
	RegisterDefinitions()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

######################################################################################################
######################################################################################################
######################################################################################################

class CDesignDataManager :
	var m_dataTablesByName : Dictionary
	var m_tableDefinitionsByName : Dictionary
	
	const cDataFieldTable:StringName = "table"
	const cDataFieldKeys:StringName = "keys"
	
	func RegisterDefinitionType(tableName:StringName, fileName:String, definitionClass:GDScript ) -> void:
		print("CDesignDataManager::RegisterDefinitionType table: ", tableName, " fileName: ", fileName )
		m_tableDefinitionsByName[tableName] = [fileName,definitionClass]
	
	######################################################################################################
	
	func GetDefinition(table:StringName, key:StringName) -> CBaseDefinition:
		if !m_dataTablesByName.has(table):
			print("CDesignDataManager::GetDefinition unable to locate table ", table, " with key: ", key)
			return null
		
		var keys:Dictionary = m_dataTablesByName[table]
		if !keys.has(key):
			print("CDesignDataManager::GetDefinition unable to locate key ", key, " for table: ", table)
			return null
		
		return keys[key]
	
	######################################################################################################
	
	func GetDefinitionByTableKey(tableKey:CTableKey) -> CBaseDefinition:
		return GetDefinition(tableKey.m_table, tableKey.m_key)
	
	######################################################################################################
	
	func CreateDefinitionObject(tableName:StringName) -> CBaseDefinition:
		#Make sure the linkings have been added for this table.
		if !m_tableDefinitionsByName.has(tableName):
			print("CDesignDataManager::CreateDefinitionObject - ERROR no entry in m_tableDefinitionsByName defined for table: ", tableName)
			return null
		
		#Make sure the linking has correctly bound a class to the table name
		var script := m_tableDefinitionsByName[tableName][1] as GDScript
		if script == null:
			print("CDesignDataManager::CreateDefinitionObject - ERROR failed to create script for table:", tableName)
			return null
		
		#return the newly crafted definition data
		return script.new()
	
	######################################################################################################
	
	func GetTableFileName(tableName:StringName) -> String:
		#Make sure the linkings have been added for this table.
		if m_tableDefinitionsByName.has(tableName) == false:
			print("CDesignDataManager::GetTableFileName - ERROR no entry in m_tableDefinitionsByName defined for table: ", tableName)
			return ""
		
		return m_tableDefinitionsByName[tableName][0] as String
	
	######################################################################################################
	
	func IsTableLoaded(tableName:StringName) -> bool:
		return m_dataTablesByName.has(tableName) == true
	
	func LoadTable(tableName:StringName)->bool:
		#m_dataTablesByName.make_read_only()
		if m_dataTablesByName.has(tableName):
			print("CDesignDataManager::LoadTable - ERROR! tried to load table that has already been loaded ", tableName )
			return false
		
		var fileName:String = GetTableFileName(tableName)
		
		var jsonFile := FileAccess.open(fileName, FileAccess.READ)
		if jsonFile == null:
			print("CDesignDataManager::LoadTable - failed to read file: ", fileName )
			return false
			
		var jsonParser:JSON = JSON.new()
		var errorCode := jsonParser.parse(jsonFile.get_as_text())
		if errorCode != OK:
			print("CDesignDataManager::LoadTable - load failure: ", tableName, " ErrorCode: ", errorCode )
			return false
		
		if typeof(jsonParser.data) != TYPE_DICTIONARY:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node should be type dictionary. Current type: ", typeof(jsonParser.data))
			return false
		
		var root := jsonParser.data as Dictionary
		
		if !root.has(cDataFieldTable):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node missing field : \"", cDataFieldTable, "\"" )
			return false
		
		if !root.has(cDataFieldKeys):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node missing field : \"", cDataFieldTable, "\"" )
			return false
		
		var dTable = root[cDataFieldTable]
		var dKeys = root[cDataFieldKeys]
		
		if typeof(dTable) != TYPE_STRING:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldTable, "\" incorrect type: ", typeof(dTable), " expected string" )
			return false
		
		dTable = dTable as String
		
		if dTable != tableName:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldTable, "\" does not match expected: ", tableName )
			return false
		
		if(typeof(dKeys) != TYPE_DICTIONARY):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldKeys, "\" incorrect type: ", typeof(dKeys), " expected dictionary" )
			return false
		
		dKeys = dKeys as Dictionary
		
		if dKeys.size() == 0:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "\"", cDataFieldKeys, "\" is a dictionary, but it has no entries")
			return false
		
		if !m_dataTablesByName.has(tableName):
			m_dataTablesByName[tableName] = {}
			
		var keyTable:Dictionary = m_dataTablesByName[tableName] 
		var definitionsLoaded = 0
		for dKey in dKeys: 
			var definitionData = dKeys[dKey]
			if typeof(definitionData) != TYPE_DICTIONARY:
				print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " for key: ", dKey, "expected type dictionary. actual", typeof(definitionData) )
				continue
			
			var newDefinition:CBaseDefinition = CreateDefinitionObject(dTable)
			if newDefinition == null:
				print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " for key: ", dKey, " failed to create object definition" )
				continue
			
			newDefinition.LoadData(dKey,definitionData)			
			keyTable[dKey] = newDefinition
			definitionsLoaded = definitionsLoaded + 1
		
		if definitionsLoaded == 0:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " no valid key data was found")
			return false
		
		return true
	
	######################################################################################################
	
	func UnloadTable(tableName:StringName)->bool:
		if m_dataTablesByName.has(tableName):
			m_dataTablesByName.erase(tableName)
			print("CDesignDataManager::UnloadTable - successfully unloaded table: ", tableName )
			return true
		else:
			print("CDesignDataManager::UnloadTable - ERROR! could not locate table: ", tableName )
			return false
	
	######################################################################################################
	
	static func LoadJsonString(jsonTable:Dictionary, fieldName:StringName) -> String:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonString - could not find field: ", fieldName)
			return ""
		
		# make sure the json blob has the expected data type.
		if typeof(jsonTable[fieldName]) != TYPE_STRING:
			print("CDesignDataManager::LoadJsonString - field ", fieldName, " was not of type string")
			return ""
		
		return jsonTable[fieldName]
	
	######################################################################################################
	
	static func GetTableKeyFromString(str:String) ->CTableKey:
		var tableKey = CTableKey.new()
		
		if str.length() == 0:
			#A valid empty table key
			return tableKey
		
		# A tableKey is formated like tableName[key]
		var strArr := str.trim_suffix("]").split("[")
		
		#A table key is two strings.
		if strArr.size() != 2:
			print("GetTableKeyFromString - could not build a tableKey from string: ", str, "expected format \"table[key]\", or for empty tableKey use \".\"")
			return tableKey
		
		#we gucci
		tableKey.m_table = strArr[0]
		tableKey.m_key = strArr[1]
		return tableKey
	
	######################################################################################################
	
	static func LoadJsonTableKey(jsonTable:Dictionary, fieldName:StringName) -> CTableKey:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonTableKey - could not find field: ", fieldName)
			return CTableKey.new()

		var data:Variant = jsonTable[fieldName]

		# make sure the json blob has the expected data type.
		if typeof(data) != TYPE_STRING:
			print("CDesignDataManager::LoadJsonTableKey - field ", fieldName, " was not of type String")
			return CTableKey.new()
		
		return GetTableKeyFromString(data)
	
	######################################################################################################
	
	static func LoadJsonTableKeyArray(jsonTable:Dictionary, fieldName:StringName) -> Array[CTableKey]:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonTableKey - could not find field: ", fieldName)
			return []
		
		# make sure the json blob has the expected data type.
		if typeof(jsonTable[fieldName]) != TYPE_ARRAY:
			print("CDesignDataManager::LoadJsonTableKey - field ", fieldName, " was not of type array")
			return []
		
		#build the array of CTableKey links
		var tableKeyArr: Array[CTableKey]
		var strArr:Array = jsonTable[fieldName]
		for str in strArr:
			if typeof(str) != TYPE_STRING:
				print("CDesignDataManager::LoadJsonTableKeyArray - field ", fieldName, " was not of String")
				continue
			var key := GetTableKeyFromString(str as String)
			if key.m_table.length() == 0:
				print("CDesignDataManager::LoadJsonTableKeyArray - field ", fieldName, " failed to create tableKey, invalid table, expected format \"table[key]\"")
				key.free()
				continue
			if key.m_key.length() == 0:
				print("CDesignDataManager::LoadJsonTableKeyArray - field ", fieldName, " failed to create tableKey, invalid key. expected format \"table[key]\"")
				key.free()
				continue
			tableKeyArr.push_back(key)
		
		return tableKeyArr

######################################################################################################
######################################################################################################
######################################################################################################

class CTableKey:
	var m_table:StringName
	var m_key:StringName

######################################################################################################

class CBaseDefinition:
	var m_id:CTableKey
	
	func SetTableKey(table:StringName, key:StringName) -> void:
		m_id = CTableKey.new()
		m_id.m_table = table
		m_id.m_key = key
	
	#Override this function for new definition tables.
	func LoadData(key:StringName, jsonData:Dictionary) -> void:
		print("CBaseDefinition::LoadData - ERROR Definition missing LoadData func override!")

######################################################################################################

class CMenuDefinition extends CBaseDefinition:
	static var m_tableName:StringName = "Menu"
	static var m_fileName:String = "res://GameData/DesignData/DesignData.Menu.json"
	
	var m_header:String
	var m_menuItems: Array[CTableKey]
	
	func LoadData(key:StringName, jsonData:Dictionary) -> void:
		SetTableKey(m_tableName, key)
		m_header = CDesignDataManager.LoadJsonString(jsonData, "header")
		m_menuItems = CDesignDataManager.LoadJsonTableKeyArray(jsonData, "menuItems")

######################################################################################################

class CMenuItemDefinition extends CBaseDefinition:
	static var m_tableName:StringName = "MenuItem"
	static var m_fileName:String = "res://GameData/DesignData/DesignData.MenuItem.json"
	
	var m_text:String
	var m_subText:String
	var m_callBack:String
	var m_callBackParams:String
	var m_subMenu:CTableKey
	
	func LoadData( key:StringName, jsonData:Dictionary) -> void:
		SetTableKey(m_tableName, key)
		m_text = CDesignDataManager.LoadJsonString(jsonData, "text")
		m_subText = CDesignDataManager.LoadJsonString(jsonData, "subText")
		m_callBack = CDesignDataManager.LoadJsonString(jsonData, "callback")
		m_callBackParams = CDesignDataManager.LoadJsonString(jsonData, "callbackParams")
		m_subMenu = CDesignDataManager.LoadJsonTableKey(jsonData, "subMenu")
