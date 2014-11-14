package stateMachine;

import flash.utils.Dictionary;

class StateMachine implements IStateMachine
{
	//----------------------------------
	//  CONSTS
	//----------------------------------
	public static inline var UNINITIALIZED_STATE:String="uninitializedState";
	
	// NOOPs
	public static inline var UNKNOWN_STATE:IState=new State("unknown.state");
	public static inline var UNKNOWN_PARENT_STATE:IState=new State("unknown.parent.state");
	public static inline var NO_PARENT_STATE:IState=new State("no.parent.state");
	
	//----------------------------------
	//  vars
	//----------------------------------
	/* @private */
	private var _nameToStates:Dictionary;
	/* @private */
	private var _observerCollection:ObserverTransitionCollection;
	/* @private */
	private var _state:String=UNINITIALIZED_STATE;
	
	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function init():Void {
		_nameToStates=new Dictionary();
		_observerCollection=new ObserverTransitionCollection();
		_observerCollection.init();
	}
	
	public function destroy():Void {
		for(key in _nameToStates){
			_nameToStates[key]=null;
			delete _nameToStates[key];
		}
		_nameToStates=null;
		_observerCollection.destroy();
		_observerCollection=null;
		_state=null;
	}
	
	public function subscribe(observer:IObserverTransition):Void {
		_observerCollection.subscribe(observer);
	}
	
	public function unsubscribe(observer:IObserverTransition):Void {
		_observerCollection.unsubscribe(observer);
	}
	
	//----------------------------------
	//  IStateMachine
	//----------------------------------
	/**
	 * Adds a new state
	 * @param stateName	The name of the new State
	 * @param stateData	A hash containing state enter and exit callbacks and allowed states to transition from
	 * The "from" property can be a string or and array with the state names or * to allow any transition
	 **/
	public function addState(newState:IState):Void {
		//if(newState.name in _nameToStates){
		//trace("[StateMachine] Overriding existing state " + newState.name);
		//}
		_nameToStates[newState.name]=newState;
	}
	
	/**
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateName	The name of the State
	 **/
	public var initialState(null, set_initialState):String;
 	private function set_initialState(stateName:String):Void {
		if(_state==UNINITIALIZED_STATE && stateName in _nameToStates){
			_state=stateName;
			executeEnterForStack(stateName, null);
			notifyTransitionComplete(stateName, null);		
		}
	}
	
	/**
	 * Getters for the current state and for the Dictionary of states
	 */
	public var state(get_state, set_state):String;
 	private function get_state():String {
		return _state;
	}
	
	/**
	 * Verifies if a state name is known by StateMachine.
	 * 
	 * @param stateName	The name of the State
	 **/
	public function hasStateByName(name:String):Bool {
		return(_nameToStates[name] !=undefined);
	}
	
	/**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 * 
	 * @param stateName	The name of the State
	 **/
	public function canChangeStateTo(toState:String):Bool {
		return(hasStateByName(toState)
			&& toState !=_state
			&& allowTransitionFrom(_state, toState)
		);
	}
	
	/**
	 * Changes the current state
	 * This will only be done if the Intended state allows the transition from the current state
	 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
	 * @param stateTo	The name of the state to transition to
	 **/
	public function changeState(stateTo:String):Void {
		// If there is no state that maches stateTo
		if(!hasStateByName(stateTo)){
			//trace("[StateMachine] Cannot make transition:State " + stateTo + " is not defined");
			return;
		}
		
		// If current state is not allowed to make this transition
		if(!canChangeStateTo(stateTo)){
			//trace("[StateMachine] Transition to " + stateTo + " from " + state + " denied");
			notifyTransitionDenied(_state, stateTo, getAllFromsForStateByName(stateTo));
			return;
		}
		
		// call exit and enter callbacks(if they exits)
		var path:Array<Dynamic>=findPath(_state, stateTo);
		if(path[0]>0){ // hasFroms
			executeExitForStack(_state, stateTo, path[0]);
		}
		
		var oldState:String=_state;
		_state=stateTo;
		if(path[1]>0){ // hasTos
			executeEnterForStack(stateTo, oldState);
		}
		//trace("[StateMachine] State Changed to " + _state);			
		notifyTransitionComplete(stateTo, oldState);
	}
	
