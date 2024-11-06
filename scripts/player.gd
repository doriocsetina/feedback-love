extends CharacterBody2D

signal move_done

enum Abilities { NONE, DASH, SHIELD, ATTACK }
var dash_cooldown = 0
var shield_cooldown = 0
var attack_cooldown = 0

var direction : Vector2 = Vector2.ZERO
const tile_size = Vector2(128, 64)
var selected_tile = Vector2(0, 0)

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var obstacles: TileMapLayer = get_parent();
@onready var selectlayer: TileMapLayer = get_node("/root/main/select")

var current_ability = Abilities.NONE

func use_dash():
	if dash_cooldown == 0:
		current_ability = Abilities.DASH

func use_shield():
	if shield_cooldown == 0:
		current_ability = Abilities.SHIELD

func use_attack():
	if attack_cooldown == 0:
		current_ability = Abilities.ATTACK

func reset_ability():
	current_ability = Abilities.NONE

func _onready():
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var tile_map_layer = Main.get_tile_map_layer()
		if tile_map_layer:
			var tile_pos = tile_map_layer.local_to_map(get_global_mouse_position())
			if is_valid(tile_pos) and selectlayer.is_in_range(current_ability, get_global_mouse_position()):
				match current_ability:
					Abilities.DASH:
						dash_cooldown = 3
					Abilities.SHIELD:
						shield_cooldown = 3
					Abilities.ATTACK:
						attack_cooldown = 3
				print("clicked and moved")
				selected_tile = tile_map_layer.map_to_local(tile_pos)
				current_ability = Abilities.NONE
				_on_move_done()
				emit_signal("move_done")
				print("cd of dash is: ", dash_cooldown)
			


# Check if the tile is adjacent and valids
func is_adjacent_and_valid(tile_pos: Vector2i) -> bool:
	var tile_map_layer = Main.get_tile_map_layer()
	var distance = tile_map_layer.local_to_map(position) - tile_pos
	if abs(distance.x) <= 1 and abs(distance.y) <= 1:
		print("distance is: ", distance)
		
		if tile_pos not in obstacles.obstacle_tiles:
			return true
	return false

func is_valid(tile_pos: Vector2i) -> bool:
	if tile_pos not in obstacles.obstacle_tiles:
		return true
	return false 

func _on_move_done():
	if dash_cooldown > 0:
		dash_cooldown -= 1
	if shield_cooldown > 0:
		shield_cooldown -= 1
	if attack_cooldown > 0:
		attack_cooldown -= 1

func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value
	

func update_blend_position():
	animation_tree["parameters/walk/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	
func _physics_process(_delta: float) -> void:
	direction = selected_tile - position 
	var distance = direction.length()

	if distance > 1:
		set_walking(true)
		position = position.lerp(selected_tile, 0.1)
		update_blend_position()
	else:
		set_walking(false)
