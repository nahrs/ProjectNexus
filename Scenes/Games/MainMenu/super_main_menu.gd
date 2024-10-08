extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DesignData.LoadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuItemData.m_tableName)
	
	$MenuSystem.LoadMenu("MainMenu",get_viewport_rect().get_center(),36)
	$BackgroundMusic.play()
	
	InputHelper.AddKeybind("menu_nav_up", KEY_W)
	InputHelper.AddKeybind("menu_nav_down", KEY_S)
	InputHelper.AddKeybind("menu_selected", KEY_ENTER)
	InputHelper.AddKeybind("menu_selected", KEY_KP_ENTER)
	InputHelper.AddKeybind("menu_back", KEY_ESCAPE)
	InputHelper.AddKeybind("menu_back", KEY_BACKSPACE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _exit_tree() -> void:
	$BackgroundMusic.stop()
	$MenuSystem.ClearMenuItems()
	DesignData.UnloadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuItemData.m_tableName)
	
	InputHelper.RemoveKeybind("menu_nav_up")
	InputHelper.RemoveKeybind("menu_nav_down")
	InputHelper.RemoveKeybind("menu_selected")
	InputHelper.RemoveKeybind("menu_back")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_nav_up"):
		$MenuSystem.MenuItemIncrement()
	elif event.is_action_pressed("menu_nav_down"):
		$MenuSystem.MenuItemDecrement()
	elif event.is_action_pressed("menu_selected"):
		$MenuSystem.MenuItemSelect()
	elif event.is_action_pressed("menu_back"):
		$MenuSystem.MenuItemBack()
