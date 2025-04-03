extends Node

func get_game_root() -> Node:
	return get_node("/root/game")

func get_gui_view_manager() -> GUIViewManager:
	return get_game_root().get_node("%GUIViewManager")


# 在全局工具脚本中（如 G.gd）
func load_hack_scene(port: int) -> void:
	var scene_path = ""
	
	# 映射端口到场景
	match port:
		143:
			scene_path = "res://Clash/Scenes/boss/SQL.tscn"
		21:
			scene_path = "res://Clash/Scenes/boss/stack1.tscn"
		22:
			scene_path = "res://Clash/Scenes/boss/none.tscn"
		_:
			push_error("未知端口：%d" % port)
			return
	
	# 异步加载场景
	var loader = ResourceLoader.load_threaded_request(scene_path)
	if loader != OK:
		push_error("场景加载失败：%s" % scene_path)
		return
	
	# 等待加载完成
	while ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	
	# 实例化并添加场景
	var scene = ResourceLoader.load_threaded_get(scene_path)
	if scene:
		var instance = scene.instantiate()
		get_tree().root.add_child(instance)
		# 延迟初始化
		instance.call_deferred("initialize")
	else:
		push_error("场景实例化失败：%s" % scene_path)



	# 邮箱 Mail 相关代码
signal flag_changed
	
var flag:int = -1
var c: int = 0
var end: int = 0
var hide: int = 0
	
func update_flag(new_flag: int) -> void:
	flag = new_flag
	c = 0
	# 当 flag 变化时，发出信号
	if flag == 6:
		end = 1
	flag_changed.emit()
	
func add_c() -> void:
	c = 1
	
func find_hide() -> void:
	hide = 1
	
var scannable := 0
var _scannable_timer: Timer = null

func set_scannable_temporary() -> void:
	scannable = 1
	
	if _scannable_timer:
		_scannable_timer.stop()
		_scannable_timer.queue_free()
	
	_scannable_timer = Timer.new()
	_scannable_timer.wait_time = 10.0
	_scannable_timer.one_shot = true
	
	_scannable_timer.timeout.connect(_on_scannable_timeout)
	
	add_child(_scannable_timer)
	_scannable_timer.start()

func _on_scannable_timeout() -> void:
	scannable = 0
	if _scannable_timer:
		_scannable_timer.queue_free()
		_scannable_timer = null
