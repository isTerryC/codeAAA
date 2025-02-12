extends Node
class_name GUIViewManager

@export var viewConfigList:Array[GUIViewConfig] = []
@export var GUIRoot:Node

var viewConfigMap := {}
var viewInstanceCount := 0
var viewInstanceMap := {}

func _ready() -> void:
	_build_view_config_map()

func _build_view_config_map():
	for config in viewConfigList:
		if config == null or config.id.is_empty():
			continue
		viewConfigMap[config.id] = config

func _get_view_config(viewId:StringName) -> GUIViewConfig:
	return viewConfigMap[viewId]

func _get_new_view_instance_id() -> int:
	var t = viewInstanceCount
	viewInstanceCount += 1
	return t

func _get_view_instance(viewInstanceId:int) -> BaseGUIView:
	return viewInstanceMap[viewInstanceId]

func open_view(viewID:StringName):
	var config := _get_view_config(viewID)
	var viewInstanceId := _get_new_view_instance_id()
	var prefab:PackedScene = config.prefab
	var v = prefab.instantiate() as BaseGUIView
	v.config = config
	v.viewInstanceId = viewInstanceId
	viewInstanceMap[viewInstanceId] = v
	GUIRoot.add_child(v)
	v.open()
	return viewInstanceId

func close_view(viewInstanceID:int):
	var v := _get_view_instance(viewInstanceID)
	v.close()
	viewInstanceMap.erase(viewInstanceID)
	v.queue_free()
