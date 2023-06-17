class_name RuleSet
extends RuleBasedResource

@export var rules: Array[Rule]

func _init():
	set_meta("RuleBasedGodot", true)

func setup(system_node: Node) -> void:
	for rule in rules:
		rule.setup(system_node)

func to_json_string() -> String:
	# {"Rules": [rules]}
	var rules_repr: String
	for rule in rules:
		rules_repr += rule.to_json_string() + ", "

	return '{"Rules": [' + rules_repr + ']}'

func build_from_repr(json_repr) -> void:
	# {"Rules": [rules]}
	if not json_repr.has("Rules"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return

	rules = []
	for rule_repr in json_repr["Rules"]:
		var new_rule = RuleFactory.create_rule(rule_repr)
		rules.append(new_rule)

func satisfied_rules() -> Array[Rule]:
	var satisfied: Array[Rule] = []
	for rule in rules:
		if rule.condition.is_satisfied():
			satisfied.append(rule)
	return satisfied

func add_rule(rule: Rule) -> void:
	if rule in rules: return
	rules.append(rule)

func add_rules(rules: Array[Rule]) -> void:
	for rule in rules:
		add_rule(rule)

func remove_rule_by_name(rule_name: StringName) -> void:
	for rule in rules:
		if rule.resource_name == rule_name:
			rules.erase(rule)
			break

func get_rule_by_name(rule_name: StringName) -> Rule:
	for rule in rules:
		if rule.resource_name == rule_name:
			return rule
	return null

