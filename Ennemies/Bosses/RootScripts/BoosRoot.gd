class_name Boss_Root extends enemy_root

var isactive:bool
var Boss_name:String
var boss_vis:Boss_Visuals
@onready var nav_agent:NavigationAgent3D=get_node("NavigationAgent3D")
@onready var Boss_hud:CanvasLayer=get_node("HealthBar canvas")
