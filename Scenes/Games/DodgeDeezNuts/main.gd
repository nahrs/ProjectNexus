extends Node

@export var acorn_scene: PackedScene
@export var almond_scene: PackedScene
@export var cashew_scene: PackedScene
@export var peanut_scene: PackedScene
var score

func new_game():
	$MenuMusic.set_stream_paused(true)
	$GameMusic.set_stream_paused(false)
	$GameMusic.seek(0.0)

	score = 0
	$Player.start($StartPosition.position)

	$HUD.update_score(score)
	$HUD.show_message("FUCK YOU")

	$StartTimer.start()

func game_over():
	$GameMusic.set_stream_paused(true)
	$GOTEEM.play()
	$ScoreTimer.stop()
	$NutTimer.stop()
	$HUD.show_game_over()

	await $GOTEEM.finished
	$HUD.show_start.emit()
	$MenuMusic.set_stream_paused(false)
	$MenuMusic.seek(0.0)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$NutTimer.start()
	$ScoreTimer.start()

func _on_nut_timer_timeout():
	# Create a new instance of the Nut scene.
	# for some reason having an array of PackedScene didn't work\
	var disnut
	var some_nut = randi_range(0,3)
	if some_nut == 0:
		disnut = acorn_scene.instantiate()
	elif some_nut == 1:
		disnut = almond_scene.instantiate()
	elif some_nut == 2:
		disnut = cashew_scene.instantiate()
	else:
		disnut = peanut_scene.instantiate()


	# Choose a random location on Path2D
	var disnut_spawn_location = $NutPath/NutSpawnLocation
	disnut_spawn_location.progress_ratio = randf()
	
	# Set disnut's direction perpendicular to the path direction.
	var direction = disnut_spawn_location.rotation + PI/2
	
	# Set disnut's position to a random location
	disnut.position = disnut_spawn_location.position
	
	# Add some randomness to the direction.
	direction += randf_range(-PI/4, PI/4)
	disnut.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0,250.0), 0.0)
	disnut.linear_velocity = velocity.rotated(direction)
	$NutTimer.start(randf_range(0.0,1.0))
	# Spawn disnut by adding it to the Main scene.
	add_child(disnut)
	$DeezNuts.play()

func _ready(): # Called when the node enters the scene tree for the first time.
	$MenuMusic.play()
	$GameMusic.play()
	$GameMusic.set_stream_paused(true)

func _menu_music_loop():
	# play again when finished
	$MenuMusic.play()

func _game_music_loop():
	# play again when finished
	$GameMusic.play()
