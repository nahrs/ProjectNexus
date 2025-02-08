extends Node

#var m_DesignData : IDesignDataManager
var m_DesignData : CDesignDataManager

func IsTableLoaded(table:StringName) -> bool:
	return m_DesignData.IsTableLoaded(table)

func LoadTable(table:StringName) -> bool:
	return m_DesignData.LoadTableFromDefaultFile(table)
	
func LoadTableFromFile(table:StringName, fileName:String) -> bool:
	return m_DesignData.LoadTable(table,fileName)

func UnloadTable(table:String) -> bool:
	return m_DesignData.UnloadTable(table)

func GetData( table:StringName, key:StringName) -> CBaseData:
	return m_DesignData.GetData(table, key)

func GetDataByTableKey( tableKey:CTableKey ) -> CBaseData:
	return m_DesignData.GetDataByTableKey(tableKey)

func GetTables() -> Array:
	return m_DesignData.GetTables()

func GetKeys(table:StringName) -> Array:
	return m_DesignData.GetKeys(table)

func RegisterDataTypes() -> void:
	m_DesignData.RegisterDataType(CUnitTestData)
	m_DesignData.RegisterDataType(CMenuData)
	m_DesignData.RegisterDataType(CMenuItemData)

func RunDesignDataUnitTest():
	var unitData := DesignData.GetData(DesignData.CUnitTestData.m_tableName, "EntryOne") as DesignData.CUnitTestData
	if unitData != null:
		print(unitData.GetContents(), "\n")
	else:
		print("Could not find data for ", DesignData.CUnitTestData.m_tableName, " ", "EntryThree")
	
	unitData = DesignData.GetData(DesignData.CUnitTestData.m_tableName, "EntryTwo") as DesignData.CUnitTestData
	if unitData != null:
		print(unitData.GetContents(), "\n")
	else:
		print("Could not find data for ", DesignData.CUnitTestData.m_tableName, " ", "EntryThree")
	
	unitData = DesignData.GetData(DesignData.CUnitTestData.m_tableName, "EntryThree") as DesignData.CUnitTestData
	if unitData != null:
		print(unitData.GetContents(), "\n")
	else:
		print("Could not find data for ", DesignData.CUnitTestData.m_tableName, " ", "EntryThree")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_DesignData = CDesignDataManager.new()
	RegisterDataTypes()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

######################################################################################################
######################################################################################################
######################################################################################################

