class_name Rule
extends RuleBasedResource
# Single rule in RuleList

@export var condition: AbstractMatch = null
@export var actions: Array[AbstractAction] = []

var _bindings: Dictionary # variable -> value

func setup(system_node: RuleBasedSystem) -> void:
	condition.setup(system_node)
	for action in actions:
		action.setup(system_node)

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

	condition = _rule_db.match_from_json(json_repr["if"])
	actions = []
	for action_repr in json_repr["then"]:
		actions.append(_rule_db.action_from_json(action_repr))

func condition_satisfied() -> bool:
	_bindings.clear()
	return condition.is_satisfied(_bindings)

func trigger_actions() -> Array:
	var results = []
	for action in actions:
		results.append(action.trigger(_bindings))

	return results
