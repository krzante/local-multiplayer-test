extends KinematicBody2D

export var speed := 300

var velocity = Vector2.ZERO

puppet var puppet_position = Vector2.ZERO setget puppet_position_set
puppet var puppet_velocity = Vector2.ZERO
puppet var puppet_rotation = 0

onready var tween = $Tween


func _process(delta: float) -> void:
	if is_network_master():
		var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		var y_input = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
		
		velocity = Vector2(x_input, y_input).normalized()
		print(velocity)
		
		move_and_slide(velocity * speed)
		
		look_at(get_global_mouse_position())
		
	else:
		rotation_degrees = lerp(rotation_degrees, puppet_rotation, delta * 8)
		
		if not tween.is_active():
			move_and_slide(puppet_velocity * speed)


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func _on_NetworkTickRate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", rotation_degrees)
