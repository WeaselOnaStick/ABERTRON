extends CharacterBody3D

@export var SPEED := 5.0
@export var mouse_sensitivity := 0.002
@export_range(0, 90, 0.001, "radians_as_degrees") var max_pitch := deg_to_rad(80)

@onready var cam = $Camera3D
@onready var interaction_ray : RayCast3D = %InteractionRay
@onready var holding_position: Marker3D = %HoldingPosition
var cur_held_obj : Node3D = null

# Locked out during tutorial and other gameplay moments
var can_interact = true

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
	
	if interaction_ray.is_colliding() and interaction_ray.get_collider().get_parent().is_in_group("Interactable"):
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
		
		if   cam.rotation.x < max_pitch and event.relative.y < 0:
			cam.rotate_x(-event.relative.y * mouse_sensitivity)
		elif cam.rotation.x > -max_pitch and event.relative.y > 0:
			cam.rotate_x(-event.relative.y * mouse_sensitivity)
		
		
		interaction_ray.rotation = cam.rotation
	
	if event.is_action_pressed("interact"):
		interact()

func interact():
	if cur_held_obj != null:
		drop_obj(cur_held_obj)
		return
	
	DebugUI.DebugLog(interaction_ray.get_collider())
	if not can_interact:
		return
	if not interaction_ray.is_colliding():
		return
	var collider : Node3D = interaction_ray.get_collider()
	var col_obj = collider.get_parent_node_3d()
	if col_obj.is_in_group("Interactable"):
		col_obj.interact()
	
	if col_obj.is_in_group("CanBePickedUp") and cur_held_obj == null:
		pick_up_obj(col_obj)
	elif col_obj.is_in_group("CanBePickedUp") and cur_held_obj == null:
		drop_obj(col_obj)
	

func pick_up_obj(obj : Node3D):
	obj.reparent(holding_position)
	(obj as RigidBody3D).freeze = true
	obj.position = Vector3.ZERO
	cur_held_obj = obj
	
	var tw := create_tween().tween_method(_smooth_transf_reset, 0.0, 1.0, 0.3)
	
func _smooth_transf_reset(x : float):
	if cur_held_obj == null:
		return
	cur_held_obj.transform = cur_held_obj.transform.interpolate_with(Transform3D.IDENTITY, x)
		
	
	
func drop_obj(obj : Node3D):
	obj.reparent(get_parent_node_3d())
	(obj as RigidBody3D).freeze = false
	cur_held_obj = null
