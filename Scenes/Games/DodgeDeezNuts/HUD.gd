extends CanvasLayer

#Notifies 'Main' node that the button has been pressed
signal start_game
signal show_start

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	
	# Wait until the MessageTimer has counted  down.
	await $MessageTimer.timeout
	
	$MessageTimer.stop()
	$Message.text = "You have been caught hands deep in someone elses nuts. Have you no shame?"
	$Message.show()
	
	await show_start
	$Message.text = "Never forget that in today's society it is still not okay you to touch nuts that are not yours."
	EventSystem.FireEvent(EventSystem.CEvents.SceneTransition, SceneGlobal.m_superMainMenu)
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	get_tree().call_group("nuts", "queue_free")
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
