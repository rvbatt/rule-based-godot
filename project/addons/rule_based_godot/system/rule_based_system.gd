@tool
@icon("../ruler_icon.png")
extends Node

@export_enum("First Applicable") var rule_arbitration: String = "First Applicable"
@export var rules: Array[Rule]

var _arbiter: AbstractArbiter

func _ready():
	match rule_arbitration:
		"First Applicable":
			_arbiter = FirstApplicableArbiter.new()

	for rule in rules:
		rule.setup(self)

func test_rules():
	var satified_rules: Array[Rule] = []
	for rule in rules:
		if rule.condition.is_satisfied():
			satified_rules.append(rule)

	if not satified_rules.is_empty():
		_arbiter.select_rule_to_trigger(satified_rules).trigger_actions()

func _set(property, value):
	if property == "rule_arbitration":
		match value:
			"First Applicable":
				_arbiter = FirstApplicableArbiter.new()
		rule_arbitration = value
		return true

	return false
