extends Node3D

var wing_material:=preload("res://Character/materials/wings_material.tres")
var rune_material:=preload("res://Character/materials/feet_burst_rune.tres")
var wing_mesh:=preload("res://Character/meshes/wings_mesh.tres")
var angel_rune:=preload("res://Character/meshes/rune_plane.tres")
var material_array:Array[StandardMaterial3D]
var mesh_array:Array[ArrayMesh]

func _ready() -> void:
	pass
func load_ressources()->void:
	pass
	
