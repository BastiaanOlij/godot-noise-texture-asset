extends Control

export (NodePath) var worley = null
var worley_node = null

func _ready():
	if worley:
		worley_node = get_node(worley)
	
	if worley_node:
		$Worley_MaxDistance.value = worley_node.max_distance
		$Worley_NumberOfPoints.value = worley_node.number_of_points

func _on_Worley_MaxDistance_value_changed(value):
	if worley_node:
		worley_node.max_distance = $Worley_MaxDistance.value

func _on_Worley_NumberOfPoints_value_changed(value):
	if worley_node:
		worley_node.number_of_points = $Worley_NumberOfPoints.value
