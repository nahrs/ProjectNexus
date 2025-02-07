extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OpenEditor():
	$TopCanvasLayer.show()
	$TopCanvasLayer/Player.hasFocus = true
	$TopCanvasLayer/Player/Camera2D.custom_viewport($UICanvasLayer/WandEditorViewport)
	
	
func CloseEditor():
	$TopCanvasLayer.hide()
	$TopCanvasLayer/Player.hasFocus = false
