extends Spatial

func _ready():
	$HeightMapExample.mesh.subdivide_width = 255
	$HeightMapExample.mesh.subdivide_depth = 255