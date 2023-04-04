extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
	if not is_on_floor():
		velocity.y -= gravity * delta
	var h_rot = get_tree().get_nodes_in_group("CameraController")[0].global_transform.basis.get_euler().y
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3(Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"), 0, Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
	$AnimationTree.set("parameters/conditions/moving", direction != Vector3.ZERO)
	$AnimationTree.set("parameters/conditions/idle", direction == Vector3.ZERO)
	print(direction)
	$AnimationTree.set("parameters/BlendSpace2D/blend_position", Vector2(0, -1))
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$AnimationTree.set("parameters/BlendSpace2D/blend_position", Vector2(-direction.x, -direction.z))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		look_at(Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z))
	elif direction != Vector3.ZERO:
		rotation = Vector3(rotation.x, atan2(-direction.x, -direction.z), rotation.z)
	
	var currentRotation = transform.basis.get_rotation_quaternion()
	velocity = (currentRotation.normalized() * $AnimationTree.get_root_motion_position()) / delta
	
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
