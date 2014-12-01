zip -x .* -r substate.zip src *.json documentation *.md
haxelib submit substate.zip
rm substate.zip