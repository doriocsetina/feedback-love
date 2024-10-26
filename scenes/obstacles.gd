extends TileMapLayer

@export var obstacle_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	identify_obstacles()
	print("obstacles are: ", obstacle_tiles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func identify_obstacles():
	var map_size = get_used_rect()
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			var tile_index = get_cell_source_id(Vector2i(x,y))
			if tile_index == 2:  # Assuming 1 is the obstacle tile index
				obstacle_tiles.append(Vector2i(x, y))
