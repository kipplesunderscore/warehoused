extends KinematicBody2D
class_name Player

export var speed = 400
export var gravity_scale = 500
var screen_size
var carrying = null
var moving_right = 1

var starting_pos = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grid: BoxGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_pos = self.position
	grid = get_parent().get_node("Grid")
	screen_size = get_viewport_rect().size

func get_current_active_interact_area():
	if Input.is_action_pressed("ui_up"):
		if moving_right > 0:
			return $TR
		else:
			return $TL
	else:
		if moving_right > 0:
			return $MR
		else:
			return $ML
			
func grid_position():
	if grid.is_pixel_x_position_inside_grid(self.position.x):
		var col = grid.get_col_from_x_pixel_pos(self.position.x)
		var row = max(0, grid.get_row_from_y_pixel_pos(self.position.y))
		if Input.is_action_just_pressed("test_spawn_box") and carrying:
			if not grid.get_grid_cell(row, col):
				var box = carrying
				carrying = null
				box.enable_collision()
				self.remove_child(box)
				grid.insert_grid_array(box, row, col)
				var pos = grid.get_grid_pixel_position(row, col)
				box.position = pos
				grid.add_child(box)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(_delta):
	#disable all interact areas
	for area in get_tree().get_nodes_in_group("PlayerInteractArea"):
		area.get_node("CollisionShape2D").disabled = true
		
	var velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		moving_right = -1
		velocity.x -= speed
	if Input.is_action_pressed("ui_right"):
		moving_right = 1
		velocity.x += speed
	if velocity.length() > 0:
		velocity = velocity.normalized()
		$AnimationTree.set("parameters/jump/blend_position", velocity.x)
		$AnimationTree.set("parameters/idle/blend_position", velocity.x)
		velocity = velocity * speed
		
	# enable interact area
	var interact_area = get_current_active_interact_area()
	interact_area.get_node("CollisionShape2D").disabled = false
	
	grid_position()

	if is_on_floor():
		$AnimationTree.set("parameters/in_air/current", 0)

	velocity.y = gravity_scale
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = -20 * speed;
		$AnimationTree.set("parameters/in_air/current", 1)

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("pickup") and not carrying:
		for body in interact_area.get_overlapping_areas():
			if body.is_in_group("Box InteractArea"):
				var box = body.get_parent()
				grid.remove_box(box)
				grid.remove_child(box)
				carrying = box
				self.add_child(carrying)
				carrying.set_position(Vector2(0,-50))
				carrying.disable_collision()
				carrying.moving = false
				carrying.falling = false
				break
