extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DesignData.LoadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuItemData.m_tableName)
	
	#PrintMenuData("MainMenu")
	#PrintMenuData("OptionsMenu")
	#PrintMenuData("GameSelectMenu")
	#PrintMenuData("Poopies")
	RunDesignDataUnitTest()
	
	$MenuSystem.LoadMenu("MainMenu")
	$MenuSystem.set_position(get_viewport_rect().size / 2)

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

func PrintMenuData(menuKey:StringName):
	var menuDef:DesignData.CMenuData = DesignData.GetData(DesignData.CMenuData.m_tableName, menuKey)
	if(menuDef == null):
		print("PrintMenuData - could not find MenuData for: ", menuKey)
		return
	
	print( menuDef.GetContents(), "\n" )
	
	for tableKey in menuDef.m_menuItems:
		var menuItemDef:DesignData.CMenuItemData = DesignData.GetDataByTableKey(tableKey)
		if menuItemDef == null:
			continue
		print(menuItemDef.GetContents("\t"))
		print("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
