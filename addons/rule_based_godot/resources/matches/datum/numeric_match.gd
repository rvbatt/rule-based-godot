@tool
class_name NumericMatch
extends DatumMatch

@export var min_value: float
@export var max_value: float

static func json_format() -> String:
	return '["Numeric", min, max, "?var|node", "property" | "method", {"types": "arguments"}]'

func _init():
	Data_Extraction = true
	match_id = "Numeric"
	repr_vars = ["min_value", "max_value"]

func _data_satisfies_match(data: Variant) -> bool:
	if not data is float or data is int: return false
	return (min_value <= data) and (data <= max_value)
