extends Node2D

class_name WandEditor

func GetCameraTarget() -> Node:
	return $Player

func GetMapSize()->Vector2:
	var mapSize:Vector2 = $WandBackground.get_used_rect().size
	var tSet:TileSet = $WandBackground.tile_set
	var finalSize = Vector2( tSet.tile_size.x * mapSize.x, tSet.tile_size.y * mapSize.y)
	print("Wandbackground rect size: ", finalSize, " tileSetSize: ", tSet.tile_size, " tileCount ", mapSize)
	return finalSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player := GetCameraTarget()
	
	player.screen_size = GetMapSize()
	player.hasFocus = true
	#var cam :Camera2D = player.GetCamera()
	#cam.custom_viewport($SubViewportContainer/WandEditorViewport)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OpenEditor():
	pass
	

func CloseEditor():
	GetCameraTarget().hasFocus = false
	
	
