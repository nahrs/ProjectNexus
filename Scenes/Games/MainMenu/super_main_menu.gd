extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DesignData.LoadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuItemData.m_tableName)
	
	$MenuSystem.LoadMenu("MainMenu",get_viewport_rect().get_center(),36)
	$BackgroundMusic.play()
	
	AddKeybind("menu_nav_up", KEY_W)
	AddKeybind("menu_nav_down", KEY_S)
	AddKeybind("menu_selected", KEY_ENTER)
	AddKeybind("menu_selected", KEY_KP_ENTER)
	AddKeybind("menu_back", KEY_ESCAPE)
	AddKeybind("menu_back", KEY_BACKSPACE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _exit_tree() -> void:
	$BackgroundMusic.stop()
	$MenuSystem.ClearMenuItems()
	DesignData.UnloadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuItemData.m_tableName)
	
	RemoveKeybind("menu_nav_up")
	RemoveKeybind("menu_nav_down")
	RemoveKeybind("menu_selected")
	RemoveKeybind("menu_back")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_nav_up"):
		$MenuSystem.MenuItemIncrement()
	elif event.is_action_pressed("menu_nav_down"):
		$MenuSystem.MenuItemDecrement()
	elif event.is_action_pressed("menu_selected"):
		$MenuSystem.MenuItemSelect()
	elif event.is_action_pressed("menu_back"):
		$MenuSystem.MenuItemBack()

func AddKeybind( actionName:StringName, key) -> void:
	if !InputMap.has_action(actionName):
		InputMap.add_action(actionName)
	
	var iEvent := InputEventKey.new()
	iEvent.keycode = key
	iEvent.pressed = true
	
	if !InputMap.action_has_event(actionName,iEvent):
		InputMap.action_add_event(actionName, iEvent)
	else:
		print("already has input event: ", actionName, " key: ", str(key))
		iEvent = null

func RemoveKeybind(actionName:StringName) -> void:
	InputMap.erase_action(actionName)
