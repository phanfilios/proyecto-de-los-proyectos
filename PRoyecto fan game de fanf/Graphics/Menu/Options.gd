extends Control

@onready var music_slider: HSlider = $Center/Panel/Margin/VBox/MusicSlider
@onready var game_slider: HSlider = $Center/Panel/Margin/VBox/GameSlider
@onready var fullscreen_checkbox: CheckBox = $Center/Panel/Margin/VBox/FullscreenCheck

func _ready() -> void:
	ConfigManager.load_audio_volumes()
	music_slider.value = ConfigManager.musicVolume
	game_slider.value = ConfigManager.gameVolume
	fullscreen_checkbox.button_pressed = ConfigManager.load_fullscreen_setting()

func _on_music_slider_value_changed(value: float) -> void:
	ConfigManager.musicVolume = value
	AudioServer.set_bus_volume_db(1, value)
	AudioServer.set_bus_mute(1, value <= -30)
	ConfigManager.save_audio_volumes()

func _on_game_slider_value_changed(value: float) -> void:
	ConfigManager.gameVolume = value
	AudioServer.set_bus_volume_db(2, value)
	AudioServer.set_bus_mute(2, value <= -30)
	ConfigManager.save_audio_volumes()

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)
	ConfigManager.save_fullscreen_setting(toggled_on)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Graphics/Menu/MainMenu.tscn")
