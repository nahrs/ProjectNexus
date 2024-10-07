extends Area2D

@export var laserSpeedMod: float = 1000

var speed
var velo: Vector2
var number: int = 0

signal killCount

func _ready():
	$AnimatedSprite2D.play("default")
	$Timer.start()

func _process(delta: float):
	if velo.length() > 0:
		velo = velo.normalized() * speed
	position += velo * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	killCount.emit(number)
	queue_free()

func init(passedSpeed: float, spawnPos: Vector2, rot: float): 
	speed = passedSpeed + laserSpeedMod
	position = spawnPos
	var rand = randf_range(-.03, 0.03)
	rotation = (rot + rand)
	velo = Vector2.UP.rotated(rotation + (PI / 2) + rand)

func _on_body_entered(body: Node2D) -> void:
	body.kill()
	number+=1
