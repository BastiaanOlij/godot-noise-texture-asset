extends Viewport

export var texture_size = Vector3(128.0, 128.0, 1.0) setget set_texture_size, get_texture_size
export var max_distance = 0.5 setget set_max_distance, get_max_distance
export var number_of_points = 15 setget set_number_of_points, get_number_of_points

var color_rect = null
var material = null

# note, Godot doesn't currently have support for 3D textures, so we pack the Z into our Y
# slower because we need to do a double lookup but it'll do fine
# If you don't want a 3D texture, just keep Z to 1.0
func set_texture_size(new_size):
	if new_size.x < 1.0 or new_size.y < 1 or new_size.z < 1:
		return
	
	# remember
	texture_size = new_size
	
	# resize viewport
	size = Vector2(texture_size.x, texture_size.y * texture_size.z);
	
	# resize our texture
	if color_rect:
		color_rect.rect_size = Vector2(texture_size.x, texture_size.y * texture_size.z);
	
	# let our shader know...
	if material:
		material.set_shader_param("max_z", texture_size.z)
	
	# and re-render our viewport
	self.render_target_update_mode = Viewport.UPDATE_ONCE

func get_texture_size():
	return texture_size

func set_max_distance(p_distance):
	if p_distance < 0.01 or p_distance > 2.0:
		return
	
	max_distance = p_distance
	if material:
		material.set_shader_param("max_distance", max_distance)
	
	# and re-render our viewport
	self.render_target_update_mode = Viewport.UPDATE_ONCE

func get_max_distance():
	return max_distance

func set_number_of_points(p_nop):
	if p_nop > 0:
		number_of_points = p_nop
		
		if material:
			make_random_points()
	
	# and re-render our viewport
	self.render_target_update_mode = Viewport.UPDATE_ONCE

func get_number_of_points():
	return number_of_points

func _random():
	var point = Vector3(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
	return point

func make_random_points():
	# should make a seed optional
	if material:
		# we create a texture for our points
		var points = PoolByteArray()
		points.resize(number_of_points * 3)
		var i = 0
		
		for p in range(0, number_of_points):
			# random points are betten (0.0, 0.0, 0.0) to (1.0, 1.0, 1.0) so map to 0 - 255
			var point = _random()
			points[i] = floor(point.x * 255.0)
			i += 1
			points[i] = floor(point.y * 255.0)
			i += 1
			points[i] = floor(point.z * 255.0)
			i += 1
		
		var image = Image.new()
		image.create_from_data(number_of_points, 1, false, Image.FORMAT_RGB8, points)
		
		var texture = ImageTexture.new()
		texture.create_from_image(image, 0)
		
		material.set_shader_param("worley_points", texture)
		material.set_shader_param("number_of_points", number_of_points)
		

func _ready():
	color_rect = get_node("WorleyTexture")
	material = color_rect.material
	
	# rerun these now that we're ready for em...
	set_texture_size(texture_size)
	set_max_distance(max_distance)
	set_number_of_points(number_of_points)
