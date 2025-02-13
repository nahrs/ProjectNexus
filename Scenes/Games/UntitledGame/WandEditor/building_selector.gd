extends Node2D
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DesignData.LoadTableFromFile(DesignData.CMenuData.m_tableName, "res://Scenes/Games/UntitledGame/WandEditor/DesignData/BuildingSelect.MenuData.json" )
	DesignData.LoadTableFromFile(DesignData.CMenuItemData.m_tableName, "res://Scenes/Games/UntitledGame/WandEditor/DesignData/BuildingSelect.MenuItemData.json")
	
	#var menuLoc := position
	#menuLoc.x += 600
	
	$MenuSystem.LoadMenu("Root",position,32)

func _exit_tree() -> void:
	$MenuSystem.ClearMenuItems()
	DesignData.UnloadTable(DesignData.CMenuData.m_tableName)
	DesignData.UnloadTable(DesignData.CMenuItemData.m_tableName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
