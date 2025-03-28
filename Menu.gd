extends Node

func _process(delta: float) -> void:
	pass
	
func _on_pressed():
	$ClickSound.play()	
	get_tree().change_scene_to_file("res://game.tscn")
