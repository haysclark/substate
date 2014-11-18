package stateMachine;

/**
 * Interface for observing state transitions and denials.  Interface provided so
 * users can choose between Native AS3 Events, as3-signals, etc.
 */
interface IObserverTransition {
	function transitionComplete(toState:String, fromState:String):Void;
	function transitionDenied(toState:String, fromState:String, allowedFromStates:Array<String>):Void;
}