class CDesignDataManager :
	var m_dataTablesByName : Dictionary
	var m_dataObjectTypesByName : Dictionary
	
	const cDataFieldTable:StringName = "table"
	const cDataFieldKeys:StringName = "keys"
	
	func RegisterDataType(dataClass:GDScript) -> void:
		print("CDesignDataManager::RegisterDataType table: ", dataClass.m_tableName, ", fileName: ", dataClass.m_fileName )
		m_dataObjectTypesByName[dataClass.m_tableName] = [dataClass.m_fileName, dataClass]
	
	######################################################################################################
	
	func GetTables() -> Array:
		return m_dataTablesByName.keys()
	
	######################################################################################################
	
	func GetKeys(table:StringName) -> Array:
		if m_dataTablesByName.has(table):
			var keys:Dictionary = m_dataTablesByName[table]
			return keys.keys()
		else:
			print("CDesignDataManager::GetKeys unable to locate table ", table)
			return []
	
	######################################################################################################
	
	func GetData(table:StringName, key:StringName) -> CBaseData:
		if !m_dataTablesByName.has(table):
			print("CDesignDataManager::GetData unable to locate table ", table, " with key: ", key)
			return null
		
		var keys:Dictionary = m_dataTablesByName[table]
		if !keys.has(key):
			print("CDesignDataManager::GetData unable to locate key ", key, " for table: ", table)
			return null
		
		return keys[key]
	
	######################################################################################################
	
	func GetDataByTableKey(tableKey:CTableKey) -> CBaseData:
		return GetData(tableKey.m_table, tableKey.m_key)
	
	######################################################################################################
	
	func CreateDataObject(tableName:StringName) -> CBaseData:
		#Make sure the linkings have been added for this table.
		if !m_dataObjectTypesByName.has(tableName):
			print("CDesignDataManager::CreateDataObject - ERROR no entry in m_dataObjectTypesByName defined for table: ", tableName)
			return null
		
		#Make sure the linking has correctly bound a class to the table name
		var script := m_dataObjectTypesByName[tableName][1] as GDScript
		if script == null:
			print("CDesignDataManager::CreateDataObject - ERROR failed to create script for table:", tableName)
			return null
		
		#return the newly crafted data object
		return script.new()
	
	######################################################################################################
	
	func GetTableFileName(tableName:StringName) -> String:
		#Make sure the linkings have been added for this table.
		if m_dataObjectTypesByName.has(tableName) == false:
			print("CDesignDataManager::GetTableFileName - ERROR no entry in m_dataObjectTypesByName defined for table: ", tableName)
			return ""
		
		return m_dataObjectTypesByName[tableName][0] as String
	
	######################################################################################################
	
	func IsTableLoaded(tableName:StringName) -> bool:
		return m_dataTablesByName.has(tableName) == true
	
	func LoadTableFromDefaultFile(tableName)->bool:
		var fileName:String = GetTableFileName(tableName)
		return LoadTable(tableName, fileName)
		
	func LoadTable(tableName:StringName, fileName:String)->bool:
		#m_dataTablesByName.make_read_only()
		if m_dataTablesByName.has(tableName):
			print("CDesignDataManager::LoadTable - ERROR! tried to load table that has already been loaded ", tableName )
			return false
		
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
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node should be type dictionary. Current type: ", type_string(typeof(jsonParser.data)))
			return false
		
		var root := jsonParser.data as Dictionary
		
		if !root.has(cDataFieldTable):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node missing field : \"", cDataFieldTable, "\"" )
			return false
		
		if !root.has(cDataFieldKeys):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "Root node missing field : \"", cDataFieldTable, "\"" )
			return false
		
		var jsonTableName = root[cDataFieldTable]
		var jsonKeys = root[cDataFieldKeys]
		
		if typeof(jsonTableName) != TYPE_STRING:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldTable, "\" incorrect type: ", type_string(typeof(jsonTableName)), " expected string" )
			return false
		
		jsonTableName = jsonTableName as String
		
		if jsonTableName != tableName:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldTable, "\" does not match expected: ", tableName )
			return false
		
		if(typeof(jsonKeys) != TYPE_DICTIONARY):
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " Root node \"", cDataFieldKeys, "\" incorrect type: ", type_string(typeof(jsonKeys)), " expected dictionary" )
			return false
		
		jsonKeys = jsonKeys as Dictionary
		
		if jsonKeys.size() == 0:
			print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, "\"", cDataFieldKeys, "\" is a dictionary, but it has no entries")
			return false
		
		if !m_dataTablesByName.has(tableName):
			m_dataTablesByName[tableName] = {}
			
		var keyDataTable:Dictionary = m_dataTablesByName[tableName] 
		var keyDataLoaded = 0
		for jsonKey in jsonKeys:
			var jsonKeyData = jsonKeys[jsonKey]
			if typeof(jsonKeyData) != TYPE_DICTIONARY:
				print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " for key: ", jsonKey, "expected type dictionary. actual", type_string(typeof(jsonKeyData)) )
				continue
			
			var newDataObject:CBaseData = CreateDataObject(jsonTableName)
			if newDataObject == null:
				print("CDesignDataManager::LoadTable - ERROR loading table: ", tableName, " for key: ", jsonKey, " failed to create object data" )
				continue
			
			newDataObject.LoadData(jsonKey,jsonKeyData)
			keyDataTable[jsonKey] = newDataObject
			keyDataLoaded = keyDataLoaded + 1
		
		if keyDataLoaded == 0:
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
	
	static func GetTableKeyFromString(tableKeyStr:String) ->CTableKey:
		var tableKey = CTableKey.new()
		
		if tableKeyStr.length() == 0:
			#A valid empty table key
			return tableKey
		
		# A tableKey is formated like tableName[key]
		var strArr := tableKeyStr.trim_suffix("]").split("[")
		
		#A table key is two strings.
		if strArr.size() != 2:
			print("GetTableKeyFromString - could not build a tableKey from string: ", tableKeyStr, "expected format \"table[key]\", or for empty tableKey use \".\"")
			return tableKey
		
		#we gucci
		tableKey.m_table = strArr[0]
		tableKey.m_key = strArr[1]
		return tableKey
	
	######################################################################################################
	
	static func LoadJsonInt(jsonTable:Dictionary, fieldName:StringName) -> int:
				#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonInt - could not find field: ", fieldName)
			return 0
		
		var data:Variant = jsonTable[fieldName]
		
		# make sure the json blob has the expected data type.
		if (typeof(data) != TYPE_INT) && (typeof(data) != TYPE_FLOAT):
			print("CDesignDataManager::LoadJsonInt - field ", fieldName, " expected int, actual: ", type_string(typeof(data)) )
			return 0
		
		return data as int
	
	######################################################################################################
	
	static func LoadJsonFloat(jsonTable:Dictionary, fieldName:StringName) -> float:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonFloat - could not find field: ", fieldName)
			return 0.0
		
		var data:Variant = jsonTable[fieldName]
		
		# make sure the json blob has the expected data type.
		if typeof(data) != TYPE_FLOAT:
			print("CDesignDataManager::LoadJsonFloat - field ", fieldName, " expected float, actual: ", type_string(typeof(data)) )
			return 0.0
		
		return data as float
	
	######################################################################################################
	
	static func LoadJsonString(jsonTable:Dictionary, fieldName:StringName) -> String:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::LoadJsonString - could not find field: ", fieldName)
			return ""
		
		var data:Variant = jsonTable[fieldName]
		
		# make sure the json blob has the expected data type.
		if typeof(jsonTable[fieldName]) != TYPE_STRING:
			print("CDesignDataManager::LoadJsonString - field ", fieldName, " was not of type string")
			return ""
		
		return data as String
	
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
	
	static func LoadJsonIntArray(jsonTable:Dictionary, fieldName:StringName) -> Array[int]:
		var array := InternalLoadJsonArray(jsonTable, fieldName)
		var intArray:Array[int]
		
		for entry in array:
			if typeof(entry) != TYPE_INT && typeof(entry) != TYPE_FLOAT:
				print("CDesignDataManager::LoadJsonIntArray array contents contains invalid type: ", type_string(typeof(entry)))
				continue
			intArray.push_back(entry as int)
		
		return intArray
	
	######################################################################################################
	
	static func LoadJsonFloatArray(jsonTable:Dictionary, fieldName:StringName) -> Array[float]:
		var array := InternalLoadJsonArray(jsonTable, fieldName)
		var floatArray:Array[float]
		
		for entry in array:
			if typeof(entry) != TYPE_FLOAT:
				print("CDesignDataManager::LoadJsonFloatArray array contents contains invalid type: ", type_string(typeof(entry)))
				continue
			floatArray.push_back(entry as float)
		
		return floatArray
	
	######################################################################################################
	
	static func LoadJsonStringArray(jsonTable:Dictionary, fieldName:StringName) -> Array[String]:
		var array := InternalLoadJsonArray(jsonTable, fieldName)
		var strArr:Array[String]
		
		for entry in array:
			if typeof(entry) != TYPE_STRING:
				print("CDesignDataManager::LoadJsonStringArray array contents contains invalid type: ", type_string(typeof(entry)))
				continue
			strArr.push_back(entry as String)
		
		return strArr
	
	######################################################################################################
	
	static func LoadJsonTableKeyArray(jsonTable:Dictionary, fieldName:StringName) -> Array[CTableKey]:
		var strArr := InternalLoadJsonArray(jsonTable, fieldName)
		
		#build the array of CTableKey links
		var tableKeyArr: Array[CTableKey]
		for jStr in strArr:
			if typeof(jStr) != TYPE_STRING:
				print("CDesignDataManager::LoadJsonTableKeyArray - field ", fieldName, " was not of String")
				continue
			var key := GetTableKeyFromString(jStr as String)
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
	
	static func InternalLoadJsonArray(jsonTable:Dictionary, fieldName:StringName) -> Array:
		#make sure the json blob has the field we want.
		if !jsonTable.has(fieldName):
			print("CDesignDataManager::InternalLoadJsonArray - could not find field: ", fieldName)
			return []
		
		var jsonArry:Variant = jsonTable[fieldName]
		
		# make sure the json blob has the expected data type.
		if typeof(jsonTable[fieldName]) != TYPE_ARRAY:
			print("CDesignDataManager::InternalLoadJsonArray - field ", fieldName, " was not of type array")
			return []
		
		return jsonArry as Array

