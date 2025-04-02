extends Node


func _on_button_escape_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/UI/mail.tscn")
