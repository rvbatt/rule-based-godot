class_name Rule
extends RuleBasedResource

@export var condition: AbstractMatch
@export var actions: Array[AbstractAction]

static func json_format() -> String:
	return '\
{"if":
		condition,
	"then": [
		actions
	]}'

func setup(system_node: Node) -> void:
	condition.setup(system_node)
	for action in actions:
		action.setup(system_node)

func to_json_string() -> String:
	# {"if": condition, "then": [actions]}
	var actions_string: String
	for action in actions:
		actions_string += action.to_json_string() + ", "
	return '{"if": ' + condition.to_json_string() + \
			', "then": [' + actions_string + ']}'

func build_from_repr(json_repr) -> void:
	# {"if": condition, "then": [actions]}
	if not json_repr.has("if") or not json_repr.has("then"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return

	condition = RuleFactory.create_match(json_repr["if"])
	actions = []
	for action_repr in json_repr["then"]:
		actions.append(RuleFactory.create_action(action_repr))

func trigger_actions() -> Array:
	var results = []
	for action in actions:
		results.append(action.trigger())
	return results
