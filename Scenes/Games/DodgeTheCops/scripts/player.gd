extends Area2D
signal hit
signal shoot

@export var speed = 400 	# How fast the player moves pixels/sec.
var screen_size 			# size of the game window.

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(dead):
		return
	
	if($AnimatedSprite2D.get_animation() == "death" && $AnimatedSprite2D.is_playing()):
		#print("currentAnim: " + $AnimatedSprite2D.get_animation())
		return
	
	var velocity = Vector2.ZERO
	
	
	if($AnimatedSprite2D.get_animation() == "attack" && $AnimatedSprite2D.is_playing()):
		#print("currentAnim: " + $AnimatedSprite2D.get_animation())
		return
		
	if(Input.is_action_just_pressed("attack")):
		PlayShoot()
		return
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
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
		
	
	#$AnimatedSprite2D.play()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#rotation += 5 * delta;

func start(pos):
	
	if(position == Vector2.ZERO):
		position = pos
	show()
	$CollisionShape2D.disabled = false
	if(dead):
		$AnimatedSprite2D.animation = "death"
		$AnimatedSprite2D.play_backwards("death")
		dead = false
	

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
	
	if(body.editor_description != "Mob"):
		return
	
	#hide() # Player disappears after being hit.
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	dead = true
	
func _on_animated_sprite_2d_animation_finished():
	pass
	#if($AnimatedSprite2D.get_animation() == "attack"):
	#	Shoot()


func _on_animated_sprite_2d_frame_changed():
	if($AnimatedSprite2D.get_animation() == "attack" && $AnimatedSprite2D.frame == 3):
		Shoot()
