extends Node2D

@export var wand_editor: PackedScene

var wEditor = null
var oldWindowSize : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oldWindowSize = get_window().size
	get_window().size = Vector2(1600,1080)
	InputHelper.AddKeybind("open_wand_editor", KEY_Q)
	HideWandEditor()

func _exit_tree() -> void:
	InputHelper.RemoveKeybind("open_wand_editor")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_wand_editor"):
		if wEditor == null:
			ShowWandEditor() 
		else:
			HideWandEditor()

func ShowWandEditor():
	if wEditor == null:
		wEditor = preload("res://Scenes/Games/UntitledGame/WandEditor/WandEditor.tscn").instantiate()
		#wEditor.position = Vector2(800,200)
		add_child(wEditor)
	
	$Player.remove_child($PlayerCam)
	wEditor.GetCameraTarget().add_child($PlayerCam)
	
	$Player.SetFocus(false)
	$MainSceneCamera.target = wEditor.GetCameraTarget()

func HideWandEditor():
	if wEditor != null:
		wEditor.GetCameraTarget().remove_child($PlayerCam)
		remove_child(wEditor)
		wEditor.queue_free()
		wEditor = null
		
	$Player.SetFocus(true)
	$Player.add_child($PlayerCam)
