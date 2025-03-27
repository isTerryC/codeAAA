extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#开始检测按钮状态
	set_process_input(true)
	var label = $ScrollContainer_left/Label
	label.text=""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var label = $ScrollContainer_left/Label
	label.text = "1111111
	222222
	333333
	44444444
	555555555555
	6
	77777777777
	88888"


func _on_button_2_pressed() -> void:
	var label = $ScrollContainer_left/Label
	label.text = "22222222
	333333
	444444444
	5555555
	6666666666
	77777777
	8
	9999"
