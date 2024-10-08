class_name InputHelper

static func AddKeybind( actionName:StringName, key) -> void:
	if !InputMap.has_action(actionName):
		InputMap.add_action(actionName)
	
	var iEvent := InputEventKey.new()
	iEvent.keycode = key
	iEvent.pressed = true
	
	if !InputMap.action_has_event(actionName,iEvent):
		InputMap.action_add_event(actionName, iEvent)
	else:
		print("already has input event: ", actionName, " key: ", str(key))
		iEvent = null

static func RemoveKeybind(actionName:StringName) -> void:
	InputMap.erase_action(actionName)
