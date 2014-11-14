package stateMachine;

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
	private var _observerTransitions:Array<Dynamic>;// of IObserverTransitions
	
	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function init():Void {
		_observerTransitions=[];
	}
	
	public function destroy():Void {
		while(_observerTransitions.length){
			unsubscribe(_observerTransitions.pop()as IObserverTransition);
		}
		_observerTransitions=null;
	}
	
	public function subscribe(observer:IObserverTransition):Void {
		_observerTransitions.push(observer);
	}
	
	public function unsubscribe(observer:IObserverTransition):Void {
		var n:Int=_observerTransitions.length;
		for(i in 0...n){
			if(observer !==_observerTransitions[i]){
				continue;
			}
			_observerTransitions.splice(i, 1);
		}
	}
	
	//----------------------------------
	//  IObserverTransition
	//----------------------------------
	public function transitionComplete(toState:String, fromState:String):Void {
		var n:Int=_observerTransitions.length;
		for(i in 0...n){
			var observer:IObserverTransition=_observerTransitions[i] as IObserverTransition;
			observer..transitionComplete(toState, fromState)
		}
	}
	
	public function transitionDenied(toState:String, fromState:String, allowedFromStates:Array):Void {
		var n:Int=_observerTransitions.length;
		for(i in 0...n){
			var observer:IObserverTransition=_observerTransitions[i] as IObserverTransition;
			observer.transitionDenied(toState, fromState, allowedFromStates)
		}
	}
}