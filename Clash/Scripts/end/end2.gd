extends Node

var texts = ["K逃出了监狱", "市长A跟B都在K提交的证据下被抓获", "城市混乱中，D不见了", "K,I‘m D. Welcome to Alex."]
var current_index = 0

func _ready():
	$Label.text = texts[current_index]
	$AnimationPlayer.play("fade_animation")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_animation":
		current_index += 1
		if current_index >= texts.size():
			# 停止动画播放，退出程序或进行其他操作
			get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/control.tscn")
			# 或者，您可以在此进行其他操作
		else:
			$Label.text = texts[current_index]
			$AnimationPlayer.play("fade_animation")
