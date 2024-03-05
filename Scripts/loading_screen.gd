class_name LoadingScreen extends Control

signal finished_loading

func _ready():
	$BG/LoadingPanel/NoiseLoading.value = 0

func update_progress(val : float):
	$BG/LoadingPanel/NoiseLoading.value = val

func _process(_delta):
	if GameManager.CURRENTLY_LOADING_SCENE == "":
		return
	
	var progress = []
	var status := ResourceLoader.load_threaded_get_status(GameManager.CURRENTLY_LOADING_SCENE, progress) 
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		update_progress(progress[0])
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		create_tween().tween_property(self, "modulate", Color("ffffff00"), 0.2).finished.connect(queue_free)
		finished_loading.emit()
