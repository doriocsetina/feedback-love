extends Node2D

signal turn_ended
@export var player : Player
@export var obstacles : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.move_done.connect(_on_player_move_done)

func _on_player_move_done():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.move()
	turn_ended.emit()
	
