@tool
class_name HierarchyMatch
extends VariableTargetMatch

@export_node_path var source_node_path
var _source_node: Node
@export_enum("Parent of", "Sibling of", "Child of") var relation: String = "Parent of"

func setup(system_node: Node) -> void:
	super.setup(system_node)
	_source_node = system_node.get_node(source_node_path)

static func json_format() -> String:
	return '["Hierarchy", "source_node", "(Parent|Sibling|Child) of", "?var|node"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(
		["Hierarchy", source_node_path, relation, _var_or_path_string()]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	source_node_path = NodePath(json_repr[1])
	relation = json_repr[2]
	_build_var_or_path(json_repr[3])

func _get_candidates() -> Array[Node]:
	var candidates = []
	match relation:
		"Parent of":
			candidates = _system_node.get_children()
		"Sibling of":
			candidates = _system_node.get_parent().get_children()
			candidates.erase(_system_node)
		"Child of":
			candidates = [_system_node.get_parent()]

	# Groups are filters, if none is provided take all candidates
	return candidates.filter(_is_in_search_groups)

func _node_satisfies_match(target_node: Node) -> bool:
	if _source_node == null or target_node == null:
		print_debug("Invalid node in HierarchyMatch")
		return false

	var relative_path = _source_node.get_path_to(target_node).get_concatenated_names()
	match relation:
		"Parent of":
			return relative_path == target_node.name
		"Sibling of":
			return relative_path == "../" + target_node.name
		"Child of":
			return relative_path == ".."
		_:
			push_error("Invalid relation in HierarchyMatch")
			return false
