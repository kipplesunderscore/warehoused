extends Control

var is_paused = false setget set_is_paused

func _ready():
	visible = false

func _unhandled_input(event):
		if event.is_action_pressed("ui_cancel"):
			self.is_paused = !is_paused
			visible = is_paused
			$SettingsMenu.visible = false

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeButton_pressed():
	self.is_paused = false

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_SettingsButton_pressed():
	$SettingsMenu.visible = true
