class_name ANDMatch
extends AbstractMultiBoolMatch

func is_satisfied(bindings: Dictionary) -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied(bindings):
			return false

	return true
