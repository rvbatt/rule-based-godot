class_name ANDMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch] = []
# We can't set a default value for subconditions in _init,
# because the resource tree is constructed from bottom up,
# so its children will be already initialized

func set_system_node(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.set_system_node(system_node)

func is_satisfied() -> bool:
	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied():
			return false

	return true
