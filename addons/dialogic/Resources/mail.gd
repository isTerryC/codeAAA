extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mail: VBoxContainer = $BorderLine/Label_Middle/MarginContainer/ScrollContainer/VBoxContainer
	mail._changeVisibility(G.flag)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _ChangeScene(num:String) -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/message/Mail_"+num+".tscn")
	

func _on_mail_01_pressed() -> void:
	_ChangeScene("01")

func _on_mail_02_pressed() -> void:
	_ChangeScene("02")

func _on_mail_03_pressed() -> void:
	_ChangeScene("03")


func _on_button_escape_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0.1/safe-mode-message.tscn")
