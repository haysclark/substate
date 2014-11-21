package substate;

interface IExit {
	function exit(fromState:String, toState:String, currentState:String = null):Void;
}