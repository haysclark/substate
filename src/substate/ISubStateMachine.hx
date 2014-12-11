/****
* 
*    substate
*    =================================
*    A Single Hierarchical State Machine
* 
*               |_
*         _____|~ |______ ,.
*        ( --  subSTATE  `+|
*      ~~~~~~~~~~~~~~~~~~~~~~~
* 
* Copyright (c) 2014 Infinite Descent. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
* 
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY INFINITE DESCENT ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INFINITE DESCENT OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Infinite Descent.
****/

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
    function removeState(stateName:String):Void;

    /**
	 * Removes all states.
	 **/
    function flushStates():Void;

    /**
	 *	Return if a the state machine has a state with a specific Unique ID.
	 */
    function hasState(stateName:String):Bool;

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
	function canTransition(stateName:String):Bool;

	/**
	 * Changes the current state
	 * This will only be done if the Intended state allows the transition from the current state
	 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
	 * @param stateName	The name of the state to transition to
	 **/
	function doTransition(stateName:String):Void;

    /**
	 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
	 * These will only occour if no state is defined
	 * @param stateName	The Unique ID of the State
	 **/
    var initialState(default, set):String;

    /**
	 *	Gets the name (UID) of the current state
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