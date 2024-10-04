extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mobTypes = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mobTypes[randi() % mobTypes.size()])

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func kill() -> void:
	queue_free()
