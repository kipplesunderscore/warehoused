extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	print("ready")
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$VisualSettings/VSyncCheck.pressed = OS.vsync_enabled
	$VisualSettings/FullScreenCheck.pressed = OS.window_fullscreen
	$VBoxContainer/MasterVolumeContainer/MasterVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$VBoxContainer/EffectsVolumeContainer/EffectsVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects"))
	$VBoxContainer/MusicVolumeContainer/MusicVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	pass # Replace with function body.

func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	print (AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func _on_EffectsVolumeSlider_value_changed(value):
	print (value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)

func _on_MusicVolumeSlider_value_changed(value):
	print (value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_FullScreenCheck_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen

func _on_VSyncCheck_toggled(button_pressed):
	OS.vsync_enabled = $VisualSettings/VSyncCheck.pressed
	print (OS.vsync_enabled)

func _on_BackButton_pressed():
	visible = false

func _on_EffectsVolumeSlider_drag_started():
	$SoundEffectsPlayer.play()

func _on_EffectsVolumeSlider_drag_ended(value_changed):
	$SoundEffectsPlayer.stop()


func _on_MusicVolumeSlider_drag_started():
	$MusicPlayer.play()


func _on_MusicVolumeSlider_drag_ended(value_changed):
	$MusicPlayer.stop()
