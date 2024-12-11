extends Node2D

var enemy = preload("res://Scenes/bon_bon.tscn")
var score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemies()


func spawn_enemies() -> void:
	for x in range(9):
		for y in range(3):
			var e = enemy.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.died.connect(_on_enemy_died)
			
func _on_enemy_died(value):
	score += value
