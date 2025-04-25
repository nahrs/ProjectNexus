extends CMachineBase
class_name CMachineResourceConveyor

#Overloaded.
func GetType()->StringName:
	return CWandTypes.Machines.m_conveyor

#Overloaded.
func Init()->void:
	pass

#Overloaded.
func OnAddedToGrid():
	#Add Storage component.
	var sComp := CMachineComponentStorage.new()
	AddComponent(sComp)
	
	#Add input component.
	var inputLocation = m_rootCoord - Vector2(0,1)
	var iComp:= CMachineComponentInput.new()
	iComp.m_inputCoords.append(inputLocation)
	AddComponent(iComp)
	
	#Add output componenet
	var outputLocation = m_rootCoord + Vector2(0,-1)
	var oComp := CMachineComponentOutput.new()
	oComp.m_outputCoord = outputLocation
	AddComponent(oComp)

func Update(_dt:float):
	var input := GetComponent(CWandTypes.Components.m_sMachineInputType) as CMachineComponentInput
	var output := GetComponent(CWandTypes.Components.m_sMachineOutputType) as CMachineComponentOutput
	var storage := GetComponent(CWandTypes.Components.m_sMachineStorageType) as CMachineComponentStorage

	if input == null:
		return
	elif output == null:
		return
	elif storage == null:
		return
	#Grab items from connected output component and move them into our storage.
	output.Update(_dt)
