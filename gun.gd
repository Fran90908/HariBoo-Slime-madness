extends Area2D

@onready var player = get_node("/root/Game/Player")
var current_target = null

func _ready():
	adjust_timer_rpm()

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		current_target = get_closest_enemy(enemies_in_range)
		look_at(current_target.global_position)
	else:
		current_target = null

func get_closest_enemy(enemies):
	var closest = null
	var min_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
	return closest

func shoot():
	if current_target == null:
		return

	var bullet_scene = preload("res://bullet.tscn")
	var bullet = bullet_scene.instantiate()
	bullet.global_position = %ShootingPoint.global_position
	bullet.global_rotation = %ShootingPoint.global_rotation
	get_tree().current_scene.add_child(bullet)

func _on_timer_timeout():
	if current_target != null:
		shoot()
	adjust_timer_rpm()

func adjust_timer_rpm():
	if global.rpm:
		%Timer.wait_time = 0.1
	else:
		%Timer.wait_time = 0.7
	%Timer.start()
