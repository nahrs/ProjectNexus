extends Node2D

signal ThrillBGFadeIn
signal ThrillBGFadeOut
signal ThrillAcornBarrage
signal ThrillMusicBegin
signal ThrillSubtitlesBegin

var thrillIndex = 0;

var snakeFade = 0.0
var TargetSnakeFade =  0.0
var snakeFadeRate = 2.0

var labelUpdateTimer:float = 0.0

var smootherIndex:int
var audioSmoother = []

var sampleDt = 0.0
var sampleRate:float = 0.0

var audioTrendIndex: int = 0
var audioTrend = []
var audioTrendWideIndex:int = 0
var audioTrendWide = []

var prevAudioTrend: float = 0.0

var trendHigh: float = 0.0
var trendLow: float = 1.0
var idleTimer: float = 0.0

var eAnimStateClose:int = 0
var eAnimStateMid:int = 1
var eAnimStateHigh:int = 2
var singAnimState:int = eAnimStateClose
var prevAnimState:int = eAnimStateClose

var currStateTimer:float = 0.0

#Debug Values
var debugView:bool = false
var debugTrueAudio:bool = false
var debugPlayMusicTrack:bool = true

func getAudio(audioName:String) -> AudioStreamPlayer:
	return  get_node(audioName)

func getAnim( animName:String ) -> AnimatedSprite2D:
	return get_node(animName)
	
func checkPlayAnim(animNode:String, anim:String ) -> void:
	var node:AnimatedSprite2D = getAnim(animNode)
	if(node != null):
		if(node.animation != anim):
			node.play(anim)

func BeginSequence():
	#print("begin")
	
	if(debugTrueAudio):
		var muteBus:int = AudioServer.get_bus_index("MuteBus")
		AudioServer.remove_bus_effect(muteBus,0)
	
	getAudio("MGSCodec").play()
	if(debugView):
		$highBound.show()
		$lowBound.show()
		$SongState.show()
		$CurrTrend.show()
		
	#$MicInput.play()
	
