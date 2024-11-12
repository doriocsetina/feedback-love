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

@export var obstacles : TileMapLayer
@export var selectlayer : TileMapLayer
@export var health_component : HealthComponent

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var attack_timer: Timer = $AttackTimer
@onready var healthbar : ProgressBar = $healthbar

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

func _ready():
	healthbar.max_value = health_component.MAX_HEALTH
	healthbar.value = health_component.health

	# Configure the attack timer
	attack_timer.wait_time = 0.1
	attack_timer.one_shot = true
	attack_timer.timeout.connect(self._on_attack_timer_timeout)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var tile_pos = obstacles.local_to_map(get_global_mouse_position())
		if is_valid(tile_pos) and selectlayer.is_in_range(current_ability, get_global_mouse_position()):
			
			match current_ability:
				Abilities.DASH:
					dash_cooldown = 3
					selected_tile = obstacles.map_to_local(tile_pos)
					move_done.emit()
				Abilities.SHIELD:
					shield_cooldown = 3
					move_done.emit()
				Abilities.ATTACK:
					attack_cooldown = 1
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
					selected_tile = obstacles.map_to_local(tile_pos)
					move_done.emit()
			current_ability = Abilities.NONE
			cooldown()
			
func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
	healthbar.value = health_component.health

func is_valid(tile_pos: Vector2i) -> bool:
	if tile_pos not in obstacles.obstacle_tiles:
		return true
	return false 

func cooldown():
	if dash_cooldown > 0:
		dash_cooldown -= 1
	if shield_cooldown > 0:
		shield_cooldown -= 1
	if attack_cooldown > 0:
		attack_cooldown -= 1

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
	self.queue_free()
