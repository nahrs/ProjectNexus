class_name GodotHelpers

static func AsAudioSteamPlayer(childNode:Node) -> AudioStreamPlayer:
	return childNode

static func GetAnim(nodeLink:Node, animName:String ) -> AnimatedSprite2D:
	return nodeLink.get_node(animName)

static func CheckPlayAnim(nodeLink:Node, animNode:String, anim:String, ) -> void:
	var node:AnimatedSprite2D = nodeLink.getAnim(animNode)
	if(node != null):
		if(node.animation != anim):
			node.play(anim)	
