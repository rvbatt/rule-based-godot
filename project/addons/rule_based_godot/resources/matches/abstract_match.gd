class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

func is_satisfied(bindings: Dictionary) -> bool:
	# Abstract method
	push_error("Abstract Method Call")
	return false

func _read_number(number: Variant) -> float:
	if number is String:
		if number == "inf": return INF
		elif number == "-inf": return -INF
	return number

func _write_number(number: float) -> String:
	if number == INF: return "inf"
	elif number == -INF: return "-inf"
	else: return str(number)
