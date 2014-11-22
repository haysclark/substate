package substate;

import haxe.ds.StringMap;

class StateMachine implements IStateMachine {
	//----------------------------------
	//  CONSTS
	//----------------------------------
	public static inline var UNINITIALIZED_STATE:String = "uninitializedState";
	
	// NOOPs
	public static var UNKNOWN_STATE:IState = new State("unknown.state");
	public static var UNKNOWN_PARENT_STATE:IState = new State("unknown.parent.state");
	public static var NO_PARENT_STATE:IState = new State("no.parent.state");

    //----------------------------------
	//  vars
	//----------------------------------
	/* @private */
	private var _nameToStates:StringMap<IState>;

	/* @private */
	private var _observerCollection:ObserverTransitionCollection;

    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    public function new() {}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function init():Void {
        state = UNINITIALIZED_STATE;

        _nameToStates = new StringMap<IState>();
	 	_observerCollection = new ObserverTransitionCollection();
	 	_observerCollection.init();
	}

	public function destroy():Void {
        for (key in _nameToStates.keys()) {
            _nameToStates.remove(key);
        }
        _nameToStates = null;

		_observerCollection.destroy();
		_observerCollection=null;
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
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateName	The name of the State
	 **/
    public var initialState(null, set):String;
    private function set_initialState(stateName:String):String {
        if(state == UNINITIALIZED_STATE && _nameToStates.exists(stateName)) {
            state = stateName;
            executeEnterForStack(stateName, null);
            notifyTransitionComplete(stateName, null);
        }
        return initialState;
    }

	/**
	 * Getters for the current state and for the Dictionary of states
	 */
    public var state(default, null):String;

    /**
	 * Verifies if a state name is known by StateMachine.
	 * 
	 * @param stateName	The name of the State
	 **/
    public function hasStateByName(name:String):Bool {
        return _nameToStates.exists(name);
    }

    /**
	 * Adds a new state
	 * @param state The state to add
	 **/
    public function addState(state:IState):Void {
        if (_nameToStates.exists(state.name)) {
            removeState(state);
        }
        _nameToStates.set(state.name, state);
    }

    /**
	 * Removes a state
	 * @param state The state to add
	 **/
    public function removeState(state:IState):Void {
        for (cur in _nameToStates.iterator()) {
            if(cur == state) {
                _nameToStates.remove(cur.name);
            }
        }
    }

    /**
	 * Gets a state by it's name
	 * @param name of the state
	 **/
    public function getStateByName(name:String):IState {
        return hasStateByName(name) ? _nameToStates.get(name) : UNKNOWN_STATE;
    }

    /**
	 * Gets all states names
	 **/
    public function getAllStateNames():Array<String> {
        var names = new Array<String>();
        for (state in _nameToStates.iterator()) {
            names.push(state.name);
        }
        return names;
    }

    /**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 *
	 * @param stateName	The name of the State
	 **/
    public function canChangeStateTo(toState:String):Bool {
        return(hasStateByName(toState)
        && toState != state
        && allowTransitionFrom(state, toState)
        );
    }

    /**
	 * Changes the current state
	 * This will only be done if the Intended state allows the transition from the current state
	 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
	 * @param stateTo	The name of the state to transition to
	 **/
    public function changeState(stateTo:String):Void {
        // If there is no state that matches stateTo
        if (!hasStateByName(stateTo)) {
            //trace("[StateMachine] Cannot make transition:State " + stateTo + " is not defined");
            return;
        }

        // If current state is not allowed to make this transition
        if (!canChangeStateTo(stateTo)) {
           //trace("[StateMachine] Transition to " + stateTo + " from " + state + " denied");
            notifyTransitionDenied(state, stateTo, getAllFromsForStateByName(stateTo));
            return;
        }

        // call exit and enter callbacks(if they exits)
        var path:Array<Int> = findPath(state, stateTo);
        if (path[0] > 0) { // hasFroms
            //trace("[StateMachine] hasFroms");
            executeExitForStack(state, stateTo, path[0]);
        }

        var oldState:String = state;
        state = stateTo;
        if (path[1] > 0) { // hasTos
        //trace("[StateMachine] hasTos");
            executeEnterForStack(stateTo, oldState);
        }

        //trace("[StateMachine] State Changed to " + state);
        notifyTransitionComplete(stateTo, oldState);
    }

    //--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------
	private function executeEnterForStack(stateTo:String, oldState:String):Void {
		var parentStates:Array<IState> = getAllStatesChildToRootByName(stateTo);
        parentStates.reverse;
        for(i in 0...parentStates.length) {
            var state:IState = parentStates[i];
            state.enter(stateTo, oldState, state.name);
        }
	}

    private function executeExitForStack(state:String, stateTo:String, n:Int):Void {
        getStateByName(state).exit(state, stateTo, state);
        var parentState:IState = getStateByName(state);
        for (i in 0 ... n - 1) {
            parentState = getParentStateByName(parentState.name); // parentState.parent;
            parentState.exit(state, stateTo, parentState.name);
        }
    }

	private function notifyTransitionComplete(toState:String, fromState:String):Void {
 	    _observerCollection.transitionComplete(toState, fromState);
	}
	
	private function notifyTransitionDenied(fromState:String, toState:String, allowedFromStates:Array<String>):Void {
		_observerCollection.transitionDenied(toState, fromState, allowedFromStates);
	}

    private function getAllStatesForState(stateName:String):Array<String> {
        var names = new Array<String>();
        var states:Array<IState> = getAllStatesChildToRootByName(stateName);
        for(state in states) {
            names.push(state.name);
        }
        return names;
    }

    /**
	 * Discovers the how many "exits" and how many "enters" are there between two
	 * given states and returns an array with these two Integers
	 * @param stateFrom The state to exit
	 * @param stateTo The state to enter
	 **/
    private function findPath(stateFrom:String, stateTo:String):Array<Int> {
        // Verifies if the states are in the same "branch" or have a common parent
        var froms:Int = 0;
        var tos:Int = 0;
        if (hasStateByName(stateFrom) && hasStateByName(stateTo)) {
            var fromState:IState = getStateByName(stateFrom);
            while ((fromState != null) && (fromState != UNKNOWN_STATE) && (fromState != UNKNOWN_PARENT_STATE)) {
                tos = 0;
                var toState:IState = getStateByName(stateTo);
                while ((toState != null) && (toState != UNKNOWN_STATE) && (toState != UNKNOWN_PARENT_STATE)) {
                    if (fromState==toState) {
                        // They are in the same brach or have
                        // a common parent Common parent
                        return [froms, tos];
                    }
                    tos++;
                    toState = getParentStateByName(toState.name); //toState.parent;
                }
                froms++;
                fromState = getParentStateByName(fromState.name); //fromState.parent;
            }
        }

        // No direct path, no commom parent:exit until root then enter until element
        var output:Array<Int> = [froms, tos];
        return output;
    }

    private function allowTransitionFrom(fromState:String, toState:String):Bool {
        var fromStateAllNames:Array<String> = getAllStatesForState(fromState);
        var toStateFroms:Array<String> = getAllFromsForStateByName(toState);
        return (toStateFroms.indexOf(State.WILDCARD) >= 0
        || doTransitionsMatch(fromStateAllNames, toStateFroms));
    }

	private function getAllStatesChildToRootByName(name:String):Array<IState> {
		var states:Array<IState> = new Array<IState>();
		while (hasStateByName(name)) {
			var state:IState = getStateByName(name);
			states.push(state);
			if (state.parentName == State.NO_PARENT) {
				break;
			}
			name = state.parentName;
		}
		return states;
	}
	
	private function doTransitionsMatch(fromStateAllNames:Array<String>, toStateFroms:Array<String>):Bool {
		for (name in fromStateAllNames) {
			if (toStateFroms.indexOf(name) < 0) {
				continue;
			}
			return true;
		}
		return false;
	}

	private function getAllFromsForStateByName(toState:String):Array<String> {
		var froms:Array<String> = new Array<String>();
		var states:Array<IState> = getAllStatesChildToRootByName(toState);
        for (state in states) {
			for (fromName in state.froms){
				if (froms.indexOf(fromName) < 0) {
					froms.push(fromName);
				}
			}
		}
		return froms;
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
}