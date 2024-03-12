class_name level1 extends Node3D

const LVL1_DIALOGUE : JSON = preload("res://Assets/Dialogue/lvl1_intoduction.json")
@onready var comms: CommsPanel = $abertron_lab/COMMS

const TEST_SUBJECT = preload("res://Scenes/test_subject.tscn")

func _ready() -> void:
	set_lights_power(false)
	GameManager.call_deferred("level1_start")
	MusicManager.play("Global","Ambiertron")
	#MusicManager.updated.connect(func (): MusicManager.play("Global","Ambiertron"), CONNECT_ONE_SHOT)
	comms.dialogue_renderer.init(LVL1_DIALOGUE)
	comms.dialogue_renderer.dialogue_signal.connect(func (x):
		if x == 0:
			set_lights_power(true)
			MusicManager.enable_stem("synth")
		elif x == 1:
			var subj := TEST_SUBJECT.instantiate()
			subj.transform = %SubjectSpawnPoint.transform
			add_child(subj)
		)

func set_lights_power(x : bool):
	($abertron_lab/AbertronLab/LabMesh.get_active_material(4) as StandardMaterial3D).emission_enabled = x
	if x:
		SoundManager.play("Environment","lights_on")
	
	$abertron_lab/Lights.visible = x

func comms_signal():
	comms.interact_signal()
