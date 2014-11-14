package stateMachine;

interface IStateMachine
{
	/**
	 * Adds a new state
	 * @param stateName	The name of the new State
	 * @param stateData	A hash containing state enter and exit callbacks and allowed states to transition from
	 * The "from" property can be a string or and array with the state names or * to allow any transition
	 **/
	function addState(newState:IState):Void;
	
	/**
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateName	The name of the State
	 **/
	function set initialState(stateName:String):Void;
	
	/**
	 *	Getters for the current state and for the Dictionary of states
	 */
	function get state():String;
	
	/**
	 *	Gets if the StateMachine knows of a given state name.
	 */
	function hasStateByName(name:String):Bool;
	
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