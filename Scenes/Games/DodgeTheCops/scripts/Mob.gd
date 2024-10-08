extends RigidBody2D

var isUpdated = false;
var dead = false;
var killed = false

signal mobDead

func SetDead():
	dead = true
	killed = true

func PlayerDead(playerLoc):
	if($AnimatedSprite2D.get_animation() != "fuzz"):
		$AnimatedSprite2D.play("jump")
		rotation = 0.0
	else:
		$AnimatedSprite2D.speed_scale = randf_range(2.0,3.0)
	
	var dir : Vector2 = playerLoc - position
	dir = dir.normalized()
	dir = dir * 100
	linear_velocity = dir


# Called when the node enters the scene tree for the first time.
func _ready():
	
	contact_monitor = true
	
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	#var frames = $AnimatedSprite2D.get_sprite_frames()
	#var frames2 = $AnimatedSprite2D.sprite_frames
	
	#var frameCount = frames.get_frame_count("fuzz")
	
	#if !isUpdated:
	#	isUpdated = true
	#	for frame in frameCount:
	#		var animTex : Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture("fuzz", frame)
	#		if animTex != null:
	#			var animImage: Image = animTex.get_image()
	#			var fixedImage: Image = FixImageAlpha(animImage)
	#			#animImage.set_data(animImage.get_width(), animImage.get_height(), false, Image.FORMAT_BPTC_RGBA, fixedImage.get_data())
	#			#animTex.set("Image",fixedImage)
	#			#frames.get_frame_texture("fuzz", frame).set("Image",fixedImage)
	#			
	#			var newTexture = ImageTexture.new()
	#			var huh = ImageTexture.create_from_image(fixedImage) 
	#			
	#		
	#		animTex.set("Image", fixedImage)
	#		
	#		$AnimatedSprite2D.sprite_frames.set_frame("fuzz",frame,huh,0.3)
				#print("First Color: ", fixedImage.get_pixel(0,0))
			
		#var poop: Texture2D = $AnimatedSprite2D.sprite_frames.get_frame_texture("fuzz", frameIndex)
		#var img = poop.get_image()
		
		#print("UpdatedColor: ", img.get_pixel(0,0) )
		
	
	$AnimatedSprite2D.speed_scale = randf_range(1.0,2.0)
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(dead):
		if(killed):
			mobDead.emit()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	dead = true

func FixImageAlpha(fixImage):
	var badColor: Color = Color(0.902, 0.902, 0.902, 1.0)
	var AlphaBoi: Color = Color(0.0, 0.0, 0.0, 0.0)
	
	#var updatedImage = Image.new()
	#updatedImage.copy_from(fixImage)
	#updatedImage.convert(Image.FORMAT_BPTC_RGBA)
	
	#Image create(width: int, height: int, use_mipmaps: bool, format: Format) static
	var updatedImage = Image.create(fixImage.get_width(), fixImage.get_height(), false, Image.FORMAT_RGBAF )
	#updatedImage.set("AlphaMode",Image.ALPHA_BLEND)
	#updatedImage. FORMAT_ETC2_RGBA8
	
	var pixColor: Color = AlphaBoi
	
	for h in fixImage.get_height():
		for w in fixImage.get_width():
			pixColor =  fixImage.get_pixel(w,h)
			#print( "color: ", pixColor, "\n")
			#print( "badColor: ", badColor, "\n")
			if pixColor.to_abgr32() == badColor.to_abgr32():
				#print("replaced (", w, ",", h, ")\n")
				updatedImage.set_pixel(w,h,AlphaBoi)
			else:
				updatedImage.set_pixel(w,h,pixColor)
	
	var _alpha : Image.AlphaMode = updatedImage.detect_alpha()
	
	#print( "Alpha state of updated image: ", alpha)
	
	return updatedImage
