package substate.core;

/**
 * A Collection class for IObserverTransitions which parrots
 * messages to subscribrers.
 * 
 * See Observer Pattern(GOF)
 */
class ObserverTransitionCollection implements IObserverTransition
{
	//----------------------------------
	//  vars
	//----------------------------------
	private var _observerTransitions:Array<IObserverTransition>;

    public function new():Void {}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function init():Void {
		_observerTransitions = new Array<IObserverTransition>();
	}
	
	public function destroy():Void {
		while(_observerTransitions.length > 0){
			unsubscribe(_observerTransitions.pop());
		}
		_observerTransitions = null;
	}
	
	public function subscribe(observer:IObserverTransition):Void {
		_observerTransitions.push(observer);
	}
	
	public function unsubscribe(observer:IObserverTransition):Void {
        _observerTransitions.remove(observer);
	}
	
	//----------------------------------
	//  IObserverTransition
	//----------------------------------
	public function transitionComplete(toState:String, fromState:String):Void {
		for (i in 0..._observerTransitions.length) {
			var observer:IObserverTransition = _observerTransitions[i];
            observer.transitionComplete(toState, fromState);
		}
    }

    public function transitionDenied(toState:String, fromState:String, allowedFromStates:Array<String>):Void {
        for (i in 0..._observerTransitions.length) {
			var observer:IObserverTransition = _observerTransitions[i];
			observer.transitionDenied(toState, fromState, allowedFromStates);
		}
	}
}