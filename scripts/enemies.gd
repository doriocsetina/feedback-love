extends Node2D
class_name UnitGroup

signal turn_complete
signal attack(ac)
signal defeated

@export var player : Player
@export var obstacles : TileMapLayer


func _ready() -> void:
	player.move_done.connect(_on_player_move_done)

func _on_player_move_done():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.move()
	turn_complete.emit()
	
