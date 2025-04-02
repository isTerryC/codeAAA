extends Control

@onready var label: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainUI/MarginContainer/FunctionBar/Button_Archive.disabled = true
	$MainUI/MarginContainer/FunctionBar/Button_Files.disabled = true
	$MainUI/MarginContainer/FunctionBar/Button_Network.disabled = true
	if G.flag == 0:
		G.update_flag(1)
		label.show_popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mailbox_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/UI/mail.tscn")
