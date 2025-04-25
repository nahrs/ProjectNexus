extends CBaseWandObject
class_name CBaseGridObject

var m_rootCoord: Vector2 #Coordinates occupied by this building.
var m_gridCoords: Array[Vector2]
var m_components: Dictionary #components by their local machine name. Such as InputRight, InputLeft, MainStore ect.

func GetComponent(typeName:StringName) -> CMachineComponentBase:
	if !m_components.has(typeName):
		return null
	return m_components[typeName]

func AddComponent(component:CMachineComponentBase) -> bool:
	if component == null:
		print("CBaseGridObject::AddComponent Attempted to add null componenent %, id: %" %[GetType(), m_id])
		return false
	if m_components.has(component.GetType()):
		print("CBaseGridObject::AddComponent Attempted to add duplicate component %, to % with id: %" %[component.GetType(),GetType(), m_id])
		return false
	m_components[component.GetType()] = component
	component.OnAddedToGrid(self)
	return true

func RemoveComponent(typeName:StringName):
	if !m_components.has(typeName):
		return
	m_components.erase(typeName)

func ClearComponents():
	m_components.clear()

func Init():
	pass

#Overloaded
func IsPlaceable() ->bool:
	return true

#Overloaded
func GetType()->StringName:
	return "CBasePlaceableObject"

#Overload this.
func GetOccupiedCoords(location:Vector2) -> Array[Vector2]:
	var occupied:Array[Vector2]
	occupied.append(location)
	return occupied

func AttachToGrid(location:Vector2):
	m_rootCoord = location
	m_gridCoords = GetOccupiedCoords(location)
	OnAddedToGrid()

#Overload this.
func OnAddedToGrid():
	pass


	
