class_name CWandGrid

static var m_instance = null
var m_map:Dictionary #Vector2 grid coord to wandObjectId
var m_gridSize:Vector2 #how many tiles are in this map
var m_tileSize:Vector2 #length of the wand tiles in pixels.

static func GetInstance()->CWandGrid:
	if m_instance == null:
		m_instance = CWandGrid.new()
	return m_instance

func Initialize(tileSize:Vector2, gridSize:Vector2)->bool:
	m_map.clear()
	m_tileSize = tileSize
	m_gridSize = gridSize
	return true

func IsWithinBounds(coords:Vector2) -> bool:
	return coords.x >= 0 and coords.x < m_gridSize.x and coords.y >= 0 and coords.y < m_gridSize.y

func AttachObjectToGrid(obj:CBaseGridObject, coord:Vector2)->bool:
	if obj == null:
		print("CWandGrid::AttachObjectToGrid - null object")
		return false
	
	var occupiedCoords:= obj.GetOccupiedCoords(coord)
	#Verify that every tile this factory object wishes to use is unoccupied.
	for gridLoc in occupiedCoords:
		if !IsWithinBounds(gridLoc):
			print("CWandGrid::AttachObjectToGrid - grid % out of map bounds %, on attempt to place % at %\n"
				%[gridLoc,m_gridSize,obj.GetType(),coord])
			return false
		if m_map.has(gridLoc):
			print("CWandGrid::AttachObjectToGrid - grid % is occupied, on attempt to place % at %\n"
				%[gridLoc, obj.getType(),coord])
			return false
	
	#Insert the object link at all of it's occupied map coords.
	for gridLoc in occupiedCoords:
		m_map[gridLoc] = obj.m_id
	
	obj.OnAddedToGrid()
	return true

func GetObjectAtCoord(gridCoord:Vector2) -> int:
	if m_map.has(gridCoord):
		return m_map[gridCoord]
	else:
		return 0
