class_name Rule
extends RuleBasedResource
# Single rule in RuleList

@export var condition: AbstractMatch
@export var actions: Array[AbstractAction]

var _bindings: Dictionary # variable -> value
var _rule_factory: RuleFactory

func setup(system_node: RuleBasedSystem, rule_factory: RuleFactory = null) -> void:
	_rule_factory = rule_factory
	condition.setup(system_node, rule_factory)
	for action in actions:
		action.setup(system_node, rule_factory)

func json_format() -> String:
	return '\
{"if":
		condition,
	"then": [
		actions
	]}'

func to_json_repr() -> Variant:
	# {"if": condition, "then": [actions]}
	var actions_array := []
	for action in actions:
		actions_array.append(action.to_json_repr())
	return {"if": condition.to_json_repr(), "then": actions_array}

func build_from_repr(json_repr) -> void:
	# {"if": condition, "then": [actions]}
	if not json_repr.has("if") or not json_repr.has("then"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return

	condition = _rule_factory.build_match(json_repr["if"])
	actions = []
	for action_repr in json_repr["then"]:
		actions.append(_rule_factory.build_action(action_repr))

func condition_satisfied() -> bool:
	_bindings.clear()
	return condition.is_satisfied(_bindings)

func trigger_actions() -> Array:
	var results = []
	for action in actions:
		results.append(action.trigger(_bindings))

	return results
