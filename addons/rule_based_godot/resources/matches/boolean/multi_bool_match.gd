class_name MultiBoolMatch
extends AbstractMatch
# Abstract class for multiple-input boolean matches

@export var subconditions: Array[AbstractMatch]
var _rule_factory: RuleFactory

func setup(system_node: RuleBasedSystem, rule_factory: RuleFactory = null) -> void:
	_rule_factory = rule_factory
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node, rule_factory)

func json_format() -> String:
	# ["ID", [conditions]]
	return '["' + _resource_id() + '", [conditions]]'

func to_json_repr() -> Variant:
	# ["ID", [conditions]]
	var conditions_array := []
	for condition in subconditions:
		conditions_array.append(condition.to_json_repr())
	return [_resource_id(), conditions_array]

func build_from_repr(json_repr) -> void:
	# ["ID", [conditions]]
	subconditions = []
	for match_repr in json_repr[1]:
		var new_condition = _rule_factory.build_match(match_repr)
		subconditions.append(new_condition)
