class_name interaction_area extends Area3D

@export var required_item : String
@export var deny_text : String
@export var side_for_doors : String
@export var gate_owner : Openable_Gate
@export var interaction_type : String
@export var current_interaction : String
@export var saveplace:SavePoint
@export var player_marker : Marker3D 
@export var player_look_at : Marker3D
@export var pickable_owner : pickable



@onready var Hint:Label3D=$Hint
@onready var interaction_text : Label3D = $"Interaction Text"
@onready var collsion_shape : CollisionShape3D = get_node("CollisionShape3D")
@onready var player_is_in_area : bool = false
@onready var player:player_character=get_tree().get_first_node_in_group("Personnage")
@onready var interact

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
			player.character.character_user_prompt_guide.hide()
		else :
			if required_item and !player.player_inventory.has_the_item(required_item,1): 
				player.character.character_user_prompt_guide.can_interact_container.hide()
				player.character.character_user_prompt_guide.unable_to_interact.show()
				player.character.character_user_prompt_guide.unable_to_interact_text.text = deny_text
				player.can_interact = false
			else :
				player.character.character_user_prompt_guide.unable_to_interact.hide()
				player.character.character_user_prompt_guide.can_interact_container.show()
				player.character.character_user_prompt_guide.prompt_text.text = current_interaction
				player.can_interact = true
	else : 
		if pickable_owner:
			Hint.visible=pickable_owner.interacted
		else:
			Hint.visible=!owner.interacted

func _on_body_entered(body: Node3D) -> void:
	if body is player_character : interact = $".."
	if body is player_character and !interact.interacted:
		interact.inter_area = self
		player_is_in_area = true
		if player_marker:
			player_marker.global_position = self.global_position
			player.marker_forced_pos = player_marker
		player.interaction_type = interaction_type
		if player_look_at : player.player_look_node=player_look_at
		player.can_interact=true
		body.Interaction_side = side_for_doors
		player.character.character_user_prompt_guide.show()
		Hint.hide()
	if saveplace:
		player.save_location=saveplace.save_place_name
	if gate_owner :
		gate_owner.opening_side=side_for_doors
		
func _on_body_exited(body: Node3D) -> void:
	interact = owner
	player.character.character_user_prompt_guide.hide()
	
	if body is player_character :
		if interact:
			interact.inter_area=null
		player_is_in_area=false
		player.can_interact=false
		interaction_text.hide()
		if interact and !interact.interacted:
			Hint.show()

func disable_all_collsion()->void:
	collsion_shape.disabled = true
func enable_all_collision()->void:
	collsion_shape.disabled=false
