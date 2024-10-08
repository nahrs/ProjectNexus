extends Node

@export var mob_scene: PackedScene
@export var projectile_scene: PackedScene
var score
var gameover = false

var snakeFade = 0.0
var TargetSnakeFade =  0.0
var snakeFadeRate = 2.0

var bgFade = 1.0
var tarBGFade = 1.0
var bgFadeRate = 0.2

var busLogTimer = 0.0

var startingFrogPos := Vector2.ZERO

var smootherIndex:int
var audioSmoother = []

var sampleDt = 0.0
var sampleRate:float = 0.0

var targetScale:float = 1.0
var currentScale:float = 1.0
var scaleChangeRate:float = 10

var labelUpdateTimer:float = 0.0

var audioTrendIndex: int = 0
var audioTrend = []
var prevAudioTrend: float = 0.0

var trendHigh: float = 0.0
var trendLow: float = 1.0
var idleTimer: float = 0.0

var eAnimStateClose:int = 0
var eAnimStateMid:int = 1
var eAnimStateHigh:int = 2
var singAnimState:int = eAnimStateClose
var prevAnimState:int = eAnimStateClose

#var bgm := $InitialBGM

#func getAudio(audioName:String) -> AudioStreamPlayer:
#	return  get_node(audioName)

func getAnim( animName:String ) -> AnimatedSprite2D:
	return get_node(animName)

func checkPlayAnim(animNode:String, anim:String, ) -> void:
	var node:AnimatedSprite2D = getAnim(animNode)
	if(node != null):
		if(node.animation != anim):
			node.play(anim)

#func getAudioEffect()

########################################################
##		OVERLOADED FUNCTIONS
########################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$InitialBGM.play()
	#var poo : AudioStreamPlayer = get_node("InitialBGM")
	#var glubby:int = GodotHelpers.gooberus
	#var poo := GodotHelpers.getAudio("InitialBGM")
	#var poo := GodotHelpers.AsAudioSteamPlayer(get_node("InitialBGM"))
	
	#var poo := getAudio("InitialBGM")
	#var poo := getAudio("SnakeEaterVocals")
	#poo.bus = "MusicBus"
	
	$Snake.hide()
	$Frog.play("walk")
	#poo.bus = "LipSyncBus"
	#poo.play()
	
	#var poopoo := getAudio("WhatAThrill")
	#poopoo.play()
	
	audioSmoother.resize(60)
	audioSmoother.fill(0.0)
	
	audioTrend.resize(5)
	audioTrend.fill(0.0)
	
	var frogAnim:AnimatedSprite2D = getAnim("Frog")
	startingFrogPos = frogAnim.position
	
	#$VocalsVolume.show()
	#
	#var snakeAnim := getAnim("SnakeSinger")
	#snakeAnim.play("Idle")
	#snakeAnim.show()
	
	#var micBusIndex:int = AudioServer.get_bus_index("LipSyncBus")
	#var micBusIndex:int = AudioServer.get_bus_index("MicBus")
	#var micBusIndex:int = AudioServer.get_bus_index("MicBus")
	#var effect:AudioEffectRecord = AudioServer.get_bus_effect(micBusIndex, 0)
	#effect.set_recording_active(true)
	#var recording = effect.get_recording()
	#
	#var micInput:AudioStreamPlayer = getAudio("MicInput")
	#micInput.stream = recording
	#$MicInput
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(TargetSnakeFade != snakeFade):
		#if( TargetSnakeFade > snakeFade ):
			#snakeFade += (delta * snakeFadeRate)
		#else:
			#snakeFade -= (delta * snakeFadeRate)
		#snakeFade = clampf(snakeFade, 0.0, 1.0)
		#$Snake.self_modulate = Color(1,1,1, snakeFade)
	
	if(tarBGFade != bgFade):
		if( tarBGFade > bgFade ):
			bgFade += (delta * bgFadeRate)
		else:
			bgFade -= (delta * bgFadeRate)
		bgFade = clampf(bgFade, 0.0, 1.0)
		#print("BGFade: " + str(bgFade) )
	$BG.self_modulate = Color(1,1,1, bgFade)
	$MGSBG.self_modulate = Color(1,1,1, 1-bgFade)
	
	#var busIndex:int = AudioServer.get_bus_index("MusicBus")
	var busIndex:int = AudioServer.get_bus_index("LipSyncBus")
	var db:float = AudioServer.get_bus_peak_volume_right_db(busIndex,0)
	var smoothDb:float = 0.0
	
	#audioSmoother[smootherIndex] = db
	#smootherIndex = (smootherIndex+1) % audioSmoother.size()
	
	sampleDt += delta
	if(sampleDt > sampleRate):
		audioSmoother[smootherIndex] = db
		smootherIndex = (smootherIndex+1) % audioSmoother.size()
		sampleDt -= sampleRate
	
	for i in audioSmoother.size():
		smoothDb+= audioSmoother[smootherIndex]
	smoothDb = smoothDb/audioSmoother.size()
	
	#print("SmoothDb: " + str(smoothDb))
	
	var dbLerp = 1.0 - clamp(abs(db)/48, 0.0, 1.0)
	
	#print("SmoothDb: " + str(lerp))
	
	targetScale = dbLerp*dbLerp
	
	
	#var fMod:float = abs(44+db)
	#var lerp:float = clamp(fMod/44, 0.0, 1.0)
	
	if(targetScale > currentScale):
		currentScale = min(targetScale, currentScale +( delta * scaleChangeRate))
	elif(targetScale < currentScale):
		currentScale = max(targetScale, currentScale -( delta * scaleChangeRate))
	
	var modScale:float = lerp(2.0, 6.0, dbLerp)
	
	#print("currentScale " + str(currentScale) )
	
	#var fscale:float = lerp(smoothDb,2.0, currentScale)
	
	var frogAnim:AnimatedSprite2D = getAnim("Frog")
	
	#if $WhatAThrill.is_playing() :
	frogAnim.show()
	#else:
	#	frogAnim.hide()
	
	#frogAnim.scale = Vector2(3.0,abs(modScale) )
	
	frogAnim.speed_scale = (modScale-1.5)
	
	#var curFrame:int = frogAnim.frame
	#var sframes:SpriteFrames = frogAnim.sprite_frames
	#var frameTex := sframes.get_frame_texture("run",0)
	#var animHeight = frameTex.get_height()

