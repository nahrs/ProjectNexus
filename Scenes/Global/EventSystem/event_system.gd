extends Node

var m_eventSystem = CEventSystem.new()
const m_eventCallbackName = "OnEvent"

#signal SceneTransition

class CEvents:
	static var SceneTransition:StringName = "SceneTransition"

func FireEvent(eventName:StringName, params:Variant) -> void:
	m_eventSystem.FireEventSignal(eventName, params)

func RegisterEvent(me:Node, eventName) -> bool:
	return m_eventSystem.RegisterEventSignal(me,eventName)

func UnregisterEvent(me:Node, eventName) -> bool:
	return m_eventSystem.UnregisterEventSignal(me,eventName)
	
func UnregisterAllEvents(me:Node) -> void:
	m_eventSystem.UnregisterAllEventSignal(me)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

class CEventSystem:
	var m_eventListeners:Dictionary
	var m_signals:Array[StringName]
	
	func RegisterEventSignal(me:Node, eventName:StringName) -> bool:
		if !me.has_method(m_eventCallbackName):
			return false
		
		#Make sure the signal exists.
		if !has_user_signal(eventName):
			add_user_signal(eventName, [])
			m_signals.append(eventName)
		
		self.connect(eventName,Callable(me,m_eventCallbackName))
		
		return false
	
	func FireEventSignal(eventName:StringName, params:Variant) -> bool:
		if !has_user_signal(eventName):
			print("ERROR!")
			return false
		
		emit_signal(eventName, eventName, params)
		return true
	
	func UnregisterEventSignal(me:Node, eventName:StringName) -> bool:
		if !has_user_signal(eventName):
			print("signal does not exist")
			return false
		
		var callFunc := Callable(me, m_eventCallbackName )
		
		if !me.is_connected(eventName, callFunc):
			return false
		
		me.disconnect(eventName, callFunc)
		return true
	
	func UnregisterAllEventSignal(me:Node) -> void:
		for eSignal:StringName in m_signals:
			UnregisterEventSignal(me, eSignal)
	
	func FireEvent(eventName:StringName, params:Variant) -> void:
		if m_eventListeners.has(eventName):
			var listenerArr:Array = m_eventListeners[eventName]
			for listener in listenerArr:
				if listener == null:
					print("CEventSystem::FireEvent - Invalid event handler")
				else:
					listener.OnEvent(eventName, params)
	
	#func RegisterEvent(me:CEventListener, eventName:StringName) -> bool:
		#var eventListenerArr = null
		#if !m_eventListeners.has(eventName):
			#var newArr : Array[CEventListener]
			#eventListenerArr = m_eventListeners.get_or_add(eventName, newArr)
		#else:
			#eventListenerArr = m_eventListeners[eventName]
		#
		#eventListenerArr = eventListenerArr as Array[CEventListener]
		#
		#if !eventListenerArr.has(me):
			#eventListenerArr.push_back(me)
			#me.m_registeredEvents.push_back(eventName)
		#else:
			#print("CEventSystem::RegisterEvent - already registered for event", eventName)
		#return false
	#
	#func UnregisterEvent(me:CEventListener, eventName:StringName, cleanMe:bool = true) -> bool:
		#if me.m_registeredEvents.has(eventName):
			#if m_eventListeners.has(eventName):
				#var eventListeners := m_eventListeners[eventName] as Array
				#eventListeners.erase(me)
				#if cleanMe:
					#me.m_registeredEvents.erase(eventName)
				#return true
		#return false
	#
	#func UnregisterAllEvents(me:CEventListener) -> void:
		#for eventName in me.m_registeredEvents:
			#UnregisterEvent(me, eventName)
		#m_eventListeners.clear()
