@tool
class_name StringMatch
extends AbstractAtomicMatch

@export var string_value := ""

func _init():
	Get_Node_Data_Preset = true

func _data_satisfies_match(data: Variant) -> bool:
	if not data is String: return false
	return data == string_value
