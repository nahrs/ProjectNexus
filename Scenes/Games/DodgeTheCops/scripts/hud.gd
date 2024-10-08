extends CanvasLayer

#signal that game has started.
signal start_game

var lyric_text = [
	"What a thrill", 									12,
	"With darkness and silence through the night",		16,
	"What a thrill",									23,
	"I'm searching and I'll melt into you",				27,
	"What a fear in my heart",							33,
	"But you're so supreme",							37,
	"I give my life",									43,
	"Not for honor, but for you",						47,
	"In my time, there'll be no one else",				54,
	"Crime, it's the way I fly to you",					66,
	"I'm still in a dream, snake eater",				76,
	"Someday you go through the rain",					87,
	"Someday you feed on a tree frog",					92,
	"It's ordeal, the trial to survive",				97,
	"For the day we see new light",						103,
	"I give my life",									109,
	"Not for honor, but for you",						112,
	"In my time, there'll be no one else",				120,
	"Crime, it's the way I fly to you",					131,
	"I'm still in a dream", 							141,
	"snake eater",										146,
	"I'm still in a dream",								157,
	"Snake eater",										162,
	"",													169
	]

#			Stamp	Duration
#Chorus 1 	52		2	
#Chorus 2 	1:13	2
#Chorus 3	1:57 	3
#Chorus 4	2:19	2
#Finale 5	2:50	3

#Tree Frog 1:36

#Start Time, StartWait, Play, EndWait
#var otocon = [	52, 3, 2, 3,		#52
#				4+73-(2+52+2+2), 	2, 2, 2,		#73
#				4+117-(2+73+2+2), 	2, 3, 2,		#117
#				4+139-(2+117+3+2), 	2, 2, 2,		#139
#				4+170-(2+139+2+2), 	2, 3, 2			#170
#				]
				

var eFadeIn = 0
var ePlay = 1
var eStop = 2
var eFadeOut = 3


var otoStateChanges = [
	47, # eFadeIn,
	51, # ePlay,
	54, # eStop,
	56, # eFadeOut,
	
	70, #eFadeIn,
	72, #ePlay,
	75, #eStop,
	76, #eFadeOut,
	
	114, #eFadeIn,
	116, #ePlay,
	119, #eStop,
	120, #eFadeOut,
	
	136, #eFadeIn,
	138, #ePlay,
	140, #eStop,
	142, #eFadeOut,
	
	166.5, #eFadeIn,
	168.5, #ePlay,
	171, #eStop,
	174, #eFadeOut,
]

var otoIndex = 0
var otoFade = 1.0
var targetOtoFade = 1.0
var fadeRate = 1.0

var thrillIndex = 0;

var oldWindowSize:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	oldWindowSize = get_window().size
	
	get_window().size = Vector2(1600,1080)
	
	#Initialize Keybinds
	InputHelper.AddKeybind("move_right", KEY_D)
	InputHelper.AddKeybind("move_left", KEY_A)
	InputHelper.AddKeybind("move_down", KEY_S)
	InputHelper.AddKeybind("move_up", KEY_W)
	InputHelper.AddKeybind("attack", KEY_E)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(targetOtoFade != otoFade):
		if( targetOtoFade > otoFade ):
			otoFade += (delta * fadeRate)
		else:
			otoFade -= (delta * fadeRate)
	otoFade = clampf(otoFade, 0.0, 1.0)
	$Otacon.self_modulate = Color(1,1,1, otoFade)
	$RoyCambell.self_modulate = Color(1,1,1, otoFade)
	#otoStateChanges[otoIndex]
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	$StartButton.text = "Play Again"
	
	await $MessageTimer.timeout
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$ExitButton.show()
	

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	$ExitButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func NewGameStarted():
	EndThrilling()
	

func EndThrilling():
	$Lyrics.hide()
	$WhatAThrillTimer.stop()
	$Otacon.hide()
	$RoyCambell.hide()
	thrillIndex = 0
	otoIndex = 0
	otoFade = 0.0
	targetOtoFade = 0.0

