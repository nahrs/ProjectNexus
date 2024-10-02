extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DesignData.LoadTable(DesignData.CMenuDefinition.m_tableName)
	DesignData.LoadTable(DesignData.CMenuItemDefinition.m_tableName)
	
	#PrintMenuData("MainMenu")
	#PrintMenuData("OptionsMenu")
	#PrintMenuData("GameSelectMenu")
	
	$MenuSystem.LoadMenu("MainMenu")
	$MenuSystem.set_position(get_viewport_rect().size / 2)
	

func PrintMenuData(menuKey:StringName):
	var menuDef:DesignData.CMenuDefinition = DesignData.GetDefinition(DesignData.CMenuDefinition.m_tableName, menuKey)
	
	print("table: ", menuDef.m_id.m_table)
	print("key: ", menuDef.m_id.m_key)
	print("header: ", menuDef.m_header)
	
	for tableKey in menuDef.m_menuItems:
		var menuItemDef:DesignData.CMenuItemDefinition = DesignData.GetDefinitionByTableKey(tableKey)
		if menuItemDef == null:
			continue
			
		print("\ttable: ", menuItemDef.m_id.m_table)
		print("\tkey: ", menuItemDef.m_id.m_key)
		print("\ttext: ", menuItemDef.m_text)
		print("\tsubText: ", menuItemDef.m_subText)
		print("\tcallBack: ", menuItemDef.m_callBack)
		print("\tcallBackParams: ", menuItemDef.m_callBackParams)
		if menuItemDef.m_subMenu.m_table.length() == 0:
			print("\tsubMenu: " )
		else:
			print("\tsubMenu: ", menuItemDef.m_subMenu.m_table, "[", menuItemDef.m_subMenu.m_key, "]" )
		print("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
