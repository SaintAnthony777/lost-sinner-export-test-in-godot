class_name Openable_Gate extends Node3D

@export var opened_angles:Dictionary

@onready var gate_animation:AnimationPlayer=$"Door animation"
@onready var personnage:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var opening_side:=""
@onready var interacted:bool=false
@onready var player_pos:Marker3D=$Playerposition
@onready var gate_left:MeshInstance3D=$"Door left"
@onready var gate_right:MeshInstance3D=$"Door Right"
@onready var door_id:String=String(get_path())
@onready var inter_area:interaction_area

func _ready() -> void:
	if door_id in SaveManager.current_save.opened_doors_list.keys():
		Opened_door_state(SaveManager.current_save.opened_doors_list.get(self.door_id))
		
func _process(delta: float) -> void:
	if (opening_side!="" and !interacted and Input.is_action_just_pressed("Action trigger") and !personnage.is_busy and
	 inter_area and inter_area.interact==self):
		interacted=true
		if not door_id in SaveManager.current_save.opened_doors_list.keys():
			SaveManager.current_save.opened_doors_list.set(door_id,opening_side)
		for area in self.get_children():
			if area is interaction_area:
				area.disable_all_collsion()
			gate_animation.play("Open from "+opening_side)
		

func Opened_door_state(Side:String)->void:
	interacted=true
	gate_left.rotation_degrees.y=opened_angles[Side][0]
	gate_right.rotation_degrees.y=opened_angles[Side][1]
	
func opened_door()->void:
	interacted=true
