@tool
extends VBoxContainer
class_name RulesEditorPanel

signal rule_set_defined(rules_string)

var rule_factory := RuleFactory.new()

func _ready():
	$CodeEdit.syntax_highlighter.keyword_colors = {
		"Rules": Color(1, 0.69803923368454, 0.45098039507866),
		"if": Color(0.40000000596046, 0.89803922176361, 1),
		"then": Color(0.40000000596046, 0.89803922176361, 1),
	}
	$CodeEdit.syntax_highlighter.function_color = Color(0.38823530077934, 0.76078432798386, 0.34901961684227)

	$Buttons/MatchButton.clear()
	$Buttons/MatchButton.add_separator("New Match")
	for match_name in rule_factory.matches:
		$Buttons/MatchButton.add_item(match_name)
		$CodeEdit.syntax_highlighter.keyword_colors[match_name] = Color(1, 0.43921568989754, 0.52156865596771)
	$Buttons/MatchButton.selected = 0

	$Buttons/ActionButton.clear()
	$Buttons/ActionButton.add_separator("New Action")
	for action_name in rule_factory.actions:
		$Buttons/ActionButton.add_item(action_name)
		$CodeEdit.syntax_highlighter.keyword_colors[action_name] = Color(1, 0.54901963472366, 0.80000001192093)
	$Buttons/ActionButton.selected = 0

func _reset_edit():
	$CodeEdit.text = $CodeEdit.placeholder_text

func _apply_rules_string():
	var rules_string = $CodeEdit.text
	var rules_repr = JSON.parse_string(rules_string)
	if rules_repr == null:
		push_error("ParserError in Rules Editor")
		return
	if rules_repr is Dictionary and rules_repr.has("Rules"):
		emit_signal("rule_set_defined", rules_string)

func _insert_new_rule():
	$CodeEdit.delete_selection()
	$CodeEdit.insert_text_at_caret(rule_factory.get_rule_format())

func _insert_new_match(index: int):
	$CodeEdit.delete_selection()

	var match_name = $Buttons/MatchButton.get_item_text(index)
	$CodeEdit.insert_text_at_caret(rule_factory.get_match_format(match_name))
	$Buttons/MatchButton.selected = 0

func _insert_new_action(index: int):
	$CodeEdit.delete_selection()

	var action_name = $Buttons/ActionButton.get_item_text(index)
	$CodeEdit.insert_text_at_caret(rule_factory.get_action_format(action_name))
	$Buttons/ActionButton.selected = 0
