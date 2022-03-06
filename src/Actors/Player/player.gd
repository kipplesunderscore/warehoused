extends Actor2D
class_name Player

onready var states = $StateManager

var grid: BoxGrid
var scene: String
var carrying = null

func _ready() -> void:
	states.init(self)
	scene = get_tree().get_current_scene().get_name()
	if scene == "Game":
		grid = get_parent().get_node("Grid")

func _process(delta: float) -> void:
	states.process(delta)
	$RichTextLabel.text = states.current_state.state_name
 
func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	states.transition_process()

	# enable interact area
	var interact_area = get_current_active_interact_area()
	interact_area.get_node("CollisionShape2D").disabled = false
	
	if grid:
		grid_position()

	match states.current_state.state_name:
		"idle", "move", "coyote":
			$AnimationTree.set("parameters/in_air/current", 0)
		"jump", "fall":
			$AnimationTree.set("parameters/in_air/current", 1)
	
	if velocity.length() > 0:
		var normalized = velocity.normalized()
		$AnimationTree.set("parameters/jump/blend_position", normalized.x)
		$AnimationTree.set("parameters/idle/blend_position", normalized.x)
		
	if Input.is_action_just_pressed("pickup") and not carrying and grid:
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

func get_current_active_interact_area():
	if Input.is_action_pressed("ui_up"):
		if $PlayerVariables.facing_direction() > 0:
			return $TR
		else:
			return $TL
	else:
		if $PlayerVariables.facing_direction() > 0:
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
				

