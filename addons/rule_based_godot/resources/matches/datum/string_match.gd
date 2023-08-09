@tool
class_name StringMatch
extends DatumMatch

@export var string_value: String = ""

static func json_format() -> String:
	return '["String", "value", "?var|node", "property" | "method", {"types": "arguments"}]'

func _init():
	Data_Extraction = true
	match_id = "String"
	repr_vars = ["string_value"]

func _data_satisfies_match(data: Variant) -> bool:
	if not data is String: return false
	return data == string_value
