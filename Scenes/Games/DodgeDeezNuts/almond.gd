extends RigidBody2D

var rotation_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	# instead of following the tutorial and using 3 animations,
	# I am using random rotation
	rotation_speed = randi_range(5, 15)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rotation_speed * delta * randi_range(-1, 1)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
