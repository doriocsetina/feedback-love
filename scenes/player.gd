extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
const tile_size = Vector2(64, 32)
var target_position = Vector2()

@onready var animation_tree: AnimationTree = $AnimationTree

func _onready():
	target_position = position
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var click_position = event.position
		var tile_map_layer = Main.get_tile_map_layer()
		print("i clicked the mouse")
		if tile_map_layer:
			var tile_pos = tile_map_layer.local_to_map(click_position)
			var world_pos = tile_map_layer.map_to_local(tile_pos) + tile_size / 2
			print("there is a maplayetr")
			target_position = world_pos
			print("it's adjacent")

func _physics_process(delta: float) -> void:
	var direction = (target_position - position).normalized() 
	position = position.lerp(target_position, 0.1)
	if direction:
		set_walking(true)
		update_blend_position()
	else:
		set_walking(false)
		self.velocity = Vector2.ZERO
		

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
	
