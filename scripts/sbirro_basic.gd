extends CharacterBody2D

@export var health_component : HealthComponent
@export var move_interval : float = 1.0  # Interval in seconds for random movement

@onready var obstacles = get_node("/root/main/obstacles")  # Adjust the path as necessary

func _ready() -> void:
	add_to_group("enemies")
	
	var player = get_node("/root/main/obstacles/player")
	if player:
		player.move_done.connect(self._on_move_done)
		
func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

func _on_move_done():
	var directions = [
		Vector2(1, 1),  # Right
		Vector2(-1, -1),  # Left
		Vector2(0.5, 1),  # Down
		Vector2(-0.5, -1)  # Up
	]
	var random_direction = directions[randi() % directions.size()]
	var target_position = position + random_direction * 64  # Assuming tile size is 64x64

	# Check if the target position is an obstacle
	var target_tile = obstacles.local_to_map(target_position)
	if not obstacles.obstacle_tiles.has(target_tile):
		position = target_position
