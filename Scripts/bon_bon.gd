extends Area2D

signal died

var start_pos: Vector2 = Vector2.ZERO
var speed: int = 0
var laser_scene = preload("res://Scenes/enemy_laser.tscn")

@onready var screensize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > screensize.y +32:
		start(start_pos)
	

func start(pos):
	speed = 0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished
	$MoveTimer.wait_time = randf_range(5,20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(4,20)
	$ShootTimer.start()

func _on_move_timer_timeout() -> void:
	speed = randf_range(75,100)


func _on_shoot_timer_timeout() -> void:
	var l = laser_scene.instantiate()
	get_tree().root.add_child(l)
	l.start(position)
	$ShootTimer.wait_time = randf_range(4,20)
	$ShootTimer.start()


func explode() -> void:
	speed = 0
	$Explosion.show()
	$Sprite2D.hide()
	$AnimationPlayer.play("explode")
	set_deferred("monitoring", false)
	died.emit(5)
	await $AnimationPlayer.animation_finished
	queue_free()
