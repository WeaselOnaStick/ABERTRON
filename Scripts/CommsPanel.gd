extends Node3D

@onready var dialogue_renderer: = $CSGBox3D/Sprite3D/SubViewport/DialogueRenderer

func interact():
	dialogue_renderer.interact()
