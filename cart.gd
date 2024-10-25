extends CharacterBody3D

# Car Physics Variables
var max_speed : float = 57.0  # Maximum forward speed
var acceleration : float = 20.0  # How quickly the car accelerates
var deceleration : float = 30.0  # How quickly the car slows down
var brake_force : float = 50.0  # Force applied when braking
var turn_speed : float = 2.0  # How quickly the car turns
var drift_slip : float = 9.3  # Sideways slip amount for drifting
var drift_factor : float = 8.5  # Amount of drift to apply while turning
var gravity : float = -20.0  # Gravity effect
var drift_boost : float = 8.5  # Boost to speed when drifting correctly
var max_tilt_angle : float = 5.3  # Max tilt angle in degrees

# Boost Variables
var is_boosting : bool = false  # Track if the player is boosting
var normal_max_speed : float = 40.0  # The regular max speed
var boost_max_speed : float = 60.0  # Speed when boosting
var boost_acceleration : float = 70.0  # Faster acceleration during boost

# State Variables
var drifting : bool = false
var drift_velocity : Vector3 = Vector3.ZERO

func _physics_process(delta):
	var input_vector = Vector3.ZERO
	# Capture forward/backward input
	if Input.is_action_pressed("down"):
		input_vector.z -= 1
	if Input.is_action_pressed("up"):
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
	if input_vector.z != 0:
		self.velocity.z = lerp(self.velocity.z, input_vector.z * current_max_speed, current_acceleration * delta)
	else:
		# Slow down gradually if no input
		self.velocity.z = lerp(self.velocity.z, 0.0, deceleration * delta)
	
	# Apply brake force if holding down while moving forward
	if Input.is_action_pressed("up") and self.velocity.z < 0.0:
		self.velocity.z = lerp(self.velocity.z, 0.0, brake_force * delta)
	
	# Turn car with smooth tilt for drifting effect
	var turn_amount = 0.0
	if Input.is_action_pressed("right"):
		turn_amount -= turn_speed
		rotation.z = lerp(rotation.z, deg_to_rad(max_tilt_angle), 0.1)  # Lean left
	elif Input.is_action_pressed("left"):
		turn_amount += turn_speed
		rotation.z = lerp(rotation.z, deg_to_rad(-max_tilt_angle), 0.1)  # Lean right
	else:
		rotation.z = lerp(rotation.z, 0.0, 0.1)  # Reset tilt to 0.0
	
	if self.velocity.z != 0.0:
		# Apply rotation based on speed and turn amount
		rotate_y(turn_amount * delta * sign(self.velocity.z))
	
	# Drifting effect: add sideways movement based on turning
	if abs(turn_amount) > 0.0 and abs(self.velocity.z) > current_max_speed * 0.3:
		drifting = true
		drift_velocity = transform.basis.x * self.velocity.z * drift_slip * delta
	else:
		drifting = false
		drift_velocity = drift_velocity.move_toward(Vector3.ZERO, drift_factor * delta)
	
	# Apply gravity
	if not is_on_floor():
		self.velocity.y += gravity * delta
	
	# Combine forward and drift velocities, set to `self.velocity`, and move
	var final_velocity = transform.basis.z * self.velocity.z + drift_velocity
	self.velocity = final_velocity
	move_and_slide()
	
	# Debugging: Print out the drift state
	#if drifting:
		#print("Drifting!")
		
	if not is_on_floor():
		print("hey")
