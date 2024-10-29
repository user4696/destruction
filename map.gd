extends Node3D

@onready var player1_car = $Player1  # Path to Player 1’s car
@onready var player2_car = $Player2  # Path to Player 2’s car
@onready var player1_camera = $SubViewportContainer/SubViewport1/Camera3D
@onready var player2_camera = $SubViewportContainer/SubViewport2/Camera3D
@onready var subviewport1 = $SubViewportContainer/SubViewport1
@onready var subviewport2 = $SubViewportContainer/SubViewport2
@onready var texture1 = $SubViewportContainer/TextureRect1
@onready var texture2 = $SubViewportContainer/TextureRect2

func _ready():
	# Get the window size
	var window_size = DisplayServer.window_get_size()

	# Set each SubViewport to half the screen width and full screen height
	subviewport1.size = Vector2(window_size.x / 2, window_size.y)
	subviewport2.size = Vector2(window_size.x / 2, window_size.y)

	# Make each camera current to render in the SubViewports
	if player1_camera:
		player1_camera.current = true
	if player2_camera:
		player2_camera.current = true


func _process(delta):
	# Update camera positions to follow each car
	player1_camera.transform.origin = player1_car.global_transform.origin + Vector3(0, 5, -10)
	player1_camera.look_at(player1_car.global_transform.origin, Vector3.UP)

	player2_camera.transform.origin = player2_car.global_transform.origin + Vector3(0, 5, -10)
	player2_camera.look_at(player2_car.global_transform.origin, Vector3.UP)
	# Adjust each TextureRect to display each SubViewport side-by-side
	# Scale each TextureRect to half the width of the window


	print("SubViewport and TextureRect setup completed.")
