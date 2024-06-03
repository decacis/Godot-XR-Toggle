extends Node3D

signal request_xr_restart

@export var height : float = 1.7 :
	get:
		return height
	set(value):
		height = value
		if not Engine.is_editor_hint():
			_handle_height()

@export var sensitivity : float = 0.005

@onready var head_pivot : Node3D = %HeadPivot
@onready var camera : Camera3D = %Camera3D
# Only works when the project is exported
@onready var restart_xr_btn : Button = %RestartXRBtn


func _ready() -> void:
	_handle_height()
	
	restart_xr_btn.pressed.connect(func():
		request_xr_restart.emit()
	)


func _handle_height() -> void:
	head_pivot.position.y = height


func _process(_delta : float) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED \
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE \
		else Input.MOUSE_MODE_VISIBLE
		

func _input(event) -> void:
	if event is InputEventMouseMotion:
		var ev : InputEventMouseMotion = event
		head_pivot.rotate_y(-ev.relative.x * sensitivity)
		camera.rotate_x(-ev.relative.y * sensitivity)
		
		camera.rotation.x = clampf(camera.rotation.x, -PI/2.0, PI/2.0)
