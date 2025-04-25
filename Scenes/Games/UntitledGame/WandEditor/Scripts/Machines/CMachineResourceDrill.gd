extends CMachineBase
class_name CMachineResourceDrill

var m_drillDelay:float
var m_drillAmount:int

#Overloaded.
func GetType()->StringName:
	return CWandTypes.Machines.m_drill

#Overloaded.
func Init()->void:
	pass

#Overloaded.
func OnAddedToGrid():
	pass