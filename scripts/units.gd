extends Node2D
class_name UnitsContainer

signal battle_over(player_won)

@export var player_group: Node2D
@export var enemy_group: UnitGroup

var current_group: Node
var current_group_index: int = 0

func init() -> void:
	for child in get_children():
		child.init()

func _ready() -> void:
	pass
