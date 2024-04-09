@tool

extends Node

enum CellType {
	None,
	Room,
	Hallway,
	Stairs
}

class Room:
	var bounds: AABB

	func _init(location, size):
		bounds = AABB(location, size)

	static func intersect(a:Room, b:Room):
		return !((a.bounds.position.x >= (b.bounds.position.x + b.bounds.size.x)) || ((a.bounds.position.x + a.bounds.size.x) <= b.bounds.position.x)
			|| (a.bounds.position.y >= (b.bounds.position.y + b.bounds.size.y)) || ((a.bounds.position.y + a.bounds.size.y) <= b.bounds.position.y)
			|| (a.bounds.position.z >= (b.bounds.position.z + b.bounds.size.z)) || ((a.bounds.position.z + a.bounds.size.z) <= b.bounds.position.z))

@export var size: Vector3i = Vector3i(30,30,30)
@export var roomCount: int = 30
@export var roomMaxSize: Vector3i = Vector3i(4,4,4)
@export var roomMinSize: Vector3i = Vector3i(2,2,2)
var rooms: Array[Room] = []
var delaunay
var selectedEdges: Dictionary = {}

@onready var grid = $GridMap
@export var start : bool = false : set = set_start
func set_start(_val:bool)->void:
	if Engine.is_editor_hint():
		place_rooms()

func _ready():
	place_rooms()
	#triangulate()
	#create_hallways()
	#path_find_hallways()

func place_rooms():
	grid.clear()
	for i in range(roomCount):
		var location = Vector3i(randi_range(0, size.x), randi_range(0, size.y), randi_range(0, size.z))
		var roomSize = Vector3i(randi_range(roomMinSize.x, roomMaxSize.x + 1), randi_range(roomMinSize.y, roomMaxSize.y + 1), randi_range(roomMinSize.z, roomMaxSize.z + 1))
		var add = true
		var newRoom = Room.new(location, roomSize)
		var buffer = Room.new(location + Vector3i(-1, 0, -1), roomSize + Vector3i(2, 0, 2))
		
		for room in rooms:
			if Room.intersect(room, buffer):
				add = false
				break
		
		if newRoom.bounds.position.x < 0 or newRoom.bounds.position.x >= size.x or\
		   newRoom.bounds.position.y < 0 or newRoom.bounds.position.y >= size.y or \
		   newRoom.bounds.position.z < 0 or newRoom.bounds.position.z >= size.z:
			add = false
		
		if add:
			rooms.append(newRoom)
			place_cube(newRoom.bounds.position,roomSize)

func place_cube(position:Vector3i,size:Vector3i):
	for x in range(position.x, position.x + size.x):
		for y in range(position.y, position.y + size.y):
			for z in range(position.z, position.z + size.z):
				var grid_position = Vector3i(x, y, z)
				grid.set_cell_item(grid_position, 2)
