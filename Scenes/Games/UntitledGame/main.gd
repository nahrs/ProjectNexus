extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputHelper.AddKeybind("move_right", KEY_D)
	InputHelper.AddKeybind("move_left", KEY_A)
	InputHelper.AddKeybind("move_down", KEY_S)
	InputHelper.AddKeybind("move_up", KEY_W)
	InputHelper.AddKeybind("attack", KEY_E)

func _exit_tree() -> void:
	InputHelper.RemoveKeybind("move_right")
	InputHelper.RemoveKeybind("move_left")
	InputHelper.RemoveKeybind("move_down")
	InputHelper.RemoveKeybind("move_up")
	InputHelper.RemoveKeybind("attack")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
