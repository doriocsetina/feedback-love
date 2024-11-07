extends TileMapLayer

@export var obstacle_tiles = []
@export var enemy_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	identify_obstacles()
	print("obstacles are: ", obstacle_tiles)
	print("enemies are: ", enemy_tiles)

	var player = get_node("/root/main/obstacles/player")  # Adjust the path as necessary
	if player:
		player.move_done.connect(self.identify_obstacles)
		player.move_done.connect(self.print_enemies)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func identify_obstacles():
	obstacle_tiles.clear()
	enemy_tiles.clear()
	var map_size = get_used_rect()
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			var tile_index = get_cell_source_id(Vector2i(x,y))
			if tile_index == 2:  # Assuming 1 is the obstacle tile index
				obstacle_tiles.append(Vector2i(x, y))
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var enemy_pos = local_to_map(enemy.global_position)
		enemy_tiles.append(enemy_pos)

func print_enemies():
	print("enemies are in: ", enemy_tiles)
