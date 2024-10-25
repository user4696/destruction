extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	$Camera1.position.y = $cartcar.position.y + 2
	$Camera1.position.x = $cartcar.position.x + 3
	$Camera1.position.z = $cartcar.position.z + 3
	$Camera1.rotation.x = $cartcar.rotation.x
	$Camera1.rotation.z = $cartcar.rotation.z
