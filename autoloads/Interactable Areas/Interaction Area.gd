class_name interaction_area extends Area3D

@export var side_for_doors : String
@export var gate_owner : Openable_Gate
@export var interaction_type : String
@export var current_interaction : String

@export var player_marker : Marker3D 
@export var player_look_at : Marker3D
@onready var Hint:Label3D=$Hint
@onready var interaction_text : Label3D = $"Interaction Text"
@onready var collsion_shape : CollisionShape3D = get_node("CollisionShape3D")
@onready var player_is_in_area : bool = false
@onready var player:player_character=get_tree().get_first_node_in_group("Personnage")

func _init() -> void:
	collision_layer=7
	collision_mask=1
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _process(delta: float) -> void:
	interaction_text.text = current_interaction
	if player_is_in_area:
		if player.is_busy:
			player.can_interact=false
			interaction_text.hide()
		else :
			player.can_interact=true
			interaction_text.show()
	else : Hint.visible=!owner.interacted

func _on_body_entered(body: Node3D) -> void:
	if body is player_character and !owner.interacted:
		player_is_in_area=true
		if player_marker:
			player_marker.global_position=self.global_position
			player.marker_forced_pos=player_marker
		player.interaction_type=interaction_type
		player.player_look_node=player_look_at
		player.can_interact=true
		body.Interaction_side=side_for_doors
		interaction_text.show()
		Hint.hide()
	if gate_owner :
		gate_owner.opening_side=side_for_doors

func _on_body_exited(body: Node3D) -> void:
	if body is player_character :
		player_is_in_area=false
		player.can_interact=false
		interaction_text.hide()
		if !owner.interacted:
			Hint.show()
func disable_all_collsion()->void:
	collsion_shape.disabled = true
func enable_all_collision()->void:
	collsion_shape.disabled=false
