# Rule-Based Godot
A plugin for Godot game engine that  implements a generic Rule-Based System. This was developed as the capstone project for my Computer Science bachelor degree at USP.

## Adding rules to a scene
1. Add a _RuleBasedSystem_ node to the scene
   > It's recommended for the system node to be the parent of all the nodes controlled by it, because we will use relative node paths from the system to the other nodes
2. Set the type of _Iteration Update_ that the system will use:
   - `Every frame`: iterates every physics frame. **Use this with caution**, a
   large set of rules can take a while to run through
   - `On Timer`: iterates every _wait\_time_ seconds, which can be defined in the _Timer_ category on the Inspector
   - `On Call`: only iterates when the method _iterate()_ is called explicity. You can connect external signals to this method if you want to have a better control over it
3. Add an _Arbiter_. **Don't choose the _AbstractArbiter_**, because that's the abstract class and it doesn't implement the necessary function
   > It's recommended to `Quick Load` a resource file, because the arbiters don't need to be local to the scene, so use the same saved one and avoid creating another
4. Now you can choose to use either the _Inspector_, with a graphical interface, or the _Rules Editor_ bottom panel, with a code driven approach, to declare the rules

### Creating rules in the Inspector
> Since the _RuleList_ and all of its components are resources, you can save and load any part of the data structure, sharing common rules, conditions or actions between several systems. The following steps talk about creating new ones from scratch, but you can skip any creation if you load an existing resource instead.

5. Create a new _RuleList_ and start adding rules on the array, as many as you need
6. For each _Rule_, create its components (**never choose the ones that start with _Abstract_**):
   1. Create a _Condition_. If you choose a boolean match (NOT, OR, AND), you can then create its subconditions, repeating this step. If you choose a datum match,
   edit its properties, and don't forget to expand the groups to check them out
   2. Add an _Action_ to the array, then edit its properties, including the ones on
   the groups. You can repeat this step as many times as you want
7. (optional) Once you have defined the behavior you want, you can save a part or all of
the list of rules as a resource file. You can save a _Condition_, an individual _Action_, a _Rule_ or the whole _RuleList_

> **Obs.**: You can give _Rules_, _Matches_ and _Actions_ a name, by editing the _Name_ property on the `Resource` group (it's actually _resource_name_) 

### Declaring rules in the Rules Editor
You can define rules in the `Rules Editor` bottom panel using a JSON syntax. The panel connects itself to the last _RuleBasedSystem_ that you've clicked,
which will be the one showing on the Inspector.

5. Open the `Rules Editor` and use the `Reset` button if there is some leftover text in the editor
6. Delete the "condition", keep the caret at that position and click the `New Match` button. Choose one of the options that popped up and click it. The format of the selected match will be inserted in the editor, where the caret was
7. Follow the syntax explained in the [documentation](#syntax-documentation) and replace the placeholders with the configuration you want. If you chose a boolean match, there will be another "condition" or "conditions", so repeat the
previous step
8. Delete "actions" and click the `New action` button. Click one option. The JSON format of that type of action will be inserted where the caret was
9. Like step 7, replace the placeholders with the action properties, following the [syntax](#syntax-documentation)
10. (optional) Add new rules using the `New Rule` button, which inserts the template on the caret position. Repeat steps 6 to 9 with every new rule
11. When your rules are done, click the `Apply` button to set the current
_RuleBasedSystem_'s rule list. If the syntax is wrong, a JSON parsing error will appear and the "apply" will abort

## JSON syntax
### How to read the syntax documentation
> The term `condition` can be replaced by a _NOTMatch_, subtypes of _MultiBoolMatch_ or subtypes of _DatumMatch_.

> The `ID` of a component is its _class\_name_ without the "Action" or "Match" suffix.

Here are the patterns adopted to represent the syntax:

- `"constant"`: if something is between **" "**, then it is a constant and it should be written the exact same way, **including the quotation marks**
  > Ex.: _"Fixed"_ should be copied as _"Fixed"_ and not be replaced
- `?variable`: any name prefixed by an **?** represents a variable, or wild card. It can renamed to anything you want, but the string **must contain the question mark**
  > Ex.: _?data_ represents a variable named data, but it can be replaced by _?example_
- `[items]`: represents an array of arbitrary length, **including empty**, containing elements of type **item** separated by commas
  > Ex.: _\[fruits\]_ can be replaced by _\[\]_, _\[apple\]_ or _\[apple, banana, mango\]_
- `items...`: represents an arbitrary number (which **can be zero**) of elements of type **item** separated by commas, but not inside an array
  > Ex.: _colors..._ can be replaced by _red_ or _red, green, blue_ or by nothing
- `{keys: values}`: represents a dictionary where the keys have the type **key** and the values are of the type **value**, with arbitrary size, **including empty**
  > Ex.: _{characters: classes}_ can be replaced by _{}_ or by _{Alice: mage, Bob: fighter}_

  > **Note**: If the terms inside **{ }** are on the **singular** form (don't end with **s**), then the dictionary must contain only **one** entry
- `<optional>`: if something is between **< >**, you can choose to include it or not
  > Ex.: _\<adjective\>, noun_ can be replaced by _red, ball_ or just _ball_

  > **Note**: When used on **templates**, it indicates that the subtypes may or may not have this element
- `(choiceA|choiceB|choiceC.1, choiceC.2)`: you need to pick **one** of the choices
separated by **|** and between **( )**. One choice can have several items separated by commas
  > Ex.: _(melee\_weapon|ranged\_weapon, ammunition)_ can be replaced by _sword_ or by _bow, arrow_

### Syntax documentation

- **Rule List**: `{"Rules": [rules]}`
- **Rule**: `{"if": condition, "then": [actions]}`
- Matches:
   - **NOT**: `["NOT", condition]`
   - Multi Bool: `[ID, [conditions]]` (template)
	    - **AND**: `["AND", [conditions]]`
	    - **OR**: `["OR", [conditions]]`
   - Datum: `[ID, <?data>, vars..., (tester_path|?wild, [groups]) <, (prop|method, [args])>]` (template)
	    - **Area Detection**: `["AreaDetection", area_path, (tester_path|?wild, [groups])]`
          > Obs: `area_path` must be the path to either an _Area2D_ or _Area3D_
	    - **Distance**: `["Distance", <?dist,> source_path, min_distance, max_distance, (tester_path|?wild, [groups])]`
          > Obs: `min_distance` e `max_distance` are float number, `"inf"` or `"-inf"`
	    - **Hierarchy**: `["Hierarchy", source_path, ("Parent of"|"Sibling of"|"Child of"), (tester_path|?wild, [groups])]`
	    - **Numeric**: `["Numeric", <?number,>  min_value, max_value, (tester_path|?wild, [groups]), (prop|method, [args])`
          > Obs: `min_value` e `max_value` are float number, `"inf"` or `"-inf"`
	    - **String**: `["String", <?string,> string_value, (tester_path|?wild, [groups]), (prop|method, [args])`
- Actions: `[ID, (agent_path|?wild|[groups]|), vars...]` (template)
   - **Set Property**: `["SetProperty", (agent_path|?wild|[groups]|), {property: value}]`
     > Obs: `{property: value}` only has only one entry
   - **Call Method**: `["CallMethod", (agent_path|?wild|[groups]|), method, [args]]`
   - **Emit Signal**: `["EmitSignal", (agent_path|?wild|[groups]|), signal <, {params: types}, [args]>]`
     > Obs: `{params: types}` is a dictionary with the name of the signal parameters as keys and an arbitrary element with the same type as the corresponding argument as value. For example: _{number\_param: 1, string\_param: ""}_
