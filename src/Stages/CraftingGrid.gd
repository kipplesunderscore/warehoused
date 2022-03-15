extends Node2D
class_name CraftingGrid


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var crafting_grid = [null, null, null]
var index = 0

func insert_box(box):
	# grid full return
	# TODO: give player feedback that grid is full
	if index > 2:
		box.queue_free()
		return
	assert(index <= 2, "invalid crafting grid insertion")
	crafting_grid[index] = box
	add_child(box)
	box.position.y = - index * 64
	index += 1
	
func handle_craft():
	for box in crafting_grid:
		box.queue_free()
	crafting_grid = [null, null, null]
	index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if index > 2 and $Timer.is_stopped():
		$Timer.start()


func _on_Timer_timeout():
	if index > 2:
		handle_craft()
