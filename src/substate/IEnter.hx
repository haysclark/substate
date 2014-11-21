package substate;

interface IEnter {
	function enter(toState:String, fromState:String, currentState:String):Void;
}