@tool
class_name HierarchyMatch
extends DatumMatch

@export_node_path var source_path: NodePath = ^""
var _source_node: Node
@export_enum("Parent of", "Sibling of", "Child of") var relation: String = "Parent of"

func _init():
	Data_Retrieval = false
	_preset_node_path("source_path", "_source_node")

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

func _node_satisfies_match(target_node: Node, bindings: Dictionary) -> bool:
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
