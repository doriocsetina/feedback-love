extends Control


# Called when the node enters the scene tree for the first time.
@onready var character = get_node("/root/main/obstacles/player")  # Adjust the path as necessary

func _ready():
	$abilities/dash.pressed.connect(self._on_dash_button_pressed)
	$abilities/attack.pressed.connect(self._on_attack_button_pressed)
	$abilities/shield.pressed.connect(self._on_shield_button_pressed)

func _on_dash_button_pressed():
	character.use_dash()

func _on_shield_button_pressed():
	character.use_shield()

func _on_attack_button_pressed():
	character.use_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
