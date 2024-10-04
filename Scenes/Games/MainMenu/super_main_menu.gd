extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DesignData.LoadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuData.m_tableName)
	DesignData.LoadTable(DesignData.CMenuItemData.m_tableName)
	
	$MenuSystem.LoadMenu("MainMenu",get_viewport_rect().get_center(),36)
	$BackgroundMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _exit_tree() -> void:
	$BackgroundMusic.stop()
	$MenuSystem.ClearMenuItems()
	DesignData.UnloadTable(DesignData.CUnitTestData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuItemData.m_tableName)
