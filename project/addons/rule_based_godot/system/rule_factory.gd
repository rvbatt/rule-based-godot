extends Node
class_name RuleFactory

static func MATCHES() -> Dictionary:
	return {
	"String": StringMatch,
	"Numeric": NumericMatch,
	"Distance": DistanceMatch,
	"Area Detection": AreaDetectionMatch,
	"AND": ANDMatch,
	"OR": ORMatch,
	"NOT": NOTMatch
	}

static func ACTIONS() -> Dictionary:
	return {
	"Set Property": SetPropertyAction,
	"Call Method": CallMethodAction,
	"Emit Signal": EmitSignalAction
	}

static func create_rule(json_repr: Dictionary) -> Rule:
	# Representation: {"if": condition, "then": [actions]}
	if not json_repr.has("if") or not json_repr.has("then"):
		push_error(error_string(ERR_INVALID_PARAMETER))
		return null

	var new_rule = Rule.new()
	new_rule.condition = create_match(json_repr["if"])
	for action_repr in json_repr["then"]:
		new_rule.actions.append(create_action(action_repr))
	return new_rule

static func create_match(json_repr: Array) -> AbstractMatch:
	# Representation: ["Identifier", configuration]
	if json_repr.is_empty():
		push_error(error_string(ERR_INVALID_PARAMETER))
		return null

	var new_match: AbstractMatch
	match json_repr[0]:
		"Area Detection":
			new_match = AreaDetectionMatch.new()
		"Distance":
			new_match = DistanceMatch.new()
		"Numeric":
			new_match = NumericMatch.new()
		"String":
			new_match = StringMatch.new()
		"NOT":
			new_match = NOTMatch.new()
		"AND":
			new_match = ANDMatch.new()
		"OR":
			new_match = ORMatch.new()
		_:
			new_match = AbstractMatch.new()

	new_match.build_from_repr(json_repr)
	return new_match

static func create_action(json_repr: Array) -> AbstractAction:
	# Representation: ["Identifier", configuration]
	if json_repr.is_empty():
		push_error(error_string(ERR_INVALID_PARAMETER))
		return null

	var new_action: AbstractAction
	match json_repr[0]:
		"Set Property":
			new_action = SetPropertyAction.new()
		"Call Method":
			new_action = CallMethodAction.new()
		"Emit Signal":
			new_action = EmitSignalAction.new()
		_:
			new_action = AbstractAction.new()

	new_action.build_from_repr(json_repr)
	return new_action