	private function executeExitForStack(_state:String, stateTo:String, n:Int):Void {
		getStateByName(_state).onExit.exit(_state, stateTo, _state);
		var parentState:IState=getStateByName(_state);
		for(var i:Int=0;i<n - 1;i++){
			parentState=getParentStateByName(parentState.name);// parentState.parent;
			if(parentState.onExit !=null){
				parentState.onExit.exit(_state, stateTo, parentState.name);
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  INTERNAL METHODS
	//
	//--------------------------------------------------------------------------
	private function allowTransitionFrom(fromState:String, toState:String):Bool {
		var fromStateAllNames:Array<Dynamic>=getAllStateNames(fromState);
		var toStateFroms:Array<Dynamic>=getAllFromsForStateByName(toState);
		return(toStateFroms.indexOf(State.WILDCARD)>=0 
			|| doTransitionsMatch(fromStateAllNames, toStateFroms));
	}
	
	/**
	 * Discovers the how many "exits" and how many "enters" are there between two
	 * given states and returns an array with these two Integers
	 * @param stateFrom The state to exit
	 * @param stateTo The state to enter
	 **/
	private function findPath(stateFrom:String, stateTo:String):Array {
		// Verifies if the states are in the same "branch" or have a common parent
		var froms:Int=0;
		var tos:Int=0;
		if(hasStateByName(stateFrom)&& hasStateByName(stateTo)){
			var fromState:IState=getStateByName(stateFrom);
			while(fromState && fromState !=UNKNOWN_STATE && fromState !=UNKNOWN_PARENT_STATE){
				tos=0;
				var toState:IState=getStateByName(stateTo);
				while(toState && toState !=UNKNOWN_STATE && toState !=UNKNOWN_PARENT_STATE){
					if(fromState==toState){
						// They are in the same brach or have
						// a common parent Common parent
						return [froms, tos];
					}
					tos++;
					toState=getParentStateByName(toState.name);//toState.parent;
				}
				froms++;
				fromState=getParentStateByName(fromState.name)//fromState.parent;
			}
		}
		
		// No direct path, no commom parent:exit until root then enter until element
		return [froms, tos];
	}
	
	private function getParentStateByName(name:String):IState {
		if(!hasStateByName(name)){
			return UNKNOWN_STATE;
		} else {
			var stateName:IState=getStateByName(name);
			var parentName:String=stateName.parentName;
			if(parentName==State.NO_PARENT){
				return NO_PARENT_STATE;
			} else if(!hasStateByName(parentName)){
				return UNKNOWN_PARENT_STATE;
			} else {
				return getStateByName(parentName);					
			}
		}
	}
	
	private function getStateByName(name:String):IState {
		return hasStateByName(name)? _nameToStates[name]:UNKNOWN_STATE;
	}
	
	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------
	private function executeEnterForStack(stateTo:String, oldState:String):Void {
		var parentStates:Array<Dynamic>=getAllStatesChildToRootByName(stateTo);
		var n:Int=parentStates.length;
		for(var j:Int=n - 1;j>=0;j--){
			var state:IState=parentStates[j];
			state.onEnter.enter(stateTo, oldState, state.name);
		}
	}
	
	private function notifyTransitionComplete(toState:String, fromState:String):Void {
		_observerCollection.transitionComplete(toState, fromState);
	}
	
	private function notifyTransitionDenied(fromState:String, toState:String, allowedFromStates:Array):Void {
		_observerCollection.transitionDenied(toState, fromState, allowedFromStates);
	}
	
	private function getAllStatesChildToRootByName(name:String):Array {
		var states:Array<Dynamic>=[];
		while(hasStateByName(name)){
			var state:IState=getStateByName(name);
			states.push(state);
			if(state.parentName==State.NO_PARENT){
				break;
			}
			name=state.parentName;
		}
		return states;
	}
	
	private function doTransitionsMatch(fromStateAllNames:Array, toStateFroms:Array):Bool {
		for(var name:String in fromStateAllNames){
			if(toStateFroms.indexOf(name)<0){
				continue;
			}
			return true;
		}
		return false;
	}
	
	private function getAllStateNames(stateName:String):Array {
		var names:Array<Dynamic>=[];
		var states:Array<Dynamic>=getAllStatesChildToRootByName(stateName);
		for(var state:IState in states){
			names.push(state.name);
		}
		return names;
	}
	
	private function getAllFromsForStateByName(toState:String):Array {
		var froms:Array<Dynamic>=[];
		var states:Array<Dynamic>=getAllStatesChildToRootByName(toState);
		for(var state:IState in states){
			for(var fromName:String in state.from){
				if(froms.indexOf(fromName)<0){
					froms.push(fromName);
				}
			}
		}
		return froms;
	}
}