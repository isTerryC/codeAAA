extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_button_exit_pressed() -> void:
	return_to_main_ui()
		
	var mail_node = self
	if mail_node:
		mail_node.queue_free()
	
func return_to_main_ui():

	var main_ui = get_tree().get_root().get_node("MAIN")
	main_ui.visible = true
	
