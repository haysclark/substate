package substate;

interface IStateMachine {
	/**
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateName	The name of the State
	 **/
	var initialState(null, set):String;

	/**
	 *	Getters for the current state and for the Dictionary of states
	 */
	var state(default, null):String;

    /**
	 *	Gets if the StateMachine knows of a given state name.
	 */
	function hasStateByName(name:String):Bool;

    /**
	 * Adds a new state
	 * @param state The state to add
	 **/
    function addState(state:IState):Void;

    /**
	 * Removes a state
	 * @param state The state to add
	 **/
    function removeState(state:IState):Void;

    /**
	 * Gets a state by it's name
	 * @param name of the state
	 **/
    function getStateByName(name:String):IState;

    /**
	 * Gets all states names
	 **/
    function getAllStateNames():Array<String>;

    /**
	 * Verifies if a transition can be made from the current state to the
	 * state passed as param
	 *
	 * @param stateName	The name of the State
	 **/
	function canChangeStateTo(toState:String):Bool;

	/**
	 * Changes the current state
	 * This will only be done if the Intended state allows the transition from the current state
	 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
	 * @param stateTo	The name of the state to transition to
	 **/
	function changeState(stateTo:String):Void;
}