extends Node2D

@onready var units: UnitsContainer = %units

func _ready() -> void:
	pass


func _on_battle_over(player_won: bool) -> void:
	if player_won:
		print("si vint")
	else:
		print("ia frnut")
