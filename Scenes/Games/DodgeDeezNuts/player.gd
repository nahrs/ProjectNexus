extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var dead = false
var animation_moving = false
var anime: AnimatedSprite2D

func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
	anime.set_animation("deezhands")
	anime.play_backwards()
	dead = false

# Called when the node enters the scene tree for the first time. (think start() from start() loop())
func _ready():
	# _ready() function is called when a node enters the scene tree,
	#  which is a good time to find the size for the game window
	screen_size = get_viewport_rect().size # Replace with function body.
	anime = $AnimatedSprite2D
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("moveDown"):
		velocity.y += 1
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 1

		
	if velocity.length() > 0:
		if animation_moving == false:
			anime.play()
		set_rotation(velocity.angle() - PI/2)
		velocity = velocity.normalized() * speed
		if velocity.x > 0:
			anime.set_flip_h(true)
		if velocity.x < 0:
			anime.set_flip_h(false)
		
		animation_moving = true
	else:
		set_rotation(0)
		if animation_moving == true:
			anime.play_backwards()
			anime.set_flip_h(!anime.is_flipped_h())
		animation_moving = false
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(_body):
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionPolygon2D.set_deferred("disabled", true)
	anime.set_animation("deadhands")
	anime.play()
	dead = true
	hit.emit()
