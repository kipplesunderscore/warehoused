extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_MasterVolumeSlider_value_changed(value):
	print (value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_EffectsVolumeSlider_value_changed(value):
	print (value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)

func _on_MusicVolumeSlider_value_changed(value):
	print (value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
