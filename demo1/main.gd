extends Node

@export var mob_scene: PackedScene

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()  # give random offset

	var player_pos = $Player.position
	mob.initialize(mob_spawn_location.position, player_pos)
	
	add_child(mob)
	
	mob.squashed.connect($UI/MarginContainer/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	$MobTimer.stop()


func _on_field_body_exited(body):
	if body.is_in_group("mob"):
		body.flee()
		
