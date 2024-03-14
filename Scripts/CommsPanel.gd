class_name CommsPanel extends Node3D

@onready var dialogue_renderer: DialogueRenderer = $CSGBox3D/Sprite3D/SubViewport/DialogueRenderer
var dialogue_sprite: Sprite3D

signal interacted_manual
signal interacted_via_signal

func interact():
	dialogue_renderer.interact_manual()
	
func interact_signal():
	dialogue_renderer.interact_signal()

func _ready():
	lights_toggle(false)
	dialogue_sprite = get_node("CSGBox3D/Sprite3D")
	DebugUI.DebugLog(dialogue_sprite.get_child(0).get_path())
	print(dialogue_sprite.get_child(0).get_path())
	(dialogue_sprite.texture as ViewportTexture).viewport_path = dialogue_sprite.get_child(0).get_path()

func lights_toggle(state : bool):
	$PanelLight.visible = state

func _process(delta: float) -> void:
	if dialogue_renderer.state == dialogue_renderer.states.WAITING_MANUAL:
		add_to_group("Interactable")
	else:
		remove_from_group("Interactable")
