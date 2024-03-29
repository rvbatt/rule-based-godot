class_name RuleDB
extends Object
# Uses Factory method to build Matches, Actions and Rules
# from JSON representations

var actions: Dictionary:
	set(value):
		if _can_edit:
			actions = value

var matches: Dictionary:
	set(value):
		if _can_edit:
			matches = value

var _can_edit := true

func _init():
	var all_classes = ProjectSettings.get_global_class_list()
	matches = _id_to_script_dict(all_classes,
		func(class_dict):
			return class_dict["base"] == "AbstractAtomicMatch" or \
				class_dict["base"] == "AbstractBooleanMatch" or \
				class_dict["class"] == "NOTMatch"
	)
	actions = _id_to_script_dict(all_classes,
		func(class_dict): return class_dict["base"] == "AbstractAction"
	)
	_can_edit = false

func match_from_json(json_repr: Array) -> AbstractMatch:
	# Representation: ["Identifier", configuration]
	if json_repr.is_empty():
		print_debug("Invalid match representation")
		return AbstractMatch.new()

	var match_script: Script = matches.get(json_repr[0])
	if match_script == null:
		print_debug("Invalid match ID")
		return AbstractMatch.new()

	var new_match: AbstractMatch = match_script.new()
	new_match.set_factory(self)
	new_match.build_from_repr(json_repr)
	return new_match

func get_match_format(match_id: String) -> String:
	var match_script: Script = matches.get(match_id)
	if match_script == null:
		print_debug("Invalid match ID")
		return ""

	return match_script.new().json_format()

func action_from_json(json_repr: Array) -> AbstractAction:
	# Representation: ["Identifier", configuration]
	if json_repr.is_empty():
		print_debug("Invalid action representation")
		return AbstractAction.new()

	var action_script: Script = actions.get(json_repr[0])
	if action_script == null:
		print_debug("Invalid action ID")
		return AbstractAction.new()

	var new_action: AbstractAction = action_script.new()
	new_action.set_factory(self)
	new_action.build_from_repr(json_repr)
	return new_action

func get_action_format(action_id: String) -> String:
	var action_script: Script = actions.get(action_id)
	if action_script == null:
		print_debug("Invalid action ID")
		return ""

	return action_script.new().json_format()

func rule_from_json(json_repr: Dictionary) -> Rule:
	# Representation: {"if": condition, "then": [actions]}
	if not json_repr.has("if") or not json_repr.has("then"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return null

	var new_rule = Rule.new()
	new_rule.set_factory(self)
	new_rule.condition = match_from_json(json_repr["if"])
	for action_repr in json_repr["then"]:
		new_rule.actions.append(action_from_json(action_repr))
	return new_rule

func get_rule_format() -> String:
	return Rule.new().json_format()

func _id_to_script_dict(classes: Array[Dictionary], filter: Callable) -> Dictionary:
	var id_to_path := {}
	for class_dict in classes.filter(filter):
		if not FileAccess.file_exists(class_dict["path"]):
			continue
		var id = class_dict["class"].trim_suffix("Match").trim_suffix("Action")
		id_to_path[id] = load(class_dict["path"])
	return id_to_path
