extends Area2D

@export var mob_scene: PackedScene

signal signalExplosion

var GoThisWay : Vector2 = Vector2.UP
var mySpeed = 100
var lifespan_max = 10.0
var lifespan = 0.0
var AnimScale = 0.25
var scaleBoost = 0.0
var scaleRate = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	lifespan = 0.0
	scaleBoost = 0.0
	var newScale : Vector2 = Vector2(AnimScale,AnimScale)
	apply_scale(newScale)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if($AnimatedSprite2D.get_animation() == "explode" && $AnimatedSprite2D.is_playing()):
		scale = (Vector2(scaleBoost+AnimScale,scaleBoost+AnimScale))
		scaleBoost += delta * scaleRate
		return
	
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	position += (GoThisWay * mySpeed * delta)
	
	lifespan+=delta
	if(lifespan > lifespan_max):
		lifespan = 0.0
		queue_free()

func Start(startPos, startVelocity, speed):
	position = startPos
	GoThisWay = startVelocity
	mySpeed = speed
	#linear_velocity = startVelocity * speed

func _on_body_entered(body: Node2D ):
	#print("Projectile entered: " + body.editor_description + "\n")
	if(body.editor_description == "Mob"):
		body.call_deferred("SetDead")
		
		#$MobDefeated.play()
		if($AnimatedSprite2D.animation != "explode" or $AnimatedSprite2D.is_playing() == false):
			$AnimatedSprite2D.animation = "explode"
			$AnimatedSprite2D.play()
			signalExplosion.emit()

func _on_animated_sprite_2d_animation_finished():
	if($AnimatedSprite2D.get_animation() == "explode"):
		queue_free()
