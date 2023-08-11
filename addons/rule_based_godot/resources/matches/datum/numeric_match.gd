@tool
class_name NumericMatch
extends DatumMatch

@export var min_value: float
@export var max_value: float

func _init():
	Data_Extraction = true

func _data_satisfies_match(data: Variant) -> bool:
	if (not data is float) and (not data is int): return false
	return (min_value <= data) and (data <= max_value)
