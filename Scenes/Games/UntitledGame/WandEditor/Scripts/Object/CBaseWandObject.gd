extends Node
class_name CBaseWandObject

var m_id:int

#Overload this.
func IsPlaceable() ->bool:
	return false

#Overload this.
func GetType()->StringName:
	return "CBaseWandObject"

#Overload this.
func Init()->void:
	pass

#Internal Init
func _Init( id:int)->void:
	m_id = id
	Init()
