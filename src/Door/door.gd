extends Sprite

export(String, FILE, "*.tscn") var scene_path = "res://src/Stages/"

func _ready():
    pass # Replace with function body.


func _on_Area2D_area_entered(area):
    get_tree().change_scene(scene_path)