func EndSequence():
	#print("end")
	getAnim("SnakeSinger").hide()
	getAnim("SnakeSinger").stop()
	getAudio("MGSCodec").stop()
	getAudio("WhatAThrill").stop()
	getAudio("SnakeEaterVocals").stop()
	$highBound.hide()
	$lowBound.hide()
	$SongState.hide()
	$CurrTrend.hide()
	$Lyrics.hide()
	$MusicStartTimer.stop()
	$CustomBGFadeInTimer.stop()
	$CustomBGFadeOutTimer.stop()
	$VocalStartTimer.stop()
	$AcornBarrageTimer.stop()
	$SnakeFadeOutTimer.stop()
	$SequenceFinished.stop()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#var poo := getAudio("SnakeEaterVocals")
	#poo.bus = "MusicBus"
	
	#$Snake.hide()
	#$Frog.play("walk")
	#poo.bus = "LipSyncBus"
	#poo.play()
	
	#var poopoo := getAudio("WhatAThrill")
	#poopoo.play()
	
	audioSmoother.resize(60)
	audioSmoother.fill(0.0)
	
	audioTrend.resize(12)
	audioTrend.fill(0.0)
	
	audioTrendWide.resize(24)
	audioTrendWide.fill(0.0)
	
	#$VocalsVolume.show()
	
	#var snakeAnim := getAnim("SnakeSinger")
	#snakeAnim.play("Idle")
	#snakeAnim.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#var micBusIndex:int = AudioServer.get_bus_index("MicBus")
	#var busIndex:int = AudioServer.get_bus_index("LipSyncBus")
	#var micMag:float = AudioServer.get_bus_peak_volume_right_db(micBusIndex,0)
	
	#db_to_linear(
	
	#$MicOutput.text = "Mic: " + str(micMag)
	
	if(TargetSnakeFade != snakeFade):
		if( TargetSnakeFade > snakeFade ):
			snakeFade += (delta * snakeFadeRate)
		else:
			snakeFade -= (delta * snakeFadeRate)
		snakeFade = clampf(snakeFade, 0.0, 1.0)
		getAnim("SnakeSinger").self_modulate = Color(1,1,1, snakeFade)
	
	if !getAudio("SnakeEaterVocals").playing:
		return
	
	var busIndex:int = AudioServer.get_bus_index("LipSyncBus")
	#var busIndex:int = AudioServer.get_bus_index("LipSyncBus")
	var db:float = AudioServer.get_bus_peak_volume_right_db(busIndex,0)
	#db += AudioServer.get_bus_peak_volume_left_db(busIndex,0)
	
	#db = micMag
	
	var smoothDb:float = 0.0
	
	#db2linear(
	
	sampleDt += delta
	if(sampleDt > sampleRate):
		audioSmoother[smootherIndex] = db
		smootherIndex = (smootherIndex+1) % audioSmoother.size()
		sampleDt -= sampleRate
	
	for i in audioSmoother.size():
		smoothDb+= audioSmoother[smootherIndex]
	smoothDb = smoothDb/audioSmoother.size()

	var dbLerp = 1.0 - clamp(abs(db)/48, 0.0, 1.0)
	
	#var modScale:float = dbLerp(2.0, 10.0, dbLerp)
	
	audioTrend[audioTrendIndex] = dbLerp
	audioTrendIndex = (audioTrendIndex + 1)%audioTrend.size()
	
	audioTrendWide[audioTrendIndex] = dbLerp
	audioTrendWideIndex = (audioTrendWideIndex + 1)%audioTrendWide.size()
	
	var currTrend:float = 0.0
	for n in audioTrend:
		currTrend += audioTrend[n]
	currTrend = currTrend/audioTrend.size()
		
	var currWideTrend:float = 0.0
	for n in audioTrendWide.size():
		audioTrendWideIndex += audioTrendWide[n]
	currWideTrend = currWideTrend/audioTrendWide.size()
	
	var _audioDt:float = currTrend - prevAudioTrend
	
	var snakeAnim:AnimatedSprite2D = getAnim("SnakeSinger")
	var isAnimPlaying:bool = snakeAnim.is_playing()
	isAnimPlaying = false

	var trendEpsilon:float = 0.07 #0.15
	var midTrendEpsilon:float = 0.07 #0.1
	var _midTrendEpisolonNeg:float = 0.12
	var _lowTrendEpisilon:float = 0.07
	var highbound:float = 0.95
	var _midBound:float = 0.5
	var lowBound:float = 0.3
	var minStateTime:float = 0.025
	var playedIdle:bool = false
	
	match( singAnimState ):
		eAnimStateClose:
		#Begin Close State#########################################################
			if(prevAnimState!=singAnimState):
				#On Enter Init
				checkPlayAnim("SnakeSinger", "3_Mid_Close")
				trendLow = currTrend
				trendHigh = 0.0
				prevAnimState = singAnimState
				idleTimer = 0.0
				playedIdle = false
				currStateTimer = 0.0
			currStateTimer+=delta
			idleTimer+=delta
			if(!isAnimPlaying && idleTimer > 0.5 && !playedIdle && currStateTimer > minStateTime):
				var idleAnim:int = randi_range(0,1)
				match(idleAnim):
					0: 
						checkPlayAnim("SnakeSinger", "Idle")
					1: 
						checkPlayAnim("SnakeSinger", "IdleNoise")
				playedIdle=true
				idleTimer = -10000.0
			#Check for Exit
			trendLow = min(trendLow, currTrend)
			#if((currTrend - trendLow) > lowTrendEpisilon ):
			if((currTrend - trendLow) > trendEpsilon && currTrend > lowBound ):
				singAnimState = eAnimStateMid
		eAnimStateMid:
		#BeginMidState#############################################################
			if(prevAnimState!=singAnimState):
				#On Enter Init
				if(prevAnimState == eAnimStateClose):
					checkPlayAnim("SnakeSinger","0_Close_Mid")
				else:
					checkPlayAnim("SnakeSinger","2_High_Mid")
				trendLow = currTrend
				trendHigh = currTrend
				currStateTimer = 0.0
				prevAnimState = singAnimState
			currStateTimer+=delta
			trendHigh = max(trendHigh, currTrend)
			trendLow = min(trendLow, currTrend)
			if(currStateTimer > minStateTime):
				if((currTrend - trendLow) > midTrendEpsilon ):
					singAnimState = eAnimStateHigh
				#elif((trendHigh - currTrend) > midTrendEpisolonNeg):
				elif((trendHigh - currTrend) > midTrendEpsilon && currTrend < lowBound ):
					singAnimState = eAnimStateClose
		eAnimStateHigh:
		#BeginHighState#############################################################
			if(prevAnimState!=singAnimState):
				#On Enter Init
				checkPlayAnim("SnakeSinger", "1_Mid_High")
				trendLow = 0.0
				trendHigh = currTrend
				currStateTimer = 0.0
				prevAnimState = singAnimState
			currStateTimer+=delta
			trendHigh = max(trendHigh, currTrend)
			if(currStateTimer > minStateTime):
				#if((trendHigh - currTrend) > trendEpsilon):
				if((trendHigh - currTrend) > trendEpsilon && currTrend < highbound):
					singAnimState = eAnimStateMid
		#End Switch#############################################################
	
	var stateName:String = ""
	match(singAnimState):
		eAnimStateClose: stateName = "Close"
		eAnimStateMid: stateName = "Mid"
		eAnimStateHigh: stateName = "High"
	
	$highBound.text = "High: " + str(floor(trendHigh*100))
	$lowBound.text = "Low: " + str(floor(trendLow*100))
	$CurrTrend.text = "Curr: " + str(floor(currTrend*100))
	$SongState.text = "State: " + stateName
	
	prevAudioTrend = currTrend

func _on_mgs_codec_finished():
	var snakeAnim:AnimatedSprite2D = getAnim("SnakeSinger")
	snakeAnim.show()
	snakeAnim.play("Intro")
	snakeFade = 0.0
	TargetSnakeFade = 1.0
	snakeAnim.self_modulate = Color(1,1,1, snakeFade)
	snakeAnim.show()
	
	$VocalStartTimer.start()
	$MusicStartTimer.start()
	$CustomBGFadeInTimer.start()

func _on_music_start_timer_timeout():
	#print("Thrill Begins")
	if(debugPlayMusicTrack):
		getAudio("WhatAThrill").play()
	ThrillMusicBegin.emit()

func _on_custom_bg_fade_in_timer_timeout():
	ThrillBGFadeIn.emit()

func _on_vocal_start_timer_timeout():
	#print("Vocals Begins")
	var vocals:AudioStreamPlayer = getAudio("SnakeEaterVocals")
	vocals.bus = "LipSyncBus"
	vocals.play()
	ThrillSubtitlesBegin.emit()

func _on_what_a_thrill_finished():
	$AcornBarrageTimer.start()
	$CustomBGFadeOutTimer.start()
	$SnakeFadeOutTimer.start()
	$SequenceFinished.start()

func _on_custom_bg_fade_out_timer_timeout():
	ThrillBGFadeOut.emit()

func _on_snake_fade_out_timer_timeout():
	snakeFade = 1.0
	TargetSnakeFade = 0.0

func _on_acorn_barrage_timer_timeout():
	ThrillAcornBarrage.emit()

func _on_sequence_finished_timeout():
	EndSequence()
