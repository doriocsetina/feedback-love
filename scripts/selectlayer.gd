extends TileMapLayer

var previous_tile = null
@export var player : CharacterBody2D
@export var obstacles : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_tile = local_to_map(player.position)
	
	reset_cells()
	if previous_tile != null and previous_tile != current_tile:
		set_cell(previous_tile, -1)

	# Reflect the character's ability in the tile selection
	match player.current_ability:
		player.Abilities.DASH:
			# Allow moving two tiles
			for dx in [-2, -1, 0, 1, 2]:
				for dy in [-2, -1, 0, 1, 2]:
					if abs(dx) + abs(dy) <= 2 and current_tile + Vector2i(dx, dy) not in obstacles.obstacle_tiles:  # Ensure we're within a Manhattan distance of 2
						set_cell(current_tile + Vector2i(dx, dy), 2, Vector2i(0, 0))
		player.Abilities.SHIELD:
			# No movement, just highlight the current current_tile
			set_cell(current_tile, 2, Vector2i(0, 0))
		player.Abilities.ATTACK:
			# Allow moving in four basic directions	
			set_cell(current_tile, 1, Vector2i(0, 0))
			set_cell(current_tile + Vector2i(1, 0), 1, Vector2i(0, 0))
			set_cell(current_tile + Vector2i(-1, 0), 1, Vector2i(0, 0))
			set_cell(current_tile + Vector2i(0, 1), 1, Vector2i(0, 0))
			set_cell(current_tile + Vector2i(0, -1), 1, Vector2i(0, 0))
		player.Abilities.NONE:
			# Default behavior
			pass
	
	previous_tile = current_tile

func is_in_range(current_ability: int, selected_position: Vector2i) -> bool:
	var current_tile = local_to_map(player.position)
	var selected_tile = local_to_map(selected_position)
	var manhattan_distance = abs(current_tile.x - selected_tile.x) + abs(current_tile.y - selected_tile.y)
	
	match current_ability:
		player.Abilities.DASH:
			return manhattan_distance <= 2
		player.Abilities.SHIELD:
			return manhattan_distance == 0
		player.Abilities.ATTACK:
			return manhattan_distance == 1
		player.Abilities.NONE:
			return manhattan_distance == 1
	return false

func reset_cells():
	var map_size = get_used_rect()
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			set_cell(Vector2i(x,y), -1)
	
