extends TileMapLayer

@export var obstacle_tiles = []
@export var enemies_dict : Dictionary
@export var interactables_dict : Dictionary

@export var player : CharacterBody2D
@export var ground : TileMapLayer

@export var gate : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	identify_obstacles()
	print("obstacles are: ", obstacle_tiles)
	if player:
		player.move_done.connect(self.identify_obstacles)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func identify_obstacles():
	obstacle_tiles.clear()
	enemies_dict.clear()

	var map_size = ground.get_used_rect()
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x + 1):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y + 1):
			var tile_index_obstacle = get_cell_source_id(Vector2i(x,y))
			var tile_index_ground = ground.get_cell_source_id(Vector2i(x,y))
			if tile_index_obstacle == 2 or tile_index_ground == -1:
				obstacle_tiles.append(Vector2i(x, y))
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var enemy_pos = local_to_map(enemy.global_position)
		enemies_dict[enemy_pos] = enemy
	var interactables = get_tree().get_nodes_in_group("interactables")

	for interactable in interactables:
		var interactable_pos = local_to_map(interactable.global_position)
		interactables_dict[interactable_pos] = interactable
