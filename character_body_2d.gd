extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction : Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = direction * SPEED
		set_walking(true)
		update_blend_position()
	else:
		set_walking(false)
		self.velocity = Vector2.ZERO
		
	move_and_slide()
	
func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = not value
	

func update_blend_position():
	animation_tree["parameters/walk/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	
