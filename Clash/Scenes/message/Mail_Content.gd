extends Node


func _on_button_escape_pressed() -> void:
	if(G.flag < 1):
		G.update_flag(1)
	elif(G.flag == 6):
		G.update_flag(1)
	get_tree().change_scene_to_file("res://Clash/Scenes/UI/mail.tscn")
