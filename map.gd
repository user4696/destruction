extends Node

func _ready():
	# Get the window size for setting up split screen dimensions
	var window_size = DisplayServer.window_get_size()
	
	# Get player cameras
	var player1_camera = $Player1/Camera3D
	var player2_camera = $Player2/Camera3D

	if player1_camera == null:
		print("Player 1 camera not found.")
	if player2_camera == null:
		print("Player 2 camera not found.")

	# Get references to SubViewports
	var subviewport1 = $SubViewportContainer/SubViewport1
	var subviewport2 = $SubViewportContainer/SubViewport2

	if subviewport1 == null or subviewport2 == null:
		print("One or both SubViewports not found.")
		return
	
	# Activate each camera in its SubViewport
	player1_camera.current = true
	subviewport1.size = Vector2(window_size.x / 2, window_size.y)
	
	player2_camera.current = true
	subviewport2.size = Vector2(window_size.x / 2, window_size.y)

	# Adjust TextureRects to display each SubViewport side-by-side
	var texture1 = $SubViewportContainer/TextureRect1
	var texture2 = $SubViewportContainer/TextureRect2

	if texture1 == null or texture2 == null:
		print("One or both TextureRects not found.")
		return

	# Set each TextureRect to occupy half of the screen horizontally
	texture1.rect_size = Vector2(window_size.x / 2, window_size.y)
	texture2.rect_size = Vector2(window_size.x / 2, window_size.y)

	# Position TextureRects side-by-side
	texture1.rect_position = Vector2(0, 0)
	texture2.rect_position = Vector2(window_size.x / 2, 0)

	print("Split-screen setup complete.")
