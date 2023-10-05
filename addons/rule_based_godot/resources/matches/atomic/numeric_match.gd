@tool
class_name NumericMatch
extends AbstractAtomicMatch

@export var min_value: float = 0
@export var max_value: float = 0

func _init():
	Get_Node_Data_Preset = true

func _data_satisfies_match(data: Variant) -> bool:
	if not (data is float or data is int): return false
	return (min_value <= data) and (data <= max_value)
