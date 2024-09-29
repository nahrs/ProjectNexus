extends Node2D

# this is different
# this is also different
#fuckame

# hello world this is attempt number 3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuSystem.LoadMenu("res://GameData/DesignData/TestData.json")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
