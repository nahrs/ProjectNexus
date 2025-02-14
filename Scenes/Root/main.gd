extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$SceneTransitionSystem.SetParentNode(self)
	EventSystem.FireEvent(EventSystem.CEvents.SceneTransition, "SuperMainMenu")
	#testing git stuff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(get_local_mouse_position())
	pass
