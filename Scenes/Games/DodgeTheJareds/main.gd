extends Node

@export var mobScene: PackedScene

@export var jaredScene: PackedScene
@export var jaredScene2: PackedScene
@export var jaredScene3: PackedScene
@export var jaredLetoScene: PackedScene
@export var jaredLetoScene2: PackedScene
@export var jaredLetoScene3: PackedScene
@export var laserScene: PackedScene

var score: int = 0
var highScore: int = 0
var isDead: bool = false

@warning_ignore("unused_parameter")

func _ready() -> void:
	$Music.play()

func _process(delta):
	if Input.is_action_pressed("newGame"):
		newGame()

func gameOver() -> void:
	#$Music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	isDead = true
	
	$HUD.showGameOver()

func onPlayerHit() -> void:
	gameOver()

func newGame() -> void:
	score = 0
	isDead = false
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("jareds", "queue_free")
	
	var wallpaperPath: String = "res://Scenes/Games/DodgeTheJareds/art/Wallpapers/" + str(randi_range(1,8)) + ".png"
	$Background.texture = load(wallpaperPath)
	
	$HUD/Message.hide()
	$HUD/StartButton.hide()
	$HUD.updateScore(score)
	$HUD.showMessage("pucker up buttercup")
	

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.updateScore(score)

func _on_mob_timer_timeout() -> void:
	var mobChoices: Array = [jaredScene, jaredScene2, jaredScene3, jaredLetoScene, jaredLetoScene2, jaredLetoScene3]
	var mob = mobChoices[randi_range(0, mobChoices.size()-1)].instantiate()
	
	var mobSpawnLocation = $MobPath/MobSpawnLocation
	mobSpawnLocation.progress_ratio = randf()
	
	var direction = mobSpawnLocation.rotation + PI/2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.position = mobSpawnLocation.position
	
	var velo = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velo.rotated(direction)
	
	add_child(mob)

func onLaserShot() -> void:
	if (!isDead):
		var laser = laserScene.instantiate()
		var speed = $Player.getSpeed()
		var velo = $Player.getVelo()
		var pos = $Player.getPos()
		var rot = $Player.getRotation()
		laser.init(speed, pos, rot)
		add_child(laser)
		laser.connect("killCount", onLaserDeath)

func onLaserDeath(kills: int) -> void:
	score += kills
