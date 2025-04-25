extends Node2D

var m_wandObjectManager:CWandObjectFactory
var m_wandGrid:CWandGrid

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
	m_wandObjectManager= CWandObjectFactory.new()
	m_wandGrid = CWandGrid.new()

	var tileSize:Vector2 = $WandBackground.tile_set.tile_size
	var mapSize:Vector2 = $WandBackground.get_used_rect().size
	if tileSize.x <=0 || tileSize.y <= 0:
		return
	
	mapSize.x /= tileSize.x
	mapSize.y /= tileSize.y
	
	print("wand_editor::_ready intializing tiles, tileSize %, mapsize %"%[tileSize,mapSize])
	
	m_wandGrid.Initialize(tileSize,mapSize)
	CBaseGridObject
	
	#hackily add a few factory items.
	var smallConveyor := m_wandObjectManager.CreateWandObject("CSmallConveyor")
	var success:bool = m_wandGrid.AttachObjectToGrid(smallConveyor as CBaseGridObject, Vector2(2,4))
	if !success:
		print("Failed to attach object to grid")
	
	var player := GetCameraTarget()
	player.screen_size = GetMapSize()
	player.hasFocus = true
	#var cam :Camera2D = player.GetCamera()
	#cam.custom_viewport($SubViewportContainer/WandEditorViewport)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func OpenEditor():
	pass

func CloseEditor():
	GetCameraTarget().hasFocus = false
