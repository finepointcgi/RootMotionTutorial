extends Node3D

@export var sensitivity : int = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_tree().get_nodes_in_group("Character")[0].global_position
	pass


func _input(event):
	if event is InputEventMouseMotion:
		rotation = Vector3(clamp(rotation.x - event.relative.y / 1000 * sensitivity,-1, .25), rotation.y - event.relative.x / 1000 * sensitivity, 0)
