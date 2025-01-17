extends Node


#This defines properties that all chunks share such as their dimensions
class ChunkDetails:
	var m_dimensions : Vector2

#This manages which chunks are loaded.
class ChunkLoader:
	var m_chunks : Dictionary
	var m_lastTrackerPosition: Vector2
	
	func Initialize(details:ChunkDetails,initialCoords:Vector2, intialPosition:Vector2)->bool:
		return false
