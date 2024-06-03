@tool
extends EditorExportPlugin


func _get_name() -> String:
	return "GodotXRToggleExport"


func _export_begin(features : PackedStringArray, _is_debug : bool, _path : String, _flags : int) -> void:
	
	var platforms_force_mode : Dictionary = ProjectSettings.get_setting("godot_xr_toggle/export/platforms_force_mode", [])
	for platform_name : String in platforms_force_mode.keys():
		if features.has(platform_name):
			ProjectSettings.set_setting("xr/openxr/enabled", platforms_force_mode[platform_name])
			break


func _export_file(path : String, _type : String, _features : PackedStringArray) -> void:
	# Remove editor-only override file before exporting
	if path == "res://override.cfg":
		skip()
