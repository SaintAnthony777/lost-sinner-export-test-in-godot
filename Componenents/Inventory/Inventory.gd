class_name Inventory
extends Resource

@export var Inventory_list : Array[Inventory_Item]=[]

signal inventory_updated

func add_item(item:Inventory_Item, quantity : int) -> void:
	var item_entered:Inventory_Item= find_item_by_name(item.item_name)
	if item_entered and item_entered.is_stackable:
		item_entered.item_number+=quantity
	else:
		var duplicated_item := item
		duplicated_item.item_number+=quantity
		Inventory_list.append(duplicated_item)
	inventory_updated.emit()

func substract_item(item:Inventory_Item,number:int)->void:
	var item_to_be_deleted:=find_item_by_name(item.item_name)
	if not item_to_be_deleted:
		return
	item_to_be_deleted.item_number-=number
	if item_to_be_deleted.item_number<=0:
		Inventory_list.erase(item_to_be_deleted)
	inventory_updated.emit()


func find_item_by_name(target_name:String)->Inventory_Item:
	for item in Inventory_list:
		if item and item.item_name==target_name:
			return item
	return null

func has_the_item(item_name:String,requiered_qty:int) -> bool :
	var item = find_item_by_name(item_name)
	if item and item.item_number>=requiered_qty:
		return true
	return false
