extends Node


#This defines properties that all chunks share such as their dimensions
class ChunkDetails:
	var m_tileDimensions : Vector2

#info about our tracked object which is loading/unloading chunks. (E.G. Player)
class TrackerDetails:
	var m_lastPosition: Vector2	#chunk relative position of our tracked object.
	var m_lastChunkCoords : Vector2	#last chunk our tracked object entered
	var m_chunkRadius : int 			#amount of chunks to keep loaded around this tracker.

class ChunkData:
	var m_loaded: bool


#This manages which chunks are loaded.
class ChunkLoader:
	var m_loadedChunks : Dictionary
	var m_chunkDetails : ChunkDetails
	var m_trackerDetails : TrackerDetails
	
	func Initialize(details:ChunkDetails, trackerDetails:TrackerDetails)->bool:
		m_chunkDetails = details
		m_trackerDetails = trackerDetails
		LoadChunkRadius(m_trackerDetails.m_lastChunkCoords, m_trackerDetails.m_chunkRadius)
		return false
	
	func UpdateTrackerPosition(position:Vector2)->void:
		
		
		pass
	
	#Loads target chunk and all neighbhoring chunks within a specified radius around it.
	func LoadChunkRadius(coords:Vector2, radius:int)->void:
		LoadChunk(coords)
		
		
		
		pass
	
	#Loads specific chunk, does nothing if already loaded.
	func LoadChunk(coords:Vector2)->void:
		pass
	
	#Unloads specific chunk
	func UnloadChunk(coords:Vector2)->void:
		pass
	
	func OnChunkLoaded(coords:Vector2)->void:
		pass
	
