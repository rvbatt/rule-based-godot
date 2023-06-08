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
	var string = "IF " + condition.representation() + "\nTHEN "
	if not actions.is_empty():
		string += actions[0].representation()
		for i in range(1, actions.size()):
			string += ";" + actions[i].representation()
	string += ";"
	return string

func build_from_repr(representation: String) -> void:
	# Expects format as defined in representation()
	var condition_actions = representation.strip_escapes().\
			trim_prefix("IF ").split("THEN ")
	var condition_string = condition_actions[0]
	var actions_string = condition_actions[1]

	condition = AbstractMatch.new()
	condition.build_from_repr(condition_string)

	actions = []
	for action_string in actions_string.split(";", false):
		var new_action = AbstractAction.new()

		if action_string.match("Set *.* = *:*"):
			# Set setter.property = type:value
			new_action = SetPropertyAction.new()

		new_action.build_from_repr(action_string)
		actions.append(new_action)