######################################################################################################
######################################################################################################
######################################################################################################

class CTableKey:
	var m_table:StringName
	var m_key:StringName
	func _to_string() -> String:
		if m_table.is_empty() && m_key.is_empty():
			return ""
		return m_table + "[" + m_key + "]"

######################################################################################################

class CBaseData:
	var m_id:CTableKey
	
	func _to_string() -> String:
			return str(m_id)
	
	func SetTableKey(table:StringName, key:StringName) -> void:
		if m_id == null:
			m_id = CTableKey.new()
		m_id.m_table = table
		m_id.m_key = key
	
	static func GetFieldString( prefix:String, dataName:String, value:Variant) -> String:
		return str("\n", prefix, dataName, ": ", value)
	
	#Override This to allow print contents
	func GetContents(prefix:String = "") -> String:
		return str(prefix, "id: ", m_id)
	
	#Override this to load your deisgn data from json.
	func LoadData(_key:StringName, _jsonData:Dictionary) -> void:
		print("CBaseData::LoadData - ERROR Data missing LoadData func override!")

######################################################################################################

class CUnitTestData extends CBaseData:
	static var m_tableName:StringName = "UnitTest"
	static var m_fileName:String = "res://GameData/DesignData/DesignData.UnitTest.json"
	
	var m_intVar:int
	var m_floatVar:float
	var m_stringVar:String
	var m_tableKeyVar:CTableKey
	
	var m_intArr:Array[int]
	var m_floatArr:Array[float]
	var m_stringArr:Array[String]
	var m_tableKeyArr:Array[CTableKey]

	func LoadData(key:StringName, jsonData:Dictionary) -> void:
		SetTableKey(m_tableName, key)
		m_intVar = CDesignDataManager.LoadJsonInt(jsonData, "intVar")
		m_floatVar = CDesignDataManager.LoadJsonFloat(jsonData, "floatVar")
		m_stringVar = CDesignDataManager.LoadJsonString(jsonData, "stringVar")
		m_tableKeyVar = CDesignDataManager.LoadJsonTableKey(jsonData, "tableKeyVar")
		m_intArr = CDesignDataManager.LoadJsonIntArray(jsonData, "intArr")
		m_floatArr = CDesignDataManager.LoadJsonFloatArray(jsonData, "floatArr")
		m_stringArr = CDesignDataManager.LoadJsonStringArray(jsonData, "stringArr")
		m_tableKeyArr = CDesignDataManager.LoadJsonTableKeyArray(jsonData, "tableKeyArr")
	
	func GetContents(prefix:String = "") -> String:
		var contents = str( super(prefix)
			, GetFieldString(prefix, "intVar: ", m_intVar)
			, GetFieldString(prefix, "floatVar: ", m_floatVar)
			, GetFieldString(prefix, "stringVar: ", m_stringVar)
			, GetFieldString(prefix, "tableKeyVar: ", m_tableKeyVar)
			, GetFieldString(prefix, "intArr: ", m_intArr)
			, GetFieldString(prefix, "floatArr: ", m_floatArr)
			, GetFieldString(prefix, "stringArr: ", m_stringArr)
			, GetFieldString(prefix, "tableKeyArr: ", m_tableKeyArr) )
		return contents

