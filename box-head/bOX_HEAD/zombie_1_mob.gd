extends RigidBody3D

signal died



@onready var timer = %Timer

var speed_mob = randf_range(2.0,4.0)
var health = 3

@onready var zombie_1_model = %zombie_1_model

@onready var player = get_node("/root/Game/Player")


func _physics_process(delta):
	var direction =global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed_mob
	zombie_1_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)

func take_damage():
	
	if  health <= 0:
		return
	
	health -= 1
	
	if health == 0:
		died.emit()
		
		timer.start()
		


func _on_timer_timeout():
	queue_free()


		
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.damage()
		
		
