extends Node2D
class_name BoxGrid

export var width = 10;
export var height = 6;

var x_offset = -64
var y_offset = 64

export var spawn_rate = 5.0;
export var fastest_spawn_rate = 1.0;

var timer;

var combo = 0

var grid_array = [];

var possible_boxes = [
	preload("res://Box/Grape.tscn"),
	preload("res://Box/Apple.tscn"),
	preload("res://Box/Melon.tscn"),
	preload("res://Box/Bolt.tscn"),
	preload("res://Box/Fabric.tscn")
]

var can_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	timer = Timer.new()
	timer.wait_time = spawn_rate;
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()
	grid_array.resize(width * height);
	
func _process(_delta):
	for col in range(width):
		for row in range(height):
			var box = get_grid_cell(row, col)
			# no box found at coord skip to next coord
			if not box: continue
			# if box is at the bottom continue
			if is_grid_bottom_row(row): continue
			
			if not box.is_steady(): continue
			# if there is a box below continue
			var beneath = get_grid_cell(row + 1, col)
			if beneath: continue
			# at this point there is an empty space below the box so drop it
			grid_drop_box(box, row + 1, col)
	# check top row for boxes that need to move to next column
	for col in range(width):
		var row = 0
		var box = get_grid_cell(row, col)
		# no box found at coord skip to next coord
		if not box: continue
		
		if not box.is_steady(): continue
		
		# box has been made it to the end of the grid and can't drop
		if col + 1 == width:
			remove_box(box)
			box.queue_free()
			can_spawn = false
			get_parent().get_node("ScoreCounter").game_over = true
			continue
			
		# if there is a box below error
		var beneath = get_grid_cell(row + 1, col)
		if not beneath: assert("This Shouldn't Happen...")
		
		# at this point the box needs to move to the next column.
		grid_move_box(box, row, col+1)
	grid_match_3()
	
	var steady = true
	for box in grid_array:
		if box != null:
			if not box.is_steady():
				steady = false
	if steady:
		combo = 0
		
func grid_match_3():
	for col in range(width):
		for row in range(height):
			var box = get_grid_cell(row, col)
			if not box: continue
			grid_match_3_vertical(box, row, col)
			grid_match_3_horizontal(box, row, col)
			
func grid_match_3_vertical(box, row, col):
	if is_grid_top_row(row) or is_grid_bottom_row(row): return
	var above = get_grid_cell(row - 1, col)
	var below = get_grid_cell(row + 1, col)
	
	if not above: return
	if not below: return
	
	if box.is_steady() and above.is_steady() and below.is_steady():
		# match 3!
		if above.type == box.type and box.type == below.type:
			remove_box(box)
			remove_box(above)
			remove_box(below)
			box.queue_free()
			above.queue_free()
			below.queue_free()
			add_score()

func add_score():
	combo += 1
	get_parent().get_node("ScoreCounter").add_score(1 * combo)
	pass
	
func grid_match_3_horizontal(box, row, col):
	if is_grid_leftmost_col(col) or is_grid_rightmost_col(col): return
	var left = get_grid_cell(row, col + 1)
	var right = get_grid_cell(row, col - 1)
	
	if not left: return
	if not right: return
	
	if box.is_steady() and left.is_steady() and right.is_steady():
		# match 3!
		if box.type == left.type and box.type == right.type:
			remove_box(box)
			remove_box(left)
			remove_box(right)
			box.queue_free()
			left.queue_free()
			right.queue_free()
			add_score()

func is_grid_leftmost_col(col):
	return col == width - 1

func is_grid_rightmost_col(col):
	return col == 0

func grid_move_box(box, row, col):
	if box.is_moving(): return
	remove_grid_array(row, col-1)
	insert_grid_array(box, row, col)
	var pixel_pos = get_grid_pixel_position(row, col)
	box.move_to_x_position(pixel_pos.x)

## takes a box and a row / col to drop box into.
func grid_drop_box(box, row, col):
	if box.is_falling(): return
	remove_grid_array(row - 1, col)
	insert_grid_array(box, row, col)
	var pixel_pos = get_grid_pixel_position(row, col)
	box.drop_to_y_position(pixel_pos.y)

func remove_grid_array(row, col):
	grid_array[get_grid_index(row, col)] = null
	
func insert_grid_array(box, row, col):
	grid_array[get_grid_index(row, col)] = box

## takes row / col and returns pixel position
func get_grid_pixel_position(row, col):
	return Vector2(col * x_offset, row * y_offset)

## takes row returns if row is the top-most row
func is_grid_top_row(row):
	return row == 0

func is_grid_bottom_row(row):
	return row == height - 1

func get_spawn_rate():
	var score = get_parent().get_node("ScoreCounter").score
	return max(fastest_spawn_rate, lerp(spawn_rate, fastest_spawn_rate, score / 20.0))

func _on_timer_timeout():
	timer.wait_time = get_spawn_rate();
	if box_can_spawn():
		var box = get_random_box()
		grid_array[0] = box;
		add_child(box)

func get_grid_position(i):
	return {
		"row": i / width,
		"col": i % width
	}

func get_grid_index(row, col):
	return (row * width) + col

func remove_box(box):
	var i = grid_array.find(box, 0)
	grid_array[i] = null

func get_grid_cell(row, col):
	var index = get_grid_index(row, col)
	return grid_array[index]

func get_random_box():
	var rand = floor(rand_range(0, possible_boxes.size()))
	return possible_boxes[rand].instance()

func box_can_spawn():
	return not grid_array[0] and can_spawn and combo < 1

func box_can_drop(box):
	var i = grid_array.find(box, 0)
	var pos = get_grid_position(i)
	# at the bottom
	if pos.row == height - 1: return false
	return not get_grid_cell(pos.row + 1, pos.col)

func drop_box(box):
	var i = grid_array.find(box, 0)
	var pos = get_grid_position(i)
	grid_array[i] = null
	var next_row = find_next_empty_row(pos.col)
	var index = get_grid_index(next_row, pos.col)
	grid_array[index] = box

func find_next_empty_row(col):
	for row in range(height):
		if get_grid_cell(row, col):
			return row - 1
	return height - 1

func is_pixel_x_position_inside_grid(x):
	var x2 = self.position.x
	var x1 = self.position.x + (width * x_offset)
	return x > x1 and x < x2

func get_col_from_x_pixel_pos(x):
	var delta = self.position.x - x - (x_offset/2)
	var col = abs(delta / x_offset)
	return floor(col)

func get_row_from_y_pixel_pos(y):
	var delta = y - self.position.y
	if delta < 0:
		return - 1
	var row = delta / y_offset
	return floor(row)
