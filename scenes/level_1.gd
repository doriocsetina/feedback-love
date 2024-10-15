extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main.set_tile_map_layer(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
