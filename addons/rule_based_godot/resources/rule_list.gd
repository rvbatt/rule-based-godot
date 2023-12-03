class_name RuleList
extends RuleBasedResource
# The list of rules orderd by priority, descending

# # Identifier for the RulesFormatSaver
@export var _rule_based_godot := &"RuleList"

@export var rules: Array[Rule] = []:
	set(array):
		rules = array
		for rule in rules:
			rule.set_factory(self._rule_db)

func _init():
	# All the rules and components will reference the RuleList factory
	_rule_db = RuleDB.new()

func set_factory(rule_db: RuleDB) -> void:
	_rule_db = rule_db
	for rule in rules:
		rule.set_factory(_rule_db)

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
		var new_rule = _rule_db.rule_from_json(rule_repr)
		rules.append(new_rule)

func satisfied_rules() -> Array[Rule]:
	var satisfied: Array[Rule] = []
	for rule in rules:
		if rule.condition_satisfied():
			satisfied.append(rule)
	return satisfied
