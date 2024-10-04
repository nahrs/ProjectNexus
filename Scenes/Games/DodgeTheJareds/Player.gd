extends Area2D

@export var speed = 400
#
# cap it all works now just run it
# jk take a look at line 40 ish
#
var screenSize
signal hit
signal shoot

var velo: Vector2 = Vector2.ZERO
var veloMax = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velo = Vector2.ZERO
	
	if Input.is_action_pressed("moveUp"):
		velo.y -= 1
	if Input.is_action_pressed("moveLeft"):
		velo.x -= 1
	if Input.is_action_pressed("moveDown"):
		velo.y += 1
	if Input.is_action_pressed("moveRight"):
		velo.x += 1
	
	if velo.length() > 0:
		velo = velo.normalized() * speed
		rotation = velo.angle() + PI * 2 # make dood rotate instead of choppy animation frames 
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if Input.is_action_pressed("shootUp"):
		var score = $Main.getScore()
		$Main.setScore(score * score)
	
	if Input.is_action_just_pressed("shootLaser"):
		shootLaser()
		
	
	veloMax = max(velo.length(), veloMax)
	position += velo * delta
	position = position.clamp(Vector2.ZERO, screenSize)
	
	
	$AnimatedSprite2D.animation = "up"
	
#	if velo.x > 0:
#		$AnimatedSprite2D.animation = "walk"
#		#$AnimatedSprite2D.flip_v = false
#		#$AnimatedSprite2D.flip_h = false
#	elif velo.x < 0:
#		$AnimatedSprite2D.animation = "walk"
#		#$AnimatedSprite2D.flip_h = true
#		#$AnimatedSprite2D.flip_v = false
#	elif velo.y != 0:
#		$AnimatedSprite2D.animation = "up"
#		#$AnimatedSprite2D.flip_v = velo.y > 0

func _on_body_entered(body):
	hide()
	hit.emit()
	
	$CollisionPolygon2D.set_deferred("disabled", true)

func start(pos) -> void:
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
	

func shootLaser():
	shoot.emit()
	$laserShot.play()


func getSpeed() -> float:
	return speed

func getVelo() -> Vector2:
	return velo

func getPos() -> Vector2:
	return position

func getRotation() -> float:
	return rotation
