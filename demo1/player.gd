extends CharacterBody3D
class_name Player

signal hit

@export var speed := 14.0
@export var fall_acceleration := 75.0
@export var jump_impulse := 20.0
@export var bounce_impulse := 16.0

var target_velocity := Vector3.ZERO

func _physics_process(delta):
	_handler_movement(delta)
	
func _handler_movement(delta):
	var direction := Vector3.ZERO
	
	# Update the direction
	if Input.is_action_pressed('right'):
		direction.x += 1
	
	if Input.is_action_pressed("left"):
		direction.x -= 1
		
	if Input.is_action_pressed("backward"):
		direction.z += 1
		
	if Input.is_action_pressed("forward"):
		direction.z -= 1
	
	# rotate to the direction
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# If the collision is with ground
		if collision.get_collider() == null:
			continue
		
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			# we check that we are hitting it from above.
			# If so, we squash it and bounce.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
	
	# Moving the character
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
