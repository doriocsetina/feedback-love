extends TileMapLayer

var previous_tile = null
@onready var character = get_node("/root/main/obstacles/player")  # Adjust the path as necessary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tile = local_to_map(character.position)

	if previous_tile != null and previous_tile != tile:
		set_cell(previous_tile, -1)

	# Reflect the character's ability in the tile selection
	match character.current_ability:
		character.Abilities.DASH:
			# Allow moving two tiles
			set_cell(tile, 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(1, 0), 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(0, 1), 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(1, 1), 0, Vector2i(0, 0))
		character.Abilities.SHIELD:
			# No movement, just highlight the current tile
			set_cell(tile, 0, Vector2i(0, 0))
		character.Abilities.ATTACK:
			# Allow moving in four basic directions
			set_cell(tile, 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(1, 0), 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(-1, 0), 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(0, 1), 0, Vector2i(0, 0))
			set_cell(tile + Vector2i(0, -1), 0, Vector2i(0, 0))
		character.Abilities.NONE:
			# Default behavior
			set_cell(tile, 0, Vector2i(0, 0))

	previous_tile = tile
