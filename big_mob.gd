extends CharacterBody2D

var health = 5

@onready var player = get_node("/root/Game/Player")
@onready var slime_med = preload("res://mob.tscn")

signal enemy_died

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var distance = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)

	# Ralentiza si está muy cerca del jugador
	if distance < 36:
		velocity = direction * 80
	else:
		velocity = direction * 200

	move_and_slide()

func take_damage():
	if global.strength == true:
		health -= 3
	else:
		health -= 1 
	%Slime.play_hurt()

	if health <= 0:
		global.score += 15
		spawn_med_slime()
		spawn_loot()
		spawn_smoke()
		emit_signal("enemy_died")
		queue_free()

func spawn_med_slime():
	for i in range(3): 
		var mob = slime_med.instantiate() 
		mob.position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		get_parent().add_child(mob)

		# Conectar la señal y actualizar el contador
		if mob.has_signal("enemy_died"):
			mob.connect("enemy_died", Callable(get_parent(), "_on_enemy_died"))
		get_parent().total_enemies_alive += 1

func spawn_loot():
	var roll = randf()

	if roll < 0.1:
		var rpm = preload("res://rpm.tscn").instantiate()
		rpm.global_position = global_position
		get_parent().add_child(rpm)
	elif roll < 0.2:
		var strength_potion = preload("res://strength_potion.tscn").instantiate()
		strength_potion.global_position = global_position
		get_parent().add_child(strength_potion)
	elif roll < 0.3:
		var speed_potion = preload("res://blue_potion.tscn").instantiate()
		speed_potion.global_position = global_position
		get_parent().add_child(speed_potion)
	elif roll < 0.4:
		var big_heal = preload("res://big_heal_potion.tscn").instantiate()
		big_heal.global_position = global_position
		get_parent().add_child(big_heal)

func spawn_smoke():
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)
