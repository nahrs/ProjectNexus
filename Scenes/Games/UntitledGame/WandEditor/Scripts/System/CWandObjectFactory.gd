class_name CWandObjectFactory
static var m_instance:IObjectFactory = null

static func GetInstance() -> IObjectFactory:
	if m_instance == null:
		m_instance = IObjectFactory.new()
	return m_instance

static func DestroyInstance():
	m_instance = null

static func GetWandObject(id:int) -> CBaseWandObject:
	return GetInstance().GetWandObject(id)

static func CreateWandObject(typeName:StringName) -> CBaseWandObject:
	return GetInstance().CreateWandObject(typeName)

class IObjectFactory:
	var m_nextObjId:int = 0
	var m_objects:Dictionary

	func GetWandObject(id:int) -> CBaseWandObject:
		return m_objects.get(id,null)
		
	func CreateWandObject(typeName:StringName) -> CBaseWandObject:
		#create a safe fallback object to return.
		var createdObj:CBaseWandObject = null

		#Create the desired object based on passed in typename.
		match typeName:
			CWandTypes.IMachines.m_conveyor:
				createdObj = CMachineResourceConveyor.new()
			CWandTypes.IMachines.m_drill:
				createdObj = CMachineResourceDrill.new()
			_:
				print("CWandObjectFactory::CreateWandObject - ERROR attempted to create base or undefined type: ", typeName, "\n")
		
		#If we created a valid object, then give it a unique id and add it to our object list.
		if createdObj != null:
			m_nextObjId = m_nextObjId + 1
			createdObj._Init(m_nextObjId)
			m_objects[createdObj.m_id] = createdObj

		#return the created object, it will be null if it failed to create.
		return createdObj
