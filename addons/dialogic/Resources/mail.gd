extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_esc_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0.1/safe-mode.tscn")  # 切换到游戏场景


func _on_message_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/message/message3.tscn")  # 切换游戏场景


func _on_message_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/message/message2.tscn")  # 切换游戏场景


func _on_message_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/message/message1.tscn")  # 切换游戏场景
