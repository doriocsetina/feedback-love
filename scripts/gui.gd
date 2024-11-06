extends Control


# Called when the node enters the scene tree for the first time.
@onready var character = get_node("/root/main/obstacles/player")  # Adjust the path as necessary
@onready var dash_button = $abilities/dash
@onready var attack_button = $abilities/shield
@onready var shield_button = $abilities/attack
@onready var dash_cooldown_label = $abilities/dash/dash_cd
@onready var shield_cooldown_label = $abilities/shield/shield_cd
@onready var attack_cooldown_label = $abilities/attack/attack_cd

func _ready():
	dash_button.toggle_mode = true
	attack_button.toggle_mode = true
	shield_button.toggle_mode = true
	
	dash_button.pressed.connect(self._on_dash_button_pressed)
	attack_button.pressed.connect(self._on_shield_button_pressed)
	shield_button.pressed.connect(self._on_attack_button_pressed)
	character.move_done.connect(self._on_move_done)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_Q:
				dash_button.button_pressed = !dash_button.button_pressed
				_on_dash_button_pressed()
			KEY_W:
				shield_button.button_pressed = !shield_button.button_pressed
				_on_shield_button_pressed()
			KEY_E:
				attack_button.button_pressed = !attack_button.button_pressed
				_on_attack_button_pressed()
				

func _on_dash_button_pressed():
	if dash_button.button_pressed:
		character.use_dash()
		shield_button.button_pressed = false
		attack_button.button_pressed = false
	else:
		character.reset_ability()

func _on_shield_button_pressed():
	if shield_button.button_pressed:
		character.use_shield()
		dash_button.button_pressed = false
		attack_button.button_pressed = false
	else:
		character.reset_ability()

func _on_attack_button_pressed():
	if attack_button.button_pressed:
		character.use_attack()
		dash_button.button_pressed = false
		shield_button.button_pressed = false
	else:
		character.reset_ability()

func _on_move_done():
	update_cooldown_labels()
	reset_buttons()


func reset_buttons():
	dash_button.button_pressed = false
	shield_button.button_pressed = false
	attack_button.button_pressed = false

func update_cooldown_labels():
	dash_cooldown_label.text = str(character.dash_cooldown)
	shield_cooldown_label.text = str(character.shield_cooldown)
	attack_cooldown_label.text = str(character.attack_cooldown)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
