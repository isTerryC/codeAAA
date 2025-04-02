extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _ChangeScene(num:String) -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/message/Mail_"+num+".tscn")
	

func _on_mail_01_pressed() -> void:
	_ChangeScene("01")


func _on_mail_02_pressed() -> void:
	_ChangeScene("02")
