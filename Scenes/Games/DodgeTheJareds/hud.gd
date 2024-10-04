extends CanvasLayer

signal startGame

func _ready() -> void:
	startMessage("keep your peace forever, or begin now")
	updateHighScoreText()

func showMessage(text) -> void:
	$Message.text = text
	updateHighScoreText()
	$Message.show()
	$MessageTimer.start()

func startMessage(text) -> void:
	$Message.text = text

func showGameOver() -> void:
	showMessage("you suck")
	await $MessageTimer.timeout
	
	$Message.text = "i do not think, therefor i do not am"
	$MessageTimer.stop()
	$Message.show()
	$HighScoreLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func updateScore(score) -> void:
	$ScoreLabel.text = str(score)
	if(score > int(notALib.getHighScore())):
		updateHighScore(score)
		print(notALib.getHighScore())

func updateHighScore(score) -> void:
	notALib.setHighScore(score)

func updateHighScoreText() -> void:
	$HighScoreLabel.text = str("Highscore: ", notALib.getHighScore())

func onStartButtonPressed() -> void:
	$StartButton.hide()
	startGame.emit()

func onMessageTimerTimeout() -> void:
	$Message.hide()
	$HighScoreLabel.hide()
