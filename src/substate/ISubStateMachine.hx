package substate;

interface ISubStateMachine {

    /**
	 * Adds a new state
	 * @param state The state to add
	 **/
    function addState(state:IState):Void;

    /**
	 * Removes a state by Unique ID
	 * @param state Unique ID
	 **/
    function removeState(stateUID:String):Void;

    /**
	 * Removes all states.
	 **/
    function flushStates():Void;

    /**
	 *	Return if a the state machine has a state with a specific Unique ID.
	 */
    function hasState(stateUID:String):Bool;

    /**
	 * Gets all states Unique IDs
	 **/
    function getAllStates():Array<String>;

    /**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 *
	 * @param stateName	The name of the State
	 **/
	function canTransition(stateUID:String):Bool;

	/**
	 * Changes the current state
	 * This will only be done if the Intended state allows the transition from the current state
	 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
	 * @param stateTo	The name of the state to transition to
	 **/
	function doTransition(stateUID:String):Void;

    /**
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateUID	The Unique ID of the State
	 **/
    var initialState(default, set):String;

    /**
	 *	Gets the Unique ID of the current state
	 */
    var currentState(default, null):String;

    /**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 *
	 * @param stateName	The name of the State
	 **/
    function subscribe(observer:IObserverTransition):Void;

    /**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 *
	 * @param stateName	The name of the State
	 **/
    function unsubscribe(observer:IObserverTransition):Void;
}