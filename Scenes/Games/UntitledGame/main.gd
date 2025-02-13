extends Node2D

@export var wand_editor: PackedScene

var wEditor = null
var oldWindowSize : Vector2
var mainCam: Camera2D
var player
var wandViewPortContainer
var wandViewPort

#func GetPlayer()->Node:
	#return $CanvasLayer/GameViewportContainer/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oldWindowSize = get_window().size
	get_window().size = Vector2(1600,1080)
	InputHelper.AddKeybind("open_wand_editor", KEY_Q)
	
	player = find_child("Player")
	wandViewPort = find_child("WandEditorViewport")
	wandViewPortContainer = find_child("WandCanvas")
	
	#mainCam = Camera2D.new()
	HideWandEditor()
	
	#mainCam.make_current()
	
	DesignData.LoadTable(DesignData.CResistanceData.m_tableName)
	var physResist : DesignData.CResistanceData = DesignData.GetData("Resistances","Resistances.Physical")
	print(physResist.m_name)

func _exit_tree() -> void:
	InputHelper.RemoveKeybind("open_wand_editor")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#$Scene.texture = $SubViewportContainer/GameViewport.get_texture()
	#$WandEditor.texture = $SubViewportContainer/WandEditorViewport.get_texture()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_wand_editor"):
		if wEditor == null:
			ShowWandEditor() 
		else:
			HideWandEditor()

func ShowWandEditor():
	if wEditor == null:
		wEditor = preload("res://Scenes/Games/UntitledGame/WandEditor/WandEditor.tscn").instantiate()
		#wEditor.position = Vector2(800,200)
		
		wandViewPort.add_child(wEditor)
		wandViewPortContainer.show()
	
	player.SetFocus(false)
	#GetPlayer().remove_child(mainCam)
	
	#var newTarget = wEditor.GetCameraTarget()
	#mainCam.position = newTarget.position
	#newTarget.add_child(mainCam)
	#mainCam.zoom = Vector2(1,10)
	#mainCam.anchor_mode = 1
	#mainCam.custom_viewport = $SubViewportContainer/WandEditorViewport
	#mainCam.enabled = true
	#mainCam.make_current()

func HideWandEditor():
	if wEditor != null:
		wandViewPortContainer.hide()
		#wEditor.GetCameraTarget().remove_child(mainCam)
		wandViewPort.remove_child(wEditor)
		wEditor.queue_free()
		wEditor = null
	
	#mainCam.zoom = Vector2(4,4)
	#GetPlayer().add_child(mainCam)
	player.SetFocus(true)
	#mainCam.zoom = Vector2(7,7)
