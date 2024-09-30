extends Node2D

# this is different
# this is also different

# hello world this is attempt number 3 

#I found god. he was dead in a toilet.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuSystem.LoadMenu("res://GameData/DesignData/Design.MenuData.json")
	$MenuSystem.ClearMenuItems("res://GameData/DesignData/Design.MenuDataTwo.json")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
