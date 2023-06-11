class_name Rule
extends Resource

@export var condition: AbstractMatch
@export var actions: Array[AbstractAction]

func _init():
	set_meta("RuleBasedGodot", true)

func setup(system_node: Node) -> void:
	condition.setup(system_node)
	for action in actions:
		action.setup(system_node)

func trigger_actions() -> Array:
	var results = []
	for action in actions:
		results.append(action.trigger())
	return results

func representation() -> String:
	# {'if': condition, 'then': [actions]}
	var string = '{"if": ' + condition.representation() + ', "then": ['
	if not actions.is_empty():
		string += actions[0].representation()
		for i in range(1, actions.size()):
			string += ', ' + actions[i].representation()
	string += ']}'
	return string

func build_from_repr(representation: Dictionary) -> void:
	# {'if': condition, 'then': [actions]}
	var condition_string = representation["if"]
	match condition_string[0]:
		"Area":
			condition = AreaDetectionMatch.new()
		"Distance":
			condition = DistanceMatch.new()
	condition.build_from_repr(condition_string)

	actions = []
	for action_string in representation["then"]:
		var new_action: AbstractAction
		match action_string[0]:
			"Set":
				new_action = SetPropertyAction.new()
		new_action.build_from_repr(action_string)
		actions.append(new_action)
