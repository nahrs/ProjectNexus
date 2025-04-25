extends CMachineComponentBase
class_name CMachineComponentInput

var m_inputCoords: Array[Vector2] #these are grid locations in which this machine can accept inputs.
var m_connectedObjectId:int

func GetComponentName() -> StringName:
	return CWandTypes.Components.m_sMachineInputType

#overloaded
func Update(_dt:float):
	if m_connectedObjectId == 0:
		return