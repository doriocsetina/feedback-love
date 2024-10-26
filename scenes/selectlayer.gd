extends TileMapLayer

var previous_tile = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tile = local_to_map(get_global_mouse_position())

	if previous_tile != null and previous_tile != tile:
		set_cell(previous_tile, -1)

	set_cell(tile, 0, Vector2i(0, 0))

	previous_tile = tile
