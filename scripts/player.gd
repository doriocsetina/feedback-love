extends CharacterBody2D
class_name Player

signal move_done
signal attack_done

enum Abilities { NONE, DASH, SHIELD, ATTACK }
var dash_cooldown = 0
var shield_cooldown = 0
var attack_cooldown = 0

var direction : Vector2 = Vector2.ZERO
var attack_direction : Vector2 = Vector2.ZERO
const tile_size = Vector2(128, 64)
var selected_tile : Vector2

var path = []
var current_ability = Abilities.NONE
var current_path_index = 0
var has_moved = false

@export var obstacles : TileMapLayer
@export var selectlayer : TileMapLayer
@export var health_component : HealthComponent

@onready var astar_grid : AStarGrid2D = AStarGrid2D.new()
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var attack_timer: Timer = $AttackTimer
@onready var move_timer: Timer = $MoveTimer

@onready var healthbar : ProgressBar = $healthbar


func use_dash():
	if not has_moved:
		current_ability = Abilities.DASH

func use_shield():
	current_ability = Abilities.SHIELD

func use_attack():
	current_ability = Abilities.ATTACK

func reset_ability():
	current_ability = Abilities.NONE
	has_moved = false

func _ready():
	initialize_astar()
	healthbar.max_value = health_component.MAX_HEALTH
	healthbar.value = health_component.health

	# Configure the attack timer
	attack_timer.wait_time = 0.1
	attack_timer.one_shot = true
	attack_timer.timeout.connect(self._on_attack_timer_timeout)
	move_timer.wait_time = 0.2
	move_timer.one_shot = true
	move_timer.timeout.connect(self._on_move_timer_timeout)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var tile_pos = obstacles.local_to_map(get_global_mouse_position())
		if not has_moved:
			move_to_tile(tile_pos)
		else:
			perform_ability(tile_pos)

func move_to_tile(tile_pos: Vector2i):
	print("moving")
	print(selectlayer.local_to_map(position))
	print(tile_pos)
	path = astar_grid.get_id_path(selectlayer.local_to_map(position), tile_pos)
	print(path)
	if path.size() > 1 and path.size() <= 5:  # Ensure path is within 3 cells
		current_path_index = 1  # Start from the second tile in the path
		move_timer.start()

func _on_move_timer_timeout():
	if current_path_index < path.size():
		var tile = path[current_path_index]
		selected_tile = obstacles.map_to_local(tile)
		current_path_index += 1
		move_timer.start()  # Restart the timer for the next move
	else:
		has_moved = true
		selectlayer.reset_cells()

func perform_ability(tile_pos: Vector2i):
	match current_ability:
		Abilities.ATTACK:
			var current_attack = Attack.new(1)
			move_done.emit()
			if tile_pos in obstacles.enemies_dict:
				obstacles.enemies_dict[tile_pos].damage(current_attack)
			attack_done.emit()
			direction = obstacles.map_to_local(tile_pos) - position
			animation_tree["parameters/attack/blend_position"] = direction
			animation_tree["parameters/walk/blend_position"] = direction
			animation_tree["parameters/idle/blend_position"] = direction
			animation_tree["parameters/conditions/attack"] = true
			attack_timer.start()
		Abilities.NONE:
			pass
	reset_ability()
			
func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	healthbar.value = health_component.health

func is_valid(tile_pos: Vector2i) -> bool:
	if tile_pos not in obstacles.obstacle_tiles:
		return true
	return false

func initialize_astar():
	astar_grid.region = obstacles.get_used_rect()
	astar_grid.cell_size = Vector2i(128, 128)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE

	astar_grid.update()
	# Set solid points
	for x in range(astar_grid.region.position.x, astar_grid.region.position.x + astar_grid.region.size.x):
		for y in range(astar_grid.region.position.y, astar_grid.region.position.y + astar_grid.region.size.y):
			var tile_pos = Vector2i(x, y)
			if obstacles.obstacle_tiles.has(tile_pos):
				astar_grid.set_point_solid(tile_pos, true)
			

func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value

func _on_attack_timer_timeout():
	animation_tree["parameters/conditions/attack"] = false

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

func on_death():
	print("you lost!")
