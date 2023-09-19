class_name NOTMatch
extends AbstractMatch

@export var negated_condition: AbstractMatch

func set_factory(rule_factory: RuleFactory) -> void:
	_rule_factory = rule_factory
	negated_condition.set_factory(rule_factory)

func setup(system_node: RuleBasedSystem) -> void:
	if negated_condition != null:
		negated_condition.setup(system_node)

func json_format() -> String:
	return '["NOT", condition]'

func to_json_repr() -> Variant:
	# ["NOT", condition]
	return ["NOT", negated_condition.to_json_repr()]

func build_from_repr(json_repr) -> void:
	# ["NOT", condition]
	negated_condition = _rule_factory.build_match(json_repr[1])

func is_satisfied(bindings: Dictionary) -> bool:
	if negated_condition == null:
		print_debug("Empty NOTMatch")
		return false
	else:
		return not (negated_condition.is_satisfied(bindings))
