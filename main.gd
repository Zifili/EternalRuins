@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap
@export var generate : bool = false
@export var seed : int = 0
@export var max_size : Vector3i = Vector3i(6,0,6)

var dungeon : Array = []

func _process(delta):
	if Engine.is_editor_hint() and generate: #start generation
		generate = false
		gen_border()
		seed(seed)
		var rooms : int = randi_range(1,3)
		for i in range(rooms):
			var room_z : int = (randi_range(1,max_size.z-2))
			var room_x : int = (randi_range(1,max_size.x-2))
			#var room_size : Vector3i = Vector3i(room_x,0,room_z)
			#var top_corner : int = randi() % (max_size.x*max_size.z)
			#draw_room(room_size, top_corner)
			grid_map.set_cell_item(Vector3i(room_x,0,room_z),2)

func gen_border():
	grid_map.clear()
	var z : int = max_size.z-1
	for i in range(max_size.z):
		grid_map.set_cell_item(Vector3i(0,0,i), 0)
		grid_map.set_cell_item(Vector3i(i,0,0), 0)
		grid_map.set_cell_item(Vector3i(i,0,z), 0)
		grid_map.set_cell_item(Vector3i(z,0,i), 0)

func draw_room(size:Vector3i, top_corner:int):
	for i in range(size.z):
		pass
