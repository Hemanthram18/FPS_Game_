extends CharacterBody3D
var gravity:float = 12
var stamina_now:float = 5.0





@export var player_hp: float = 10.0
@export var stamina: float = 5.0
@export var stamina_recover: float = 1.5
@export var SPRINT_SPEED:float = 12.0
@export var WALK_SPEED:float = 8.0
@export var JUMP_VELOCITY:float = 4.5
@export var mouse_sen:float = 0.002
@export var CROUCH_SPEED:float = 3.0


@onready var camera = $Camera3D
@onready var HP = %HP


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	HP.text = "HP: " + str(player_hp)
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sen)
		camera.rotate_x(-event.relative.y * mouse_sen)
		camera.rotation.x = clamp(camera.rotation.x , deg_to_rad(-90),deg_to_rad(90))
	
	if Input.is_action_just_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and Input.is_action_pressed("sprint"):
		stamina_now -= delta
		velocity.x = direction.x * SPRINT_SPEED
		velocity.z = direction.z * SPRINT_SPEED
		
	
	elif direction and Input.is_action_pressed("crouch"):
		stamina_now += delta * stamina_recover
		velocity.x = direction.x * CROUCH_SPEED
		velocity.z = direction.z * CROUCH_SPEED
	
	
	elif direction:
		stamina_now += delta * stamina_recover
		velocity.x = direction.x * WALK_SPEED
		velocity.z = direction.z * WALK_SPEED
		
	
	else:
		stamina_now += delta * stamina_recover
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)
	
	

	move_and_slide()
	
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()
	
func shoot_bullet():
	const bullet = preload("res://bOX_HEAD/bullet_pistol.tscn")
	var new_bullet = bullet.instantiate()
	%Marker3D.add_child(new_bullet)
	
	new_bullet.global_transform = %Marker3D.global_transform


	

func damage():
	player_hp -=1
	HP.text = "HP:" + str(player_hp)
	if player_hp <=0 :
		get_tree().reload_current_scene.call_deferred()

	
	



	
