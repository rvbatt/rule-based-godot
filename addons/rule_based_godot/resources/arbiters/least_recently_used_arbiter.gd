class_name LeastRecentlyUsedArbiter
extends AbstractArbiter

var _recent_rules: Array[Rule] = []

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	# If this is the first time, use First Applicable
	if _recent_rules.is_empty():
		_recent_rules.append(satisfied_rules[0])
		return satisfied_rules[0]

	var last_used_index = INF
	for rule in satisfied_rules:
		var recent_index = _recent_rules.find(rule)
		if recent_index == -1:
			_recent_rules.append(rule)
			return rule
		if recent_index < last_used_index:
			last_used_index = recent_index

	var selected_rule = _recent_rules.pop_at(last_used_index)
	_recent_rules.append(selected_rule)
	return selected_rule
