extends Node2D
class_name HealthComponent

@export var MAX_HEALTH = 5
var health : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH


func damage(attack: Attack):
	health -= attack.attack_damage

	if health <= 0:
		get_parent().on_death()
