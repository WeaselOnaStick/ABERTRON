extends Node3D

@onready var dialogue_renderer: = $SubViewport/DialogueRenderer

func interact():
	dialogue_renderer.interact()
