extends Node2D
class_name Dispenser

export var type : String

var grape =	preload("res://src/Box/Grape.tscn")
var apple = preload("res://src/Box/Apple.tscn")
var melon = preload("res://src/Box/Melon.tscn")
var bolt = preload("res://src/Box/Bolt.tscn")
var fabric = preload("res://src/Box/Fabric.tscn")

var active : bool = false

var crafting_grid

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_box_scene():
    match type:
        "grape": return grape
        "apple": return apple
        "melon": return melon
        "bolt": return bolt
        "fabric": return fabric

# Called when the node enters the scene tree for the first time.
func _ready():
    crafting_grid = get_parent().get_node("CraftingGrid")
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if active and Input.is_action_just_pressed("pickup"):
        var scene = get_box_scene()
        crafting_grid.insert_box(scene.instance())

func _on_Area2D_body_entered(body):
    if body is Player:
        active = true

func _on_Area2D_body_exited(body):
    if body is Player:
        active = false
