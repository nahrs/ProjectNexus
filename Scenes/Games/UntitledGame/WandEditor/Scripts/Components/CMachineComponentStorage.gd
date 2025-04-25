extends CMachineComponentBase
class_name CMachineComponentStorage

class CResourceStorageInfo:
	var m_type:StringName
	var m_capacity:int
	var m_value:int

var m_resourcesByType:Dictionary
var m_totalCapacity:int
var m_totalValue:int

#Overload this
func GetComponentName() -> StringName:
	return "CMachineComponentStorage"

func OnAdded():
	m_totalCapacity = 0
	m_totalValue = 0

func IsResourceSupported(type:StringName):
	m_resourcesByType.has(type)

func AddSupportedResourceType(type:StringName, capacity:int):
	#this container will only accept resource changes for allowed types.
	if !m_resourcesByType.has(type):
		m_resourcesByType[type] = CResourceStorageInfo.new()
		var info:CResourceStorageInfo = m_resourcesByType[type]
		info.m_type = type
		info.m_capacity = capacity
		info.m_value = 0

func AddResource(type:StringName, amount:int):
	if !m_resourcesByType.has(type):
		return
	var rInfo :CResourceStorageInfo = m_resourcesByType[type]
	
	#determine the change in resource value "dr"
	var dr = min(rInfo.m_value + amount, rInfo.m_capacity) - rInfo.m_value

	#apply change to per type and total values.
	m_totalValue += dr
	rInfo.m_value += dr

func RemoveResource(type:StringName, amount:int):
	if !m_resourcesByType.has(type):
		return
	var rInfo :CResourceStorageInfo = m_resourcesByType[type]
	
	#determine the change in resource value "dr"
	var dr = rInfo.m_value - max(rInfo.m_value - amount, 0)
	
	#apply change to per type and total values.
	m_totalValue += dr
	rInfo.m_value += dr

func GetResourceValue(type:StringName)->int:
	if !m_resourcesByType.has(type):
		return 0
	return m_resourcesByType[type].m_value

func GetResourceCapacity(type:StringName)->int:
	if !m_resourcesByType.has(type):
		return 0
	return m_resourcesByType[type].m_capacity