func BeginThrilling():
	thrillIndex = 0;
	#print("Thrilling Has Begun\n")
	$Lyrics.text = ""
	$Lyrics.show()
	$WhatAThrillTimer.wait_time = 0.1 # GetThrillWait(thrillIndex) - 0.5
	#print("WaitTime: " + str($WhatAThrill.wait_time))
	$WhatAThrillTimer.start()
	#$ChorusTimer.wait_time = otoStateChanges[0]
	#$ChorusTimer.wait_time = 0.1
	#$ChorusTimer.start()
	
	
func ThrillMusicBegin():
	$ChorusTimer.wait_time = otoStateChanges[0]
	$ChorusTimer.start()

func _on_what_a_thrill_timeout():
	var prevThrillIndex = thrillIndex;
	
	$Lyrics.text = GetThrillText(thrillIndex)
	$Lyrics.show()
	thrillIndex = thrillIndex + 1
	if((thrillIndex*2) < lyric_text.size()):
		var nextVerse = GetThrillWait(thrillIndex) - GetThrillWait(prevThrillIndex)
		$WhatAThrillTimer.wait_time = nextVerse
		#print("WaitTime: " + str(nextVerse))
		$WhatAThrillTimer.start()

func GetThrillText(tIndex):
	return lyric_text[tIndex*2]

func GetThrillWait(tIndex):
	return lyric_text[(tIndex*2)+1]


func _on_chorus_timer_timeout():
	match (otoIndex%4):
		0:
			otoFade = 0.0
			targetOtoFade = 1.0
			$Otacon.show()
			$Otacon.play("talk1", 0.0)
			$Otacon.self_modulate = Color(1,1,1,0.0)
			
			$RoyCambell.show()
			$RoyCambell.play("Talk4", 0.0)
			$RoyCambell.self_modulate = Color(1,1,1,0.0)
			
		1:
			if otoIndex == 17:
				$Otacon.play("talk5")
			else:
				var animTypes = $Otacon.sprite_frames.get_animation_names()
				$Otacon.show()
				$Otacon.speed_scale = randf_range(0.6,1.2)
				$Otacon.play(animTypes[randi() % (animTypes.size()-1)])
				
			var royTypes = $RoyCambell.sprite_frames.get_animation_names()
			$RoyCambell.show()
			$RoyCambell.speed_scale = randf_range(0.6,1.2)
			$RoyCambell.play(royTypes[randi() % royTypes.size()])
		2:
			$Otacon.play("talk1", 0.0)
			$RoyCambell.play("Talk4", 0.0)
		3:
			otoFade = 1.0
			targetOtoFade = 0.0
			$Otacon.self_modulate = Color(1,1,1,1.0)
			$RoyCambell.self_modulate = Color(1,1,1,1.0)
	
	otoIndex += 1;
	if otoIndex < otoStateChanges.size():
		$ChorusTimer.wait_time = otoStateChanges[otoIndex] - otoStateChanges[otoIndex-1]
		$ChorusTimer.start()


func _on_otacon_animation_finished():
	if(targetOtoFade==0):
		$Otacon.show()
		$Otacon.play("talk1", 0.0)
	else:
		var animTypes = $Otacon.sprite_frames.get_animation_names()
		$Otacon.show()
		$Otacon.speed_scale = randf_range(1.2,2.2)
		$Otacon.play(animTypes[randi() % (animTypes.size()-1)])

func _on_roy_cambell_animation_finished():
	if(targetOtoFade==0):
		$RoyCambell.show()
		$RoyCambell.play("Talk4", 0.0)
	else:
		var animTypes = $Otacon.sprite_frames.get_animation_names()
		$RoyCambell.show()
		$RoyCambell.speed_scale = randf_range(1.2,2.2)
		$RoyCambell.play(animTypes[randi() % animTypes.size()])


func _on_exit_button_pressed() -> void:
	InputHelper.RemoveKeybind("move_right")
	InputHelper.RemoveKeybind("move_left")
	InputHelper.RemoveKeybind("move_down")
	InputHelper.RemoveKeybind("move_up")
	InputHelper.RemoveKeybind("attack")
	
	get_window().size = oldWindowSize
	
	EventSystem.FireEvent(EventSystem.CEvents.SceneTransition, SceneGlobal.m_superMainMenu)
