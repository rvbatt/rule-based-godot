@icon("../ruler_icon.png")
extends Node
class_name RuleBasedSystem

# Identifier for the RulesInspectorPlugin
@export var _rule_based_godot: StringName = "System"

@export_enum("First Applicable", "Least Recently Used")
var rule_arbitration: String = "First Applicable":
	set(arbitration):
		_set_arbiter(arbitration)
		rule_arbitration = arbitration

@export var rule_set: RuleSet:
	set(rules):
		rules.setup(self)
		rule_set = rules

var _arbiter: AbstractArbiter

func _ready():
	_set_arbiter(rule_arbitration)
	if rule_set != null:
		rule_set.setup(self)

func test_rules() -> Array:
	var satified_rules = rule_set.satisfied_rules()

	if not satified_rules.is_empty():
		var selected_rule = _arbiter.select_rule_to_trigger(satified_rules)
		return selected_rule.trigger_actions()

	return []

func _set_arbiter(arbitration: StringName) -> void:
	match arbitration:
		"First Applicable":
			_arbiter = FirstApplicableArbiter.new()
		"Least Recently Used":
			_arbiter = LeastRecentlyUsedArbiter.new()
