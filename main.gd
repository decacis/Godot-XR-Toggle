extends Node3D

const NON_VR_PLAYER : PackedScene = preload("res://player/non-vr/non-vr-player.tscn")
const VR_PLAYER : PackedScene = preload("res://player/vr/vr-player.tscn")

var openxr_enabled : bool = false


func _ready() -> void:
	# Get command line arguments
	var args : PackedStringArray = OS.get_cmdline_args()
	
	# Is OpenXR enabled? (Editor)
	if OS.has_feature("editor"):
		openxr_enabled = ProjectSettings.get_setting("xr/openxr/enabled", false)
	
	# Release/debug build
	else:
		var xr_interface : XRInterface = XRServer.find_interface("OpenXR")
		if xr_interface and xr_interface.is_initialized():
			openxr_enabled = true
		
		if args.has("--restart-with-xr") and not openxr_enabled:
			print("Failed to start OpenXR")
	
	print("OpenXR Enabled: ", openxr_enabled)
	
	var player_scene : Node3D
	if not openxr_enabled:
		player_scene = NON_VR_PLAYER.instantiate()
		# Connect Desktop UI button
		player_scene.request_xr_restart.connect(_restart_with_xr)
	else:
		player_scene = VR_PLAYER.instantiate()
	
	add_child(player_scene)


func _restart_with_xr() -> void:
	# Only runs when exported (either debug or release)
	if OS.has_feature("template"):
		OS.set_restart_on_exit(true, ["--xr-mode", "on", "--restart-with-xr"])
		get_tree().quit()
