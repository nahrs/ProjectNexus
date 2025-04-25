extends Node
class_name CMachineComponentBase

var m_parentId:int
#Overload this
func GetComponentName() -> StringName:
	return CWandTypes.Components.m_sBaseType

func GetMachineComponent(_objectId:int, _componentType:StringName)->CMachineComponentBase:
	return null

func GetWandObject(_objectId:int)->CBaseWandObject:
	return null

#Overload this
func OnAddedToGrid(parent:CBaseGridObject):
	print("CMachineComponentBase::OnAddedToGrid - % Component Added to object % %"%[GetComponentName(), parent.GetType(), parent.m_id])

#Overload this.
func Update(_dt:float):
	pass