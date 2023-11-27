@tool
class_name DistinctVariablesMatch
extends AbstractAtomicMatch

@export var distinct_variables: Array[StringName] = []

func _init():
	# Should the match check some Node?
	Tester_Node = false

# Should ONLY be implemented IF Tester_Node = false
func is_satisfied(bindings: Dictionary) -> bool:
	for i in range(distinct_variables.size()):
		var used_candidates = bindings.get(distinct_variables[i], [])
		if used_candidates.is_empty():
			return false

		var used = used_candidates[0]
		print("?", distinct_variables[i], " reserved: ", used)
		for j in range(i+1, distinct_variables.size()):
			var candidates = bindings.get(distinct_variables[j], [])
			candidates.erase(used)
			if candidates.is_empty():
				return false
	return true
