extends Node3D
var score = 0.0
var player_HP = 10.0

@onready var label = %Score




func increase_score():
	score +=1
	label.text = "Score:" + str(score)


	

func _on_mob_spwaner_2_mob_spawned(zombie_1_mob):
	zombie_1_mob.died.connect(increase_score)
	




	





	


	
	


func _on_area_3d_body_entered(body):
	get_tree().reload_current_scene.call_deferred()
