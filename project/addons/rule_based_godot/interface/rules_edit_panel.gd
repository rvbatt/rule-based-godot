@tool
extends VBoxContainer
class_name RulesEditPanel

signal rule_set_defined(rules_string)

func _clear_edit():
	$CodeEdit.text = ""

func _apply_rules_string():
	var rules_string = $CodeEdit.text
	var rules_repr = JSON.parse_string(rules_string)
	if rules_repr == null:
		return
	if rules_repr is Dictionary and rules_repr.has("Rules"):
		emit_signal("rule_set_defined", rules_string)
