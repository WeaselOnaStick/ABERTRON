extends CharacterBody3D

@export var SPEED := 5.0
@export var mouse_sensitivity := 0.002
@onready var cam = $Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("strafe_left","strafe_right","backward","forward")
	input_dir.y *= -1
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		event = event as InputEventMouseMotion
		
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
