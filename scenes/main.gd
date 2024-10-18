extends Node2D

var tile_map_layer = null
var player_history = []  # Store player states (position, actions, etc.)
var enemy_history = []  # Store enemy states (position, actions, etc.)

func set_tile_map_layer(map):
	tile_map_layer = map

func get_tile_map_layer():
	return tile_map_layer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
