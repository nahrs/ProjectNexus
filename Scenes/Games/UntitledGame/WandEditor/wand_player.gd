extends CharacterBody2D

signal hit
signal shoot

@export var speed = 400 	# How fast the player moves pixels/sec.
var screen_size = Vector2(0,0)			# size of the game window.

var dead = false
var hasFocus = false

func GetCamera() -> Camera2D:
	return $PlayerCam;

# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size = get_viewport_rect().size
	dead = false
	$PlayerCam.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if(dead):
		return
	# let death or attack animations finish
	if($AnimatedSprite2D.get_animation() == "death" && $AnimatedSprite2D.is_playing()):
		#print("currentAnim: " + $AnimatedSprite2D.get_animation())
		return
	if($AnimatedSprite2D.get_animation() == "attack" && $AnimatedSprite2D.is_playing()):
		#print("currentAnim: " + $AnimatedSprite2D.get_animation())
		return
	
	if !hasFocus:
		# check inputs
		if(Input.is_action_just_pressed("attack")):
			PlayShoot()
			return
		if Input.is_action_pressed("moveRight"):
			velocity.x += 1
		if Input.is_action_pressed("moveLeft"):
			velocity.x -= 1
		if Input.is_action_pressed("moveDown"):
			velocity.y += 1
		if Input.is_action_pressed("moveUp"):
			velocity.y -= 1
	
	# animation
	if(velocity.x != 0):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif(velocity.y != 0):
		$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		#$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.animation = "idle"
		#$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_v = false

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play()

	# movement
	move_and_collide(velocity * delta)
	position = position.clamp(Vector2.ZERO, screen_size)

func PlayShoot():
	$AnimatedSprite2D.animation = "attack"
	$AnimatedSprite2D.play()

func Shoot():
	var shootLoc : Vector2 = get_global_mouse_position()
	var shootSource : Vector2 = position
	
	#$AnimatedSprite2D.flip_h
	
	var flipMult = -1.0 if $AnimatedSprite2D.flip_h else 1.0
	
	shootSource += Vector2(2.0*flipMult, -30.0)
	
	shoot.emit(shootSource, shootLoc)

func _on_body_entered(body):
	print("Player entered : " + body.editor_description + "\n")

	#hide() # Player disappears after being hit.
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	hit.emit()
	dead = true
	
func _on_animated_sprite_2d_animation_finished():
	pass
	#if($AnimatedSprite2D.get_animation() == "attack"):
	#	Shoot()


func _on_animated_sprite_2d_frame_changed():
	if($AnimatedSprite2D.get_animation() == "attack" && $AnimatedSprite2D.frame == 3):
		Shoot()
