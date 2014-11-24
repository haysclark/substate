zip -x .* -r substate.zip src *.json documentation *.md LICENSE
haxelib submit substate.zip
#rm substate.zip