func _on_player_hit():
	game_over()

########################################################
##		EVENT HANDLERS
########################################################
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI/2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0,250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
	mob.connect("mobDead", _on_mob_dead)
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

########################################################
##		USER FUNCTIONS
########################################################

func game_over():
	gameover = true
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("AllMobs", "PlayerDead", $Player.position)
	#get_node("MGSSinger").call("BeginSequence")
	#$PostMatchSnakeTimer.start()
	$BeginThrillingTimer.start()


func new_game():
	score = 0
	gameover= false
	get_tree().call_group("AllMobs", "queue_free")
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	StopSnaking()
	$InitialBGM.stop()
	

func StartSnaking():
	$InitialBGM.stop()
	get_node("MGSSingers").call("BeginSequence")

func StopSnaking():
	$MGSBG.hide()
	$BG.show()
	$JustCop.hide()
	#$BGFadeOutTimer.stop()
	bgFade = 1.0
	tarBGFade = 1.0
	get_node("MGSSingers").call("EndSequence")
	$HUD.call("EndThrilling")

func _on_player_shoot(shootSource, shootDest):
	LaunchProjectile(shootSource, shootDest)
	$ShotsFired.play()

func LaunchProjectile(shootSource, shootDest):
	var projectile = projectile_scene.instantiate()
	var dir : Vector2 = (shootDest - shootSource)
	projectile.Start(shootSource, dir.normalized(), 200)
	add_child(projectile)
	projectile.connect("signalExplosion", _on_projectile_explode)

func _on_mob_dead():
	$PolicemanDefeated.play()
	score += 1
	$HUD.update_score(score)
	
func _on_projectile_explode():
	$Explosion.play()

func _on_mgs_singers_thrill_bg_fade_in():
	$MGSBG.show()
	#$BG.hide()
	$JustCop.show()
	bgFade = 1.0
	tarBGFade = 0.0

func _on_mgs_singers_thrill_bg_fade_out():
	$MGSBG.show()
	#$BG.hide()
	$JustCop.show()
	bgFade = 0.0
	tarBGFade = 1.0

func _on_mgs_singers_thrill_acorn_barrage():
	for val in 25:
		var source = Vector2(val*80,-300)
		var dest = Vector2(val*80,10)
		LaunchProjectile( source, dest )
	
	for val in 25:
		var source = Vector2(val*80,0)
		var dest = Vector2(val*80,10)
		LaunchProjectile( source, dest )

func _on_begin_thrilling_timer_timeout():
	StartSnaking()


func _on_mgs_singers_thrill_subtitles_begin():
	$HUD.call("BeginThrilling")


func _on_mgs_singers_thrill_music_begin():
	$HUD.call("ThrillMusicBegin")
