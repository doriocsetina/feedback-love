extends CharacterBody2D

@export var health_component : HealthComponent
@export var move_interval : float = 1.0  # Interval in seconds for random movement
@export var obstacles : TileMapLayer # Adjust the path as necessary

@onready var healthbar : ProgressBar = $healthbar

func _ready() -> void:
	add_to_group("enemies")
	healthbar.max_value = health_component.MAX_HEALTH
	healthbar.value = health_component.health
		
func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	healthbar.value = health_component.health

func move():
	print("cop health is: ", health_component.health)

func on_death():
	self.queue_free()
