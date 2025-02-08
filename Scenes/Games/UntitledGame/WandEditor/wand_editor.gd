extends Node2D

class_name WandEditor

func GetCameraTarget() -> Node:
	return $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player := $SubViewportContainer/WandEditorViewport/EditorLayer/TopCanvasLayer/Player
	player.screen_size = Vector2(1000,1000)
	player.hasFocus = true
	#var cam :Camera2D = player.GetCamera()
	#cam.custom_viewport($SubViewportContainer/WandEditorViewport)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OpenEditor():
	pass
	

func CloseEditor():
	$EditorLayer/TopCanvasLayer/Player.hasFocus = false
	
	