######################################################################################################

class CMenuData extends CBaseData:
	static var m_tableName:StringName = "Menu"
	static var m_fileName:String = "res://GameData/DesignData/DesignData.Menu.json"
	
	var m_header:String
	var m_menuItems: Array[CTableKey]
	var m_rows:int

	func LoadData(key:StringName, jsonData:Dictionary) -> void:
		SetTableKey(m_tableName, key)
		m_header = CDesignDataManager.LoadJsonString(jsonData, "header")
		m_menuItems = CDesignDataManager.LoadJsonTableKeyArray(jsonData, "menuItems")
		m_rows = CDesignDataManager.LoadJsonInt(jsonData, "rows")

	func GetContents(prefix:String = "") -> String:
		var contents = str( super(prefix)
			, GetFieldString(prefix, "header", m_header)
			, GetFieldString(prefix, "menuItems", m_menuItems)
			, GetFieldString(prefix, "rows", m_rows))
		return contents

######################################################################################################

class CMenuItemData extends CBaseData:
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
	
	func GetContents(prefix:String = "") -> String:
		var contents = str( super(prefix)
			, GetFieldString(prefix, "text", m_text)
			, GetFieldString(prefix, "subText", m_subText)
			, GetFieldString(prefix, "callback", m_callBack)
			, GetFieldString(prefix, "callbackParams", m_callBackParams)
			, GetFieldString(prefix, "subMenu", m_subMenu))
		return contents
