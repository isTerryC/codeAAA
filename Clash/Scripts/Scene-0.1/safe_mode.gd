extends Control

@onready var label: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if G.flag == -1 or G.flag == 0:
		$MainUI/MarginContainer/FunctionBar/Button_Archive.disabled = true
		$MainUI/MarginContainer/FunctionBar/Button_Network.disabled = true
		$MainUI/MarginContainer/FunctionBar/Button_Command.disabled = true
		G.update_flag(0)
	elif G.flag >0 and G.c == 0:
		$MainUI/MarginContainer/FunctionBar/Button_Archive.disabled = false
		$MainUI/MarginContainer/FunctionBar/Button_Network.disabled = false
		$MainUI/MarginContainer/FunctionBar/Button_Command.disabled = false
		label.show_popup()
		G.add_c()
	else:
		$MainUI/MarginContainer/FunctionBar/Button_Archive.disabled = false
		$MainUI/MarginContainer/FunctionBar/Button_Network.disabled = false
		$MainUI/MarginContainer/FunctionBar/Button_Command.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mailbox_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/UI/mail.tscn")


func _on_button_command_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/cmd/cmd.tscn")


func _on_button_network_pressed() -> void:
	if(G.scannable == 1):
		get_tree().change_scene_to_file("res://Clash/Scenes/cmd/scan.tscn")
	else:
		get_tree().change_scene_to_file("res://Clash/Scenes/cmd/scan_none.tscn")


func _on_button_archive_pressed() -> void:
	get_tree().change_scene_to_file("res://Clash/Scenes/boss/SQL.tscn")
