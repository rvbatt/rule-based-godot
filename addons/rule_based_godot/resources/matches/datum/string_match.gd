@tool
class_name StringMatch
extends DatumMatch

@export var string_value: String = ""

func _init():
	Data_Extraction = true
	repr_vars = ["string_value"]

func _data_satisfies_match(data: Variant) -> bool:
	if not data is String: return false
	return data == string_value
