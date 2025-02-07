extends Node2D

@export var wand_editor: PackedScene

var wEditor
var oldWindowSize : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oldWindowSize = get_window().size
	get_window().size = Vector2(1600,1080)
	InputHelper.AddKeybind("open_wand_editor", KEY_Q)
	$Player.SetFocus(true)

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
	wEditor = preload("res://Scenes/Games/UntitledGame/WandEditor/WandEditor.tscn").instantiate()
	#wEditor.position = Vector2(800,200)
	add_child(wEditor)
	$Player.SetFocus(false)
	
func HideWandEditor():
	remove_child(wEditor)
	wEditor.queue_free()
	wEditor = null
	$Player.SetFocus(true)
