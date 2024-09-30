extends Node2D

# this is different
# this is also different

# hello world this is attempt number 3 

#I found god. he was dead in a toilet.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$MenuSystem.LoadMenu("res://GameData/DesignData/Design.MenuData.json")
	$MenuSystem.ClearMenuItems("res://GameData/DesignData/Design.MenuDataTwo.json")

	DesignData.LoadDesignData(DesignData.CMenuItem.cFileName)
	DesignData.LoadDesignData(DesignData.CMenu.cFileName)
	var menuText := DesignData.GetString(DesignData.CMenuItem.cTableName, "MainMenu.Options", DesignData.CMenuItem.cFieldText )
	var menuOptions := DesignData.GetArray(DesignData.CMenu.cTableName, "MainMenu", DesignData.CMenu.cTableLinkArrayMenuItems)
	var header := DesignData.GetString(DesignData.CMenu.cTableName, "MainMenu", DesignData.CMenu.cFieldHeader)
	
	print("menuText: ", menuText)
	
	print("header: ", header)
	for tableLink:Variant in menuOptions:
		var def := DesignData.GetDefinitionByTableLink(tableLink)
		print("\tText: ", def[DesignData.CMenuItem.cFieldText])
		print("\tSubText: ", def[DesignData.CMenuItem.cFieldSubText])
		print("\tSubMenu: ", def[DesignData.CMenuItem.cTableLinkSubMenu])
		print("\tCallback: ", def[DesignData.CMenuItem.cFieldCallback], "\n")
	
	#test.
	
	$MenuSystem.LoadMenu("res://GameData/DesignData/TestData.json")
	$MenuSystem.createMenuItemInterfaceElement()

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
