extends CharacterBody2D

@export var health_component : HealthComponent
@export var obstacles : TileMapLayer # Adjust the path as necessary

@onready var healthbar : ProgressBar = $healthbar
@onready var astar_grid : AStarGrid2D = AStarGrid2D.new()
@onready var enemies : Node2D = get_parent()


enum State {
	IDLE,
	MOVE_TO_OBJECTIVE,
	AGGRO
}

var state = State.IDLE
var player : Player
var objective_position : Vector2
var turns_in_objective = 0
var current_path = []

func _ready() -> void:
	add_to_group("enemies")
	healthbar.max_value = health_component.MAX_HEALTH
	healthbar.value = health_component.health
	objective_position = obstacles.gate.position
	player = enemies.player
	initialize_astar()
		
func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	healthbar.value = health_component.health

func move():
	check_player_proximity()
	match state:
		State.IDLE:
			state = State.MOVE_TO_OBJECTIVE
		State.MOVE_TO_OBJECTIVE:
			move_towards_objective()
		State.AGGRO:
			chase_player()

func initialize_astar():
	astar_grid.region = obstacles.get_used_rect()
	print("gridsize is: ", astar_grid.size)
	astar_grid.cell_size = Vector2i(128, 128)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	for x in range(astar_grid.region.position.x, astar_grid.region.position.x + astar_grid.region.size.x):
		for y in range(astar_grid.region.position.y, astar_grid.region.position.y + astar_grid.region.size.y):
			var tile_pos = Vector2i(x, y)
			if not obstacles.obstacle_tiles.has(tile_pos):
				astar_grid.set_point_solid(tile_pos, true)
			else:
				astar_grid.set_point_solid(tile_pos, false)
	astar_grid.update()

func move_towards_objective():
	var start_pos = obstacles.local_to_map(position)
	var end_pos =  obstacles.local_to_map(objective_position)
	print("enemy is at position: ", start_pos)
	print("objective is at position: ", end_pos)
	current_path = astar_grid.get_id_path(start_pos, end_pos, true)
	
	if current_path.size() > 1:
		var next_pos = current_path[1]
		position = obstacles.map_to_local(next_pos)
		if position.distance_to(objective_position) < 64:
			turns_in_objective += 1
			if turns_in_objective > 2:
				print("si perdut trmon")
		else:
			turns_in_objective = 0

func chase_player():
	var start_pos = obstacles.local_to_map(position)
	var end_pos = obstacles.local_to_map(player.position)
	print("enemy is at position: ", start_pos)
	print("player is at position: ", end_pos)
	current_path = astar_grid.get_id_path(start_pos, end_pos, true)
	print(current_path)

	print("doing a move: player is at ", current_path.size(), " blocks of distance")
	if position.distance_to(player.position) < 128:
		player.damage(Attack.new(1))
		print("attack")

	elif current_path.size() > 1:
		var next_pos = current_path[1]
		# Check if the next position is adjacent to the player
		
		position = obstacles.map_to_local(next_pos)
		

func check_player_proximity():
	var start_pos = obstacles.local_to_map(position)
	var end_pos = obstacles.local_to_map(player.position)
	current_path = astar_grid.get_point_path(start_pos, end_pos)
	if current_path.size() <= 4:  # 3 blocks range (4 points including the start)
		state = State.AGGRO
	else:
		state = State.MOVE_TO_OBJECTIVE

func on_death():
	self.queue_free()

func _draw():
	if current_path.size() > 1:
		for i in range(current_path.size() - 1):
			var from = obstacles.map_to_local(current_path[i])
			var to = obstacles.map_to_local(current_path[i + 1])
			draw_line(from, to, Color(1, 0, 0), 2)
