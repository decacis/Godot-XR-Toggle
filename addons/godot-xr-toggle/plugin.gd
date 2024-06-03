@tool
extends EditorPlugin

var xr_toggle : CheckButton
var export_plugin : EditorExportPlugin


func _define_project_setting(
		p_name : String,
		p_type : int,
		p_hint : int = PROPERTY_HINT_NONE,
		p_hint_string : String = "",
		p_default_val = "") -> void:
	# p_default_val can be any type!!

	if !ProjectSettings.has_setting(p_name):
		ProjectSettings.set_setting(p_name, p_default_val)

	var property_info : Dictionary = {
		"name" : p_name,
		"type" : p_type,
		"hint" : p_hint,
		"hint_string" : p_hint_string
	}

	ProjectSettings.add_property_info(property_info)
	if ProjectSettings.has_method("set_as_basic"):
		ProjectSettings.call("set_as_basic", p_name, true)
	ProjectSettings.set_initial_value(p_name, p_default_val)


func _enter_tree() -> void:
	_create_export_plugin()
	_create_toggle_control()
	
	# Add input grip threshold to the project settings
	_define_project_setting(
			"godot_xr_toggle/export/platforms_force_mode",
			TYPE_DICTIONARY,
			PROPERTY_HINT_NONE ,
			"",
			{"android": true})
	
	add_export_plugin(export_plugin)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, xr_toggle)
	
	# Initialize
	_toggle_xr_mode(xr_toggle.button_pressed)


func _create_export_plugin() -> void:
	if not export_plugin:
		export_plugin = EditorExportPlugin.new()
		export_plugin.set_script(load("res://addons/godot-xr-toggle/export_plugin.gd"))

func _create_toggle_control() -> void:
	if not xr_toggle:
		xr_toggle = CheckButton.new()
		xr_toggle.text = "XR Enabled"
		xr_toggle.toggled.connect(_toggle_xr_mode)


func _toggle_xr_mode(toggled_on : bool) -> void:
	if FileAccess.file_exists("res://override.cfg"):
		DirAccess.remove_absolute("res://override.cfg")
	
	var config = ConfigFile.new()
	# Enable OpenXR
	config.set_value("xr", "openxr/enabled", toggled_on)
	# Save override file
	config.save("res://override.cfg")


func _exit_tree() -> void:
	if FileAccess.file_exists("res://override.cfg"):
		DirAccess.remove_absolute("res://override.cfg")
	
	if xr_toggle:
		xr_toggle.queue_free()
	
	remove_export_plugin(export_plugin)
	export_plugin = null
