extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "gate"
	add_to_group("interactables")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
