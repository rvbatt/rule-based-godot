@tool
extends VBoxContainer
# Rules Editor bottom panel

signal rule_list_defined(rules_string)

@export var rules_color := Color.SANDY_BROWN
@export var if_then_color := Color.AQUAMARINE
@export var match_color := Color.LIGHT_CORAL
@export var action_color := Color.PINK
@export var type_color := Color.SPRING_GREEN

var _rule_db := RuleDB.new()

func _ready():
	$CodeEdit.syntax_highlighter.keyword_colors = {
		"Rules": rules_color,
		"if": if_then_color,
		"then": if_then_color,
	}
	$CodeEdit.syntax_highlighter.function_color = type_color

	$Buttons/MatchButton.clear()
	$Buttons/MatchButton.add_separator("New Match")
	for match_name in _rule_db.matches:
		$Buttons/MatchButton.add_item(match_name)
		$CodeEdit.syntax_highlighter.keyword_colors[match_name] = match_color
	$Buttons/MatchButton.selected = 0

	$Buttons/ActionButton.clear()
	$Buttons/ActionButton.add_separator("New Action")
	for action_name in _rule_db.actions:
		$Buttons/ActionButton.add_item(action_name)
		$CodeEdit.syntax_highlighter.keyword_colors[action_name] = action_color
	$Buttons/ActionButton.selected = 0

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_rule_db.free()

func _reset_edit():
	$CodeEdit.text = $CodeEdit.placeholder_text

func _apply_rules_string():
	var rules_string = $CodeEdit.text
	var rules_repr = JSON.parse_string(rules_string)
	if rules_repr == null:
		push_error("ParserError in Rules Editor")
		return
	if rules_repr is Dictionary and rules_repr.has("Rules"):
		emit_signal("rule_list_defined", rules_string)

func _insert_new_rule():
	$CodeEdit.delete_selection()
	$CodeEdit.insert_text_at_caret(_rule_db.get_rule_format())

func _insert_new_match(index: int):
	$CodeEdit.delete_selection()

	var match_name = $Buttons/MatchButton.get_item_text(index)
	$CodeEdit.insert_text_at_caret(_rule_db.get_match_format(match_name))
	$Buttons/MatchButton.selected = 0

func _insert_new_action(index: int):
	$CodeEdit.delete_selection()

	var action_name = $Buttons/ActionButton.get_item_text(index)
	$CodeEdit.insert_text_at_caret(_rule_db.get_action_format(action_name))
	$Buttons/ActionButton.selected = 0
