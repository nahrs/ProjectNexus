extends Node2D

func getHighScore() -> String:
	var highscorePath = "user://highscore.txt"
	var file = FileAccess.open(highscorePath, FileAccess.READ)
	var text = file.get_as_text(true)
	return text

func setHighScore(score) -> void:
	var highscorePath = "user://highscore.txt"
	var file = FileAccess.open(highscorePath, FileAccess.WRITE)
	file.store_string(str(score))
	file.close()
