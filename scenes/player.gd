extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
const tile_size = Vector2(128, 64)
var selected_tile = Vector2()

@onready var animation_tree: AnimationTree = $AnimationTree

func _onready():
	global_position = selected_tile
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var tile_map_layer = Main.get_tile_map_layer()
		print("i clicked the mouse at ", event.position)
		if tile_map_layer:
			var tile_pos = tile_map_layer.local_to_map(get_global_mouse_position())
			selected_tile = tile_map_layer.map_to_local(tile_pos)
			print("going to: ", selected_tile)

func _physics_process(_delta: float) -> void:
	direction = selected_tile - global_position 
	var distance = direction.length()

	if distance > 1:
		set_walking(true)
		global_position = global_position.lerp(selected_tile, 0.1)
		update_blend_position()
	else:
		set_walking(false)

# Check if the tile is adjacent and valid
func is_adjacent_and_valid(tile_pos: Vector2) -> bool:
	var tile_map_layer = Main.get_tile_map_layer()
	var distance = (position - tile_pos).abs() / tile_size
	if distance.x <= 1 and distance.y <= 1:
		var tile = tile_map_layer.world_to_map(tile_pos)
		var tile_id = tile_map_layer.get_cellv(tile)

		if tile_id == 1:  # Assuming tile ID 1 is walkable
			return true
	return false

func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value
	

func update_blend_position():
	animation_tree["parameters/walk/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	
