extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	
	$MenuSystem.LoadMenu("MainMenu")
	$MenuSystem.set_position(get_viewport_rect().size / 2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
