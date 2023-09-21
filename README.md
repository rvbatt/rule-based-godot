# Rule-Based Godot
A plugin for Godot game engine that  implements a generic Rule-Based System. This was developed as the capstone project for my Computer Science bachelor degree at USP.

## Rules Editor
You can define rules in the **Rules Editor** bottom panel using a JSON syntax.

### How to read the syntax documentation
Here are the patterns adopted to represent the syntax:

- `"constant"`: if something is between **" "**, then it is a constant and it should be written the exact same way, **including the quotation marks**. For example, _"Fixed"_ should be copied as _"Fixed"_ and not be replaced
- `?variable`: any name prefixed by an **?** represents a variable, or wild card. It can renamed to anything you want, but the string **must contain the question mark**. For example, _?data_ represents a variable named data, but it can be replaced by _?example_
- `[items]`: represents an array of arbitrary length, **including empty**, containing elements of type **item** separated by commas. For example, _\[fruits\]_ can be replaced by _\[\]_, _\[apple\]_ or _\[apple, banana, mango\]_
- `items...`: represents an arbitrary number (which **can be zero**) of elements of type **item** separated by commas, but not inside an array. For example, _colors..._ can be replaced by _red_ or _red, green, blue_ or by nothing
- `{keys: values}`: represents a dictionary where the keys have the type **key** and the values are of the type **value**, with arbitrary size, **including empty**. For example, _{characters: classes}_ can be replaced by _{}_ or by _{Alice: mage, Bob: fighter}_. If the terms inside **{ }** are on the **singular** form (don't end with **s**), then the dictionary must contain only **one** entry
- `<optional>`: if something is between **< >**, you can choose to include it or not. For example, _\<adjective\>, noun_ can be replaced by _red, ball_ or just _ball_. When used on **templates**, it indicates that the subtypes may or may not have this element
- `(choiceA|choiceB|choiceC.1, choiceC.2)`: you need to pick **one** of the choices
separated by **|** and between **( )**. One choice can have several items separated by commas. For example, _(melee\_weapon|ranged\_weapon, ammunition)_ can be replaced by _sword_ or by _bow, arrow_

The term `condition` can be replaced by **NOTMatch**, subtypes of **MultiBoolMatch** or subtypes of **DatumMatch**.

The `ID` of a component is its **_class\_name_** without the "Action" or "Match" suffix.

### JSON syntax
- **Rule List**: `{"Rules": [rules]}`
- **Rule**: `{"if": condition, "then": [actions]}`
- Matches:
  - **NOT**: `["NOT", condition]`
  - Multi Bool: `[ID, [conditions]]` (template)
    - **AND**: `["AND", [conditions]]`
	- **OR**: `["OR", [conditions]]`
  - Datum: `[ID, <?data>, vars..., (tester_path|?wild, [groups]) <, (prop|method, [args])>]` (template)
    - **Area Detection**: `["AreaDetection", area_path, (tester_path|?wild, [groups])]`. Obs: `area_path` must be the path to either an **_Area2D_** or **_Area3D_**
    - **Distance**: `["Distance", <?dist,> source_path, min_distance, max_distance, (tester_path|?wild, [groups])]`. Obs: `min_distance` e `max_distance` are float number, "inf" or "-inf"
    - **Hierarchy**: `["Hierarchy", source_path, ("Parent of"|"Sibling of"|"Child of"), (tester_path|?wild, [groups])]`
    - **Numeric**: `["Numeric", <?number,>  min_value, max_value, (tester_path|?wild, [groups]), (prop|method, [args])`. Obs: `min_value` e `max_value` are float number, "inf" or "-inf"
    - **String**: `["String", <?string,> string_value, (tester_path|?wild, [groups]), (prop|method, [args])`
- Actions: `[ID, (agent_path|?wild|[groups]|), vars...]` (template)
  - **Set Property**: `["SetProperty", (agent_path|?wild|[groups]|), {property: value}]`. Obs: `{property: value}` only has one entry
  - **Call Method**: `["CallMethod", (agent_path|?wild|[groups]|), method, [args]]`
  - **Emit Signal**: `["EmitSignal", (agent_path|?wild|[groups]|), signal <, {params: types}, [args]>]`. Obs: `{params: types}` is a dictionary with the name of the signal parameters as keys and an arbitrary element with the same type as the corresponding argument as values. For example: _{number\_param: 1, string\_param: ""}_
