extends Control

func _ready() -> void:
	if ConfigManager.load_fullscreen_setting():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	ConfigManager.load_audio_volumes()
	MusicManager.playMainMenuMusic()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Prototype/FF6Prototype.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Graphics/Menu/Options.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Graphics/Menu/Credits.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
