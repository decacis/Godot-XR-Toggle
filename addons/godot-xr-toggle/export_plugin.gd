@tool
extends EditorExportPlugin


const PATH_EXTENSION_DEF = "res://.godot/extension_list.cfg"

var gdextensions_exclude_list : Array
var extension_definition_buffer : String = "default"


func _get_name() -> String:
	return "GodotXRToggleExport"


func _export_begin(features : PackedStringArray, _is_debug : bool, _path : String, _flags : int) -> void:
	# GDExtension export disable
	var gdextension_exclude_platforms : Dictionary = ProjectSettings.get_setting("godot_xr_toggle/export/exclude_gdextensions_from_export", {})
	for platform_name : String in gdextension_exclude_platforms.keys():
		if features.has(platform_name):
			gdextensions_exclude_list = gdextension_exclude_platforms[platform_name]
	
	if not gdextensions_exclude_list.is_empty():
		var file_extension_list := FileAccess.open(PATH_EXTENSION_DEF, FileAccess.READ)
		var extensions : String = file_extension_list.get_as_text()
		file_extension_list.close()

		extension_definition_buffer = extensions
		
		var lines : PackedStringArray = extensions.split("\n")
		var extensions_without_excluded : String = ""
		
		for line in lines:
			for gdextension_name in gdextensions_exclude_list:
				if not gdextension_name in line:
					extensions_without_excluded += line + "\n"
		
		extensions_without_excluded = extensions_without_excluded.trim_suffix("\n")

		file_extension_list = FileAccess.open(PATH_EXTENSION_DEF, FileAccess.WRITE)
		file_extension_list.store_string(extensions_without_excluded)
		file_extension_list.close()
	
	# XR Mode force mode
	var force_mode_platforms : Dictionary = ProjectSettings.get_setting("godot_xr_toggle/export/platforms_force_mode", {})
	for platform_name : String in force_mode_platforms.keys():
		if features.has(platform_name):
			ProjectSettings.set_setting("xr/openxr/enabled", force_mode_platforms[platform_name])
			break


func _export_file(path : String, _type : String, _features : PackedStringArray) -> void:
	# Remove editor-only override file before exporting
	if path == "res://override.cfg":
		skip()
	
	# Skip predefined GDExtensions
	elif not gdextensions_exclude_list.is_empty():
		for gdextension_name in gdextensions_exclude_list:
			if gdextension_name in path:
				gdextensions_exclude_list.erase(gdextension_name)
				skip()
				break

# Restore gdextension list
func _export_end() -> void:
	gdextensions_exclude_list.clear()
	if extension_definition_buffer != "default":
		var file_extension_list := FileAccess.open(PATH_EXTENSION_DEF, FileAccess.WRITE)
		file_extension_list.store_string(extension_definition_buffer)
		file_extension_list.close()
		extension_definition_buffer = "default"
