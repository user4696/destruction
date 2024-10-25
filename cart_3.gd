extends RigidBody3D

# Car Physics Variables
var max_speed : float = 40.0  # Maximum forward speed
var acceleration : float = 20.0  # How quickly the car accelerates
var deceleration : float = 30.0  # How quickly the car slows down
var brake_force : float = 50.0  # Force applied when braking
var turn_speed : float = 2.0  # How quickly the car turns
var drift_slip : float = 0.3  # Sideways slip amount for drifting
var drift_factor : float = 0.5  # Amount of drift to apply while turning
var gravity : float = -20.0  # Gravity effect
var drift_boost : float = 1.5  # Boost to speed when drifting correctly
var max_yaw_angle : float = 30.0  # Max yaw (rotation) when pressing turn keys
var max_roll_angle : float = 15.0  # Max roll (tilt) when drifting
var tilt_accumulation_rate : float = 45.0  # Speed at which the tilt angle accumulates
var reset_speed : float = 5.0  # Speed at which the angles reset

# Boost Variables
var is_boosting : bool = false  # Track if the player is boosting
var normal_max_speed : float = 40.0  # The regular max speed
var boost_max_speed : float = 60.0  # Speed when boosting
var boost_acceleration : float = 30.0  # Faster acceleration during boost

# State Variables
var drifting : bool = false
var drift_velocity : Vector3 = Vector3.ZERO
var current_yaw : float = 0.0  # Track the current yaw angle for turning effect
var current_roll : float = 0.0  # Track the current roll angle for drifting effect

func _integrate_forces(state):
	var input_vector = Vector3.ZERO

	# Capture forward/backward input
	if Input.is_action_pressed("up"):
		input_vector.z -= 1
	if Input.is_action_pressed("down"):
		input_vector.z += 1

	# Check for boost input (e.g., Shift key)
	if Input.is_action_pressed("boost"):
		is_boosting = true
	else:
		is_boosting = false

	# Set max speed and acceleration based on whether boosting
	var current_max_speed = boost_max_speed if is_boosting else normal_max_speed
	var current_acceleration = boost_acceleration if is_boosting else acceleration

	# Smooth acceleration and braking
	var target_velocity_z = input_vector.z * current_max_speed
	var current_velocity = state.get_linear_velocity()
	
	# Apply forward/backward forces
	if input_vector.z != 0:
		var force = (target_velocity_z - current_velocity.z) * current_acceleration
		apply_central_force(transform.basis.z * force)
	else:
		# Apply deceleration when no input
		if current_velocity.length() > 0.1:
			var brake = -current_velocity.z * deceleration
			apply_central_force(transform.basis.z * brake)

	# Apply brake force if holding down while moving forward
	if Input.is_action_pressed("down") and current_velocity.z < 0.0:
		var brake_force_value = -current_velocity.z * brake_force
		apply_central_force(transform.basis.z * brake_force_value)

	# Enhanced turning and dynamic yaw/roll effect
	var turn_amount = 0.0
	if Input.is_action_pressed("left"):
		turn_amount -= turn_speed
		current_yaw = clamp(current_yaw + tilt_accumulation_rate * state.get_step(), -max_yaw_angle, max_yaw_angle)
		current_roll = lerp(current_roll, max_roll_angle, 0.1)  # Lean left
	elif Input.is_action_pressed("right"):
		turn_amount += turn_speed
		current_yaw = clamp(current_yaw - tilt_accumulation_rate * state.get_step(), -max_yaw_angle, max_yaw_angle)
		current_roll = lerp(current_roll, -max_roll_angle, 0.1)  # Lean right
	else:
		# Reset yaw and roll angles when not turning
		current_yaw = lerp(current_yaw, 0.0, reset_speed * state.get_step())
		current_roll = lerp(current_roll, 0.0, reset_speed * state.get_step())

	# Apply yaw and roll effect for better drifting visuals
	rotation.y = deg_to_rad(current_yaw)  # Yaw rotation
	rotation.z = deg_to_rad(current_roll)  # Roll tilt

	# Apply rotation based on speed and turn amount
	if current_velocity.z != 0.0:
		var angular_velocity = state.get_angular_velocity()
		angular_velocity.y = turn_amount * sign(current_velocity.z)
		set_angular_velocity(angular_velocity)

	# Drifting effect: add sideways force based on turning
	if abs(turn_amount) > 0.0 and abs(current_velocity.z) > current_max_speed * 0.3:
		drifting = true
		drift_velocity = transform.basis.x * current_velocity.z * drift_slip * state.get_step()
		apply_central_force(drift_velocity)
	else:
		drifting = false
		drift_velocity = drift_velocity.move_toward(Vector3.ZERO, drift_factor * state.get_step())

	# Gravity application (handled naturally by RigidBody3D physics)

	# Debugging: Print out the drift state
	if drifting:
		print("Drifting!")
