extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(getResistances())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getResistances() -> Dictionary:
	var fin:Dictionary= readJsonFile("res://Scenes/Games/UntitledGame/Scenes/mobs/resistances.json")
	return fin

func readJsonFile(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var contentText = file.get_as_text()
	file.close()
	var parsedJson = file.JSON.parse(contentText)
	if not parsedJson.error:
		return parsedJson.result
	else:
		print("Error parsing JSON: ", parsedJson.error_string)
