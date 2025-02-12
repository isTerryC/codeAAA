extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainUI/MarginContainer/FunctionBar/Button_Archive.disabled = true
	$MainUI/MarginContainer/FunctionBar/Button_Files.disabled = true
	$MainUI/MarginContainer/FunctionBar/Button_Network.disabled = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
