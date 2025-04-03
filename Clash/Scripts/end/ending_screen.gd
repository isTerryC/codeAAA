extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label1 = $BorderLine/Label_Middle/RichTextLabel
	var label2 = $BorderLine/Label_Middle/RichTextLabel2
	var label3 = $BorderLine/Label_Middle/RichTextLabel3
	var time1:float = 0.0 


	$BorderLine/Label_Middle/Sprite2D.visible=false
	$BorderLine/Label_Middle/Sprite2D5.visible=false
	$BorderLine/Label_Middle/Sprite2D6.visible=false
	$BorderLine/Label_Middle/Sprite2D7.visible=false
	$BorderLine/Label_Middle/RichTextLabel4.visible=false
	$BorderLine/Label_Middle/RichTextLabel8.visible=false
	$BorderLine/Label_Middle/RichTextLabel9.visible=false
	$BorderLine/Label_Middle/RichTextLabel10.visible=false
	$BorderLine/Label_Middle/Author.visible=false
	
	#label1.visible = false
	#label2.visible = false
	#label3.visible = false
	
	label1.modulate=Color(1,1,1,0)
	label2.modulate=Color(1,1,1,0)
	label3.modulate=Color(1,1,1,0)
	
	start_fade(label1,1.5)
	await create_timer_and_wait(1.5)
	
	start_fade(label2,1.2)
	await create_timer_and_wait(2.0)
	
	start_fade(label3,1.6)
	await create_timer_and_wait(1.6)
	
	start_reverse_fade(2.0)
	await create_timer_and_wait(2.0)



	$BorderLine/Label_Middle/Sprite2D.visible=true
	$BorderLine/Label_Middle/Sprite2D5.visible=true
	$BorderLine/Label_Middle/Sprite2D6.visible=true
	$BorderLine/Label_Middle/Sprite2D7.visible=true
	$BorderLine/Label_Middle/RichTextLabel4.visible=true
	$BorderLine/Label_Middle/RichTextLabel8.visible=true
	$BorderLine/Label_Middle/RichTextLabel9.visible=true
	$BorderLine/Label_Middle/RichTextLabel10.visible=true
	$BorderLine/Label_Middle/Author.visible=true
	
	await create_timer_and_wait(15.0)
	
	get_tree().change_scene_to_file("res://Clash/Scenes/Scene-0/control.tscn") 
	
func create_timer_and_wait(timeout: float):
	
	var timer = get_tree().create_timer(timeout)
	await timer.timeout

func start_fade(labeler:RichTextLabel,time1:float) -> void:
	var q : float = 0.0
	for i in range(100):
		var split_time : float = time1/100.0
		labeler.modulate=Color(1,1,1,q+split_time)
		q += split_time
		await create_timer_and_wait(time1/100.0)

func start_reverse_fade(time2:float) -> void:
	var q : float = 1.0
	for i in range(100):
		var split_time : float = time2/100.0
		$BorderLine/Label_Middle/RichTextLabel.modulate=Color(1,1,1,q-split_time)
		$BorderLine/Label_Middle/RichTextLabel2.modulate=Color(1,1,1,q-split_time)
		$BorderLine/Label_Middle/RichTextLabel3.modulate=Color(1,1,1,q-split_time)
		q -= split_time
		await create_timer_and_wait(split_time)
