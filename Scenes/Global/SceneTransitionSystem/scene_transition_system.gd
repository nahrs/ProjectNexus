extends Node

class_name SceneTransitionSystem

var m_currentScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventSystem.RegisterEvent(self, EventSystem.CEvents.SceneTransition )
	#EventSystem.RegisterEvent(self, EventSystem.CEvents.SceneTransition, OnEvent)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func OnEvent( eventName:StringName, params:Variant ):
	if eventName == EventSystem.CEvents.SceneTransition:
		HandleEventSceneTransition(params)
	else:
		print("SceneTransitionSystem::OnEvent - ERROR! unhandled event type: ", eventName)

func HandleEventSceneTransition(params:Variant) -> void:
	if typeof(params) == TYPE_STRING_NAME:
		params = params as StringName
	elif typeof(params) == TYPE_STRING:
		params = StringName(params as String)
	else:
		return
	var sceneName := params as StringName
	
	var myParent := get_parent()
	if myParent == null:
		return
	
	#If a current scene exists, delete it.
	if m_currentScene != null:
		myParent.remove_child(m_currentScene)
		m_currentScene = null
		
	m_currentScene = CreateSceneByName(sceneName)
	if m_currentScene == null:
		print("SceneTransitionSystem::HandleEventSceneTransition - unable to create scene:", sceneName)
		return
	
	myParent.add_child(m_currentScene)

func CreateSceneByName(sceneName:StringName) -> Node:
	match sceneName:
		SceneGlobal.m_superMainMenu:
			return preload("res://Scenes/Games/MainMenu/SuperMainMenu.tscn").instantiate()
		SceneGlobal.m_dodgeTheJareds:
			return preload("res://Scenes/Games/DodgeTheJareds/main.tscn").instantiate()
		SceneGlobal.m_dodgeDeezNutz:
			return preload("res://Scenes/Games/DodgeDeezNuts/main.tscn").instantiate()
		SceneGlobal.m_dodgeTheCops:
			return preload("res://Scenes/Games/DodgeTheCops/Scenes/main.tscn").instantiate()
		SceneGlobal.m_untitledGame:
			return preload("res://Scenes/Games/Untitled Game/main.tscn").instantiate()
	
	return null
