class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

var match_id: StringName # ID for json format

func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false

func to_json_repr() -> Variant:
	push_error("Abstract Method")
	return null

func build_from_repr(json_repr: Array) -> void:
	push_error("Abstract Method")
