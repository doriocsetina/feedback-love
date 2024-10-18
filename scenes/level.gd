extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var selected_tile_map_layer = $TileMapLayer
	Main.set_tile_map_layer(selected_tile_map_layer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
