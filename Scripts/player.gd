extends Area2D

@export var speed: int = 150
@export var cooldown: float = 0.1
@export var laser_scene: PackedScene

@onready var screensize = get_viewport_rect().size

var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Booster.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Booster.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Booster.animation = "forward"
		
	if Input.is_action_pressed("shoot"):
		shoot()
	
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,16))


func start():
	position = Vector2(screensize.x/2, screensize.y-64)
	$GunCooldown.wait_time = cooldown
	
func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var l = laser_scene.instantiate()
	get_tree().root.add_child(l)
	l.start(position + Vector2(0,-8))


func _on_gun_cooldown_timeout() -> void:
	can_shoot = true
