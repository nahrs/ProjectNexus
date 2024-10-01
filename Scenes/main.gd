extends Node2D



# this is different
# this is also different

# hello world this is attempt number 3 

#I found god. he was dead in a toilet.

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
	print($MenuSystem.position)
	#################################################################
	# testing buttons
	
	#var viewportX = get_viewport().get_visible_rect().size.x / 2 
	#var viewportY = get_viewport().get_visible_rect().size.y / 2
	#
	#var index : int = 0
	#var totalButtons : int = 3
	#var buttonGroup := ButtonGroup.new()
	#
	#var button = Button.new()
	#
	#button.text = "1poop"
	#
	#var button2 = Button.new()
	#button2.text = "po2op"
	#
	#var button3 = Button.new()
	#button3.text = "poop3"
	#
	#print("viewportx: ", viewportX)
	#print("viewporty: ", viewportY)
	#print("button 1 x: ", button.size.x)
	#print("button 1 posx: ", button.position.x)
	#print("button 1 posy: ", button.position.y)
	#
	#add_child(button)
	#add_child(button2)
	#add_child(button3)
	#
	#button.set_position(Vector2(viewportX + ((index * button.size.x) - (totalButtons * button.size.x)/2), viewportY + (index * button.size.y)))
	#index += 1
	#button2.set_position(Vector2(viewportX + (index * button2.size.x) - (totalButtons * button2.size.x)/2 , viewportY + (index * button2.size.y)))
	#index += 1
	#button3.set_position(Vector2(viewportX + (index * button3.size.x) - (totalButtons * button3.size.x)/2, viewportY + (index * button3.size.y)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
