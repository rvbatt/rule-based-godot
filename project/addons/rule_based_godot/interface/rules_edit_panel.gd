@tool
extends VBoxContainer
class_name RulesEditPanel

signal rule_set_defined(rules_string)

func _ready():
	for match_name in RuleFactory.MATCHES():
		$Buttons/MatchButton.add_item(match_name)
	$Buttons/MatchButton.selected = 0

	for action_name in RuleFactory.ACTIONS():
		$Buttons/ActionButton.add_item(action_name)
	$Buttons/ActionButton.selected = 0

func _reset_edit():
	$CodeEdit.text = $CodeEdit.placeholder_text

func set_code(rules_code: String):
	$CodeEdit.text = rules_code

func _apply_rules_string():
	var rules_string = $CodeEdit.text
	var rules_repr = JSON.parse_string(rules_string)
	if rules_repr == null:
		push_error("ParserError in Rules Editor")
		return
	if rules_repr is Dictionary and rules_repr.has("Rules"):
		emit_signal("rule_set_defined", rules_string)

func _insert_new_rule():
	$CodeEdit.insert_text_at_caret(Rule.json_format())

func _insert_new_match(index: int):
	if $CodeEdit.get_selected_text() != "":
		$CodeEdit.delete_selection()
	var match_name = $Buttons/MatchButton.get_item_text(index)
	var match_type = RuleFactory.MATCHES()[match_name]
	$CodeEdit.insert_text_at_caret(match_type.json_format())
	$Buttons/MatchButton.selected = 0

func _insert_new_action(index: int):
	if $CodeEdit.get_selected_text() != "":
		$CodeEdit.delete_selection()
	var action_name = $Buttons/ActionButton.get_item_text(index)
	var action_type = RuleFactory.ACTIONS()[action_name]
	$CodeEdit.insert_text_at_caret(action_type.json_format())
	$Buttons/ActionButton.selected = 0
