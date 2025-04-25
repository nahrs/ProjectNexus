extends CMachineComponentBase
class_name CMachineComponentOutput

var m_outputCoord: Vector2 #these are grid locations in which this sends output
var m_connectedObjectId:int
var m_resourceType:StringName
var m_xferAmount:int
var m_xferDelay:float
var m_lastTransfer:float

func GetComponentName() -> StringName:
	return CWandTypes.Components.m_sMachineOutputType

func OnAddedToGrid(parent:CBaseGridObject):
	super(parent)
	var objectId = CWandGrid.GetInstance().GetObjectAtCoord(m_outputCoord)
	if objectId != 0 && objectId != parent.m_id:
		m_connectedObjectId = objectId
		print("CMachineComponentOutput::OnAddedToGrid %,% connected to object %"%[parent.GetType(), parent.m_id, m_connectedObjectId])

func Update(_dt:float):
	if m_connectedObjectId == 0:
		return
	
	var destination := GetMachineComponent(m_connectedObjectId, CWandTypes.Components.m_sMachineStorageType) as CMachineComponentStorage
	if destination == null:
		return
	var source := GetMachineComponent(m_parentId, CWandTypes.Components.m_sMachineStorageType) as CMachineComponentStorage
	if source == null:
		return

	var destinationCap:int = destination.GetResourceCapacity(m_resourceType)
	var destinationVal:int = destination.GetResourceValue(m_resourceType)
	var sourceVal:int = source.GetResourceValue(m_resourceType)
	
	#Create a value that both machines can handle transfering.
	var xferAmount = min(sourceVal,m_xferAmount)
	xferAmount = min(destinationCap-destinationVal,xferAmount)
	
	source.RemoveResource(m_resourceType,xferAmount)
	destination.AddResource(m_resourceType,xferAmount)
	
	