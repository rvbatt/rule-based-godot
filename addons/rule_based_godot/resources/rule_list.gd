class_name RuleList
extends RuleBasedResource
# The list of rules orderd by priority, descending

# # Identifier for the RulesFormatSaver
@export var _rule_based_godot: StringName = &"RuleList"

@export var rules: Array[Rule] = []:
	set(array):
		rules = array
		for rule in rules:
			rule.set_factory(self._rule_factory)

func _init():
	# All the rules and components will reference the RuleList factory
	_rule_factory = RuleFactory.new()

func set_factory(rule_factory: RuleFactory) -> void:
	_rule_factory = rule_factory
	for rule in rules:
		rule.set_factory(_rule_factory)

func setup(system_node: RuleBasedSystem) -> void:
	for rule in rules:
		rule.setup(system_node)

func json_format() -> String:
	return '\
{"Rules": [
	rules
]}'

func to_json_repr() -> Variant:
	# {"Rules": [rules]}
	var rules_array := []
	for rule in rules:
		rules_array.append(rule.to_json_repr())
	return {"Rules": rules_array}

func build_from_repr(json_repr) -> void:
	# {"Rules": [rules]}
	if not json_repr.has("Rules"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return

	rules = []
	for rule_repr in json_repr["Rules"]:
		var new_rule = _rule_factory.build_rule(rule_repr)
		rules.append(new_rule)

func satisfied_rules() -> Array[Rule]:
	var satisfied: Array[Rule] = []
	for rule in rules:
		if rule.condition_satisfied():
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

