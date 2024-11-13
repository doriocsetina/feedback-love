extends TileMapLayer

var previous_tile = null
@export var player : CharacterBody2D
@export var obstacles : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func display_range():
	var current_tile = local_to_map(player.position)
	print("astar is configured like this; ", player.astar_grid.diagonal_mode)
	reset_cells()
	if previous_tile != null and previous_tile != current_tile:
		set_cell(previous_tile, -1)

	# Reflect the character's ability in the tile selection
	match player.current_ability:
		player.Abilities.DASH:
			# Allow moving two tiles
			var start_tile = local_to_map(player.position)
			var reachable_tiles = get_reachable_tiles(start_tile, 4)
			for tile in reachable_tiles:
				set_cell(tile, 2, Vector2i(0, 0))
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

func get_reachable_tiles(start_tile: Vector2i, max_distance: int) -> Array:
	var reachable_tiles = []
	for x in range(player.astar_grid.region.position.x, player.astar_grid.region.position.x + player.astar_grid.region.size.x):
		for y in range(player.astar_grid.region.position.y, player.astar_grid.region.position.y + player.astar_grid.region.size.y):
			var tile_pos = Vector2i(x, y)
			if not player.astar_grid.is_point_solid(tile_pos):
				var path = player.astar_grid.get_id_path(start_tile, tile_pos)
				if path.size() < max_distance + 1:
					var is_valid_path = true
					for point in path:
						if player.astar_grid.is_point_solid(point):
							is_valid_path = false
							break
					if is_valid_path:
						reachable_tiles.append(tile_pos)
			else:
				print("there is an obstacle!")
	return reachable_tiles

func reset_cells():
	var map_size = get_used_rect()
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			set_cell(Vector2i(x,y), -1)
	
