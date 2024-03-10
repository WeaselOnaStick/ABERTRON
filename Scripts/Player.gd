extends CharacterBody3D

@export var SPEED := 5.0
@export var mouse_sensitivity := 0.002
@onready var cam = $Camera3D
@onready var interaction_ray : RayCast3D = %InteractionRay
@onready var holding_position: Marker3D = %HoldingPosition


var can_interact = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.can_player_interact_override.connect(func(x): can_interact = x)

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
	
	if interaction_ray.is_colliding() and interaction_ray.get_collider().is_in_group("Interactable"):
		FPS_HUD.toggle_crosshair_highlight(true)
	else:
		FPS_HUD.toggle_crosshair_highlight(false)

func _input(event):
	# toggle mouse mode
	if event.is_action_pressed("mouse_toggle"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	# mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		event = event as InputEventMouseMotion
		
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		interaction_ray.rotation = cam.rotation
	
	if event.is_action_pressed("interact"):
		interact()

func interact():
	DebugUI.DebugLog(interaction_ray.get_collider())
	if not can_interact:
		return
	if not interaction_ray.is_colliding():
		return
	var collider = interaction_ray.get_collider()
	if collider.get_parent().has_method("interact"):
		collider.get_parent().interact()
