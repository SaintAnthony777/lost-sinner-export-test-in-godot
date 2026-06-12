extends State

@onready var halfrey_root: Boss_Root = $"../.."
@onready var halfrey: Boss_Visuals = $"../../Halfrey"

const ATTACK_LIST:Array=['Attack 1','Attack 2','Combo 1','Combo 2','Special Attack']
var Attack_1=Attack.new()
var Attack_2=Attack.new()
var Attack_3=Attack.new()
var Attack_4=Attack.new()
var Attack_5=Attack.new()
var Attack_array:=[]
var attack_picked:int
var previous_attack:=0

func enter() -> void:
	init_attacks()
	attack_picker()
	halfrey.dealt_attack=Attack_array[attack_picked]
	halfrey_root.aiming_at_player()

func physics_update(_delta) -> void:
	if !halfrey_root.is_alive:
		state_machine.change_state("Dying")
	state_logic()
func state_logic()->void:
	attack_check()
	
func attack_picker() -> void:
	attack_picked=randi_range(0,4)
	if attack_picked==previous_attack:
		attack_picked=randi_range(0,4)
	halfrey.Boss_motion("Attack",ATTACK_LIST[attack_picked])
	previous_attack=attack_picked
func attack_check()->void:
	await halfrey.animation_tree.animation_finished
	halfrey.isattacking=false
	state_machine.change_state("idle")

func init_attacks()->void:
	Attack_array.clear()
	Attack_1.create_attack(15.0,25.0,"Physical",3.0,0.0)
	Attack_array.append(Attack_1)
	Attack_2.create_attack(16.0,25.0,"Physical",3.0,0.0)
	Attack_array.append(Attack_2)
	Attack_3.create_attack(14.0,25.0,"Physical",3.0,0.0)
	Attack_array.append(Attack_3)
	Attack_4.create_attack(17.0,25.0,"Physical",3.0,0.0)
	Attack_array.append(Attack_4)
	Attack_5.create_attack(25.0,35.0,"Divine Divider",3.0,0.0)
	Attack_array.append(Attack_5)

func is_player_alive_check()->void:
	if !halfrey_root.target.character.is_alive:
		state_machine.change_state("idle")
