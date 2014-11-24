/****
*
*   substate
*   =================================
*   A Single Hierarchical State Machine
*
*              |_
*        _____|~ |______ ,.
*       ( --  subSTATE  `+|
*     ~~~~~~~~~~~~~~~~~~~~~~~
*
* Copyright 2014 Infinite Descent. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
*
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
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
*
****/

package substate;

import haxe.ds.StringMap;
import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class SubStateMachineTest
{
    //----------------------------------
    //  vars
    //----------------------------------
	private var _instance:SubStateMachine;

    //--------------------------------------------------------------------------
    //
    //  SETUP
    //
    //--------------------------------------------------------------------------
    public function new() { }

    @Before
	public function setup():Void {
		_instance = new SubStateMachine();
		_instance.init();
	}
	
	@After
	public function tearDown():Void {
        _instance.destroy;
		_instance = null;
	}

    //--------------------------------------------------------------------------
    //
    //  TESTS
    //
    //--------------------------------------------------------------------------
    @Test
    public function test_UNINITIAL_STATE_IsExpectedValue():Void {
        var expected:String = "uninitializedState";

        Assert.areEqual(expected, SubStateMachine.UNINITIALIZED_STATE);
    }

    @Test
    public function testAddStateShouldNotChangeCurrentState():Void {
        var expected:String = SubStateMachine.UNINITIALIZED_STATE;

        _instance.addState(createPlayingState());

        Assert.areEqual(expected, _instance.currentState);
    }

    @Test
    public function testAddStateShouldTakeIStateArgument():Void {
    var knownState:IState = mock(IState);
    knownState.name.returns("foo");

    _instance.addState(knownState);
}

    @Test
    public function testAddStateShouldBeCallableMultipleTimes():Void {
        _instance.addState(createPlayingState());
        _instance.addState(createPausedState());
        _instance.addState(createStoppedState());
    }

    @Test
    public function testRemoveStateShouldRemoveState():Void {
        var knownState:IState = mock(IState);
        knownState.name.returns("known");
        knownState.parentName.returns(SubStateMachine.NO_PARENT);
        _instance.addState(knownState);
        Assert.isTrue(_instance.getAllStates().length == 1);

        _instance.removeState(knownState.name);
        Assert.isTrue(_instance.getAllStates().length == 0);
    }

    @Test
    public function testRemoveStateShouldResetInitialState():Void {
        var knownState:IState = mock(IState);
        knownState.name.returns("known");
        knownState.parentName.returns(SubStateMachine.NO_PARENT);
        _instance.addState(knownState);
        _instance.initialState = "known";
        Assert.areEqual("known", _instance.currentState);

        _instance.removeState(knownState.name);
        Assert.areEqual(SubStateMachine.UNINITIALIZED_STATE, _instance.currentState);
    }

    @Test
    public function testFlushStatesShouldRemoveAllStates():Void {
        var count = 20;
        for (i in 0...count) {
            var randState:IState = mock(IState);
            randState.name.returns(Std.string(i));
            randState.parentName.returns(SubStateMachine.NO_PARENT);
            _instance.addState(randState);
        }
        Assert.isTrue(_instance.getAllStates().length == count);

        _instance.flushStates();
        Assert.isTrue(_instance.getAllStates().length == 0);
    }

    @Test
    public function testFlushStatesShouldResetInitialState():Void {
        var count = 20;
        for (i in 0...count) {
            var randState:IState = mock(IState);
            randState.name.returns(Std.string(i));
            randState.parentName.returns(SubStateMachine.NO_PARENT);
            _instance.addState(randState);
        }
        _instance.initialState = "1";
        Assert.areEqual("1", _instance.currentState);

        _instance.flushStates();
        Assert.areEqual(SubStateMachine.UNINITIALIZED_STATE, _instance.currentState);
    }

    @Test
    public function testHasStateByNameShouldReturnFalseForUnknownState():Void {
        var unknownStateName:String = "foo";

        var result:Bool = _instance.hasState(unknownStateName);

        Assert.isFalse(result); //"expecting hasStateByName to return false for unknown state"
    }

    @Test
    public function testHasStateByNameShouldReturnTrueForKnownState():Void {
        var knownState:IState=createPlayingState();
        var expectedKnownStateName:String=knownState.name;
        _instance.addState(createPlayingState());

        var result:Bool=_instance.hasState(expectedKnownStateName);

        Assert.isTrue(result); //"expecting hasStateByName to return true for known state"
    }

    @Test
    public function testGetAllStateNamesShouldReturnAllStateUIDs():Void {
        var count = 20;
        for (i in 0...count) {
            var randState:IState = mock(IState);
            randState.name.returns(Std.string(i));
            _instance.addState(randState);
        }

        var uids = _instance.getAllStates();

        Assert.areEqual(count, uids.length);
        for (i in 0...count) {
            Assert.isTrue(uids.indexOf(Std.string(i)) >= 0);
        }
    }
    
    @Test
    public function testCanTransitionShouldReturnFalseForUnknownState():Void {
        var unknownStateName:String = "foo";

        var result:Bool = _instance.canTransition(unknownStateName);

        Assert.isFalse(result);
    }

    @Test
    public function testCanTransitionShouldReturnFalseForSameState():Void {
        var initialState:IState = createPausedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var sameStateName:String = initialState.name;

        var result:Bool = _instance.canTransition(sameStateName);

        Assert.isFalse(result);
    }

    @Test
    public function testCanTransitionShouldTrueWhenNewStatesFromIsWildcard():Void {
        var initialState:IState = createStoppedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState:IState = createFromWildCardState();
        _instance.addState(nextState);

        var result:Bool = _instance.canTransition(nextState.name);

        Assert.isTrue(result);
    }

    @Test
    public function testCanTransitionShouldTrueWhenNewStatesFromIncludeCurrentState():Void {
        var initialState:IState=createStoppedState();
        _instance.addState(initialState);
        _instance.initialState=initialState.name;
        var nextState:IState=createPlayingState();
        _instance.addState(nextState);

        var result:Bool=_instance.canTransition(nextState.name);

        Assert.isTrue(result);
    }

    @Test
    public function testCanTransitionShouldTrueWhenParentStateIncludesDestinationState():Void {
        setupQuakeStateExample();

        var result:Bool=_instance.canTransition("smash");

        Assert.isTrue(result);
    }

    @Test
    public function testDoTransitionShouldDoNothingForUnknownState():Void {
        var initialState:IState=createStoppedState();
        _instance.addState(initialState);
        _instance.initialState=initialState.name;
        var unknowStateName:String="foo";

        _instance.doTransition(unknowStateName);

        Assert.areEqual(initialState.name, _instance.currentState);
    }

    @Test
    public function testDoTransitionShouldDoNothingForIllegalStateTransition():Void {
        var initialState = createStoppedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var illegalState = createPausedState();
        _instance.addState(illegalState);
        var illegalStateName:String = illegalState.name;

        _instance.doTransition(illegalStateName);

        Assert.areEqual(initialState.name, _instance.currentState);
    }

    @Test
    public function testDoTransitionShouldNotifyTransitionDeniedForIllegalStateTransition():Void {
        var mockObserver = mock(IObserverTransition);
        _instance.subscribe(mockObserver);
        var initialState:IState = createStoppedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var illegalState:IState = createPausedState();
        _instance.addState(illegalState);
        var illegalStateName:String = illegalState.name;
        var allowedFromStatesResult:Array<String> = null;

        var answer = function(args:Array<Dynamic>):Void {
            allowedFromStatesResult = args[2];
        };
        mockObserver.transitionDenied(illegalState.name, initialState.name, cast any).calls(answer);

        _instance.doTransition(illegalStateName);

        mockObserver.transitionDenied(illegalState.name, initialState.name, cast any).verify();
        Assert.isNotNull(allowedFromStatesResult);
        Assert.areEqual(1, allowedFromStatesResult.length);
        Assert.areEqual(illegalState.froms[0], allowedFromStatesResult[0]);
    }

    @Test
    public function testDoTransitionShouldCallFromStatesExitHandler():Void {
        var initialState = mock(IState);
        initialState.name.returns("first");
        initialState.parentName.returns(SubStateMachine.NO_PARENT);
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState = createSecondState();
        _instance.addState(nextState);
        var nextStateName:String = nextState.name;

        _instance.doTransition(nextStateName);

        initialState.exit(cast any, cast any, cast any)
        .verify();
    }

    @Test
    public function testDoTransitionShouldCallFromStatesExitHandlerWithExpectedPayload():Void {
        var initialState = mock(IState);
        initialState.name.returns("first");
        initialState.parentName.returns(SubStateMachine.NO_PARENT);
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState = createSecondState();
        _instance.addState(nextState);
        var nextStateName:String = nextState.name;

        _instance.doTransition(nextStateName);

        initialState.exit(initialState.name, nextState.name, initialState.name)
        .verify();
    }

    @Test
    public function testDoTransitionShouldBeAbleToNavigateToAChildState():Void {
        setupQuakeStateExample();

        Assert.areEqual("idle", _instance.currentState); // "not expected initial state"
        _instance.doTransition("smash");
        Assert.areEqual("smash", _instance.currentState); // "not expected state after smash"
        _instance.doTransition("idle");
        Assert.areEqual("idle", _instance.currentState); // "not expected state after return to idle"
    }

    @Test
    public function testDoTransitionShouldBeAbleToNavigateToStateAndCallAllParentStateEnterCallbacks():Void {
        var mockOnAttack = mock(IEnter);
        var mockOnMeleeAttack = mock(IEnter);
        var mockOnSmash = mock(IEnter);

        _instance.addState(new StateBuilder().build("idle", { enter: mock(IEnter), from: "attack" }));
        _instance.addState(new StateBuilder().build("attack", { enter: mockOnAttack, from: "idle" }));
        _instance.addState(new StateBuilder().build("melee attack", { parent: "attack", enter: mockOnMeleeAttack, exit: mock(IExit), from: "attack" }));
        _instance.addState(new StateBuilder().build("smash", { parent: "melee attack", enter: mockOnSmash }));
        _instance.addState(new StateBuilder().build("punch", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new StateBuilder().build("missle attack", { parent: "attack", enter: mock(IEnter) }));
        _instance.addState(new StateBuilder().build("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));
        _instance.initialState="idle";

        Assert.areEqual("idle", _instance.currentState); // "not expected initial state"
        _instance.doTransition("smash");

        mockOnAttack.enter("smash", "idle", "attack").verify();
        mockOnMeleeAttack.enter("smash", "idle", "melee attack").verify();
        mockOnSmash.enter("smash", "idle", "smash").verify();

        _instance.doTransition("idle");
        Assert.areEqual("idle", _instance.currentState); // "not expected state after return to idle",
    }

    @Test
    public function testDoTransitionShouldCallExitStatesForParentsStates():Void {
        var mockOnExitMeleeAttack = mock(IExit);

        _instance.addState(new StateBuilder().build("idle", { enter: mock(IEnter), from: "attack" }));
        _instance.addState(new StateBuilder().build("attack", { enter: mock(IEnter), from: "idle" }));
        _instance.addState(new StateBuilder().build("melee attack", { parent: "attack", enter: mock(IEnter), exit: mockOnExitMeleeAttack, from: "attack" }));
        _instance.addState(new StateBuilder().build("smash", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new StateBuilder().build("punch", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new StateBuilder().build("missle attack", { parent: "attack", enter: mock(IEnter) }));
        _instance.addState(new StateBuilder().build("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));
        _instance.initialState="idle";

        _instance.doTransition("smash");
        mockOnExitMeleeAttack.exit(cast any, cast any, cast any)
        .verify(never);

        _instance.doTransition("idle");
        mockOnExitMeleeAttack.exit("smash", "idle", "melee attack")
        .verify();
    }

    @Test
    public function testInitialStateShouldNoChangeForUnknownState():Void {
        var expected:String=SubStateMachine.UNINITIALIZED_STATE;
        var unknownState:String="foo";

        _instance.initialState=unknownState;

        Assert.areEqual(expected, _instance.currentState);
    }

    @Test
    public function testInitialStateShouldNotBeNull():Void {
        Assert.isNotNull(_instance.currentState);
    }

    @Test
    public function testInitialStateShouldBeSetableToKnownState():Void {
        var initialState:IState=createStoppedState();
        var expectedInitialStateName:String=initialState.name;
        _instance.addState(initialState);

        _instance.initialState=expectedInitialStateName;

        Assert.areEqual(expectedInitialStateName, _instance.currentState);
    }

    @Test
    public function testInitialStateShouldCallEnterCallbackOfNewState():Void {
        var mockmock = mock(IEnter);
        var initialState:IState = new StateBuilder().build(
            "stopped",
            {
            enter: mockmock,
            from: "*"
            }
        );
        _instance.addState(initialState);
        _instance.initialState = initialState.name;

        mockmock.enter(cast anyString, cast any, cast anyString).verify();
    }

    @Test
    public function testInitialStateShouldCallEnterCallbackWithExpectedArguments():Void {
        var mockState =  mock(IState);
        mockState.name.returns("foo");
        mockState.parentName.returns(SubStateMachine.NO_PARENT);
        _instance.addState(mockState);

        _instance.initialState = mockState.name;

        mockState.enter(mockState.name, cast any, cast anyString)
        .verify();
    }

    @Test
    public function testInitialStateShouldNotifyThatTheTransitionCompleted():Void {
        var mockObserver:IObserverTransition = mock(IObserverTransition);
        _instance.subscribe(mockObserver);
        var initialState:IState = createStoppedState();
        _instance.addState(initialState);

        _instance.initialState = initialState.name;

        mockObserver.transitionComplete(initialState.name, null)
        .verify();
    }

    @Test
    public function testInitialStateShouldUseNullPatternWhenCallingEnterCallbackOfNewState():Void {
        var initialState:IState = createNullPatternTestState();
        _instance.addState(initialState);

        _instance.initialState = initialState.name;

        // test should not error
    }

    @Test
    public function testCurrentStateShouldBeInitializedTo_NO_STATE():Void {
        var expected:String=SubStateMachine.UNINITIALIZED_STATE;

        Assert.areEqual(expected, _instance.currentState);
    }

    /**
    * TDD Test which might be of value for refactoring but are now private vars.
    *
    @Test
    public function testGetStateByNameShouldUseNullPattern():Void {
        var unknownStateName:String = "foo";

        var result:IState = _instance.getStateByUID(unknownStateName);

        Assert.isNotNull(result);
        Assert.areEqual(SubStateMachine.UNKNOWN_STATE, result);
    }

    @Test
    public function testGetStateByNameShouldReturnKnownState():Void {
        var state:IState=createStoppedState();
        _instance.addState(state);
        var knownStateName:String=state.name;

        var result:IState=_instance.getStateByUID(knownStateName);

        Assert.areEqual(state, result);
    }

    @Test
    public function testFindPathShouldForBothUnknownStates():Void {
        var unknownStartName:String = "foo";
        var unknownEndName:String = "bar";

        var result:Array<Int> = _instance.findPath(unknownStartName, unknownEndName);

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(0, result[0]); // "expected froms incorrect"
        Assert.areEqual(0, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testFindPathShouldReturnZeroWhenStartUnknown():Void {
        var unknownStartName:String="foo";
        var endState:IState=createFromWildCardState();
        var knowEndName:String=endState.name;
        _instance.addState(endState);

        var result:Array<Int> = _instance.findPath(unknownStartName, knowEndName);

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(0, result[0]); // "expected froms incorrect"
        Assert.areEqual(0, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testFindPathShouldReturnZeroWhenEndUnknown():Void {
        var startState:IState=createFromWildCardState();
        var knowStartName:String=startState.name;
        _instance.addState(startState);
        var unknownEndName:String="foo";

        var result:Array<Int> = _instance.findPath(knowStartName, unknownEndName);

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(0, result[0]); // "expected froms incorrect"
        Assert.areEqual(0, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testFindPathShouldReturnExpectedForOneToOnePath():Void {
        var startState:IState=createStoppedState();
        var startStateName:String=startState.name;
        _instance.addState(startState);
        var endState:IState=createPlayingState();
        var endStateName:String=endState.name;
        _instance.addState(endState);

        var result:Array<Int> = _instance.findPath(startStateName, endStateName);

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(1, result[0]); // "expected froms incorrect"
        Assert.areEqual(1, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testFindPathShouldReturnExpectedForLongPath():Void {
        setupQuakeStateExample();

        var result:Array<Int> = _instance.findPath("idle", "punch");

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(1, result[0]); // "expected froms incorrect"
        Assert.areEqual(3, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testFindPathShouldReturnExpectedForLongPathReversed():Void {
        setupQuakeStateExample();

        var result:Array<Int> = _instance.findPath("punch", "idle");

        Assert.isNotNull(result);
        Assert.areEqual(2, result.length);
        Assert.areEqual(3, result[0]); // "expected froms incorrect"
        Assert.areEqual(1, result[1]); // "expected tos incorrect"
    }

    @Test
    public function testGetParentByNameShouldReturnUnknownStateIfNotKnown():Void {
        var unknownStateName:String = "foo";

        var result:IState = _instance.getParentStateByName(unknownStateName);

        Assert.isNotNull(result); // "expecting Null Pattern"
        Assert.areEqual(StateMachine.UNKNOWN_STATE, result);
    }

    @Test
    public function testGetParentByNameShouldReturnUnknownParentStateIfParentNotKnown():Void {
        var knownChildState:IState = createChildState();
        _instance.addState(knownChildState);
        var knownChildStateName:String=knownChildState.name;

        var result:IState=_instance.getParentStateByName(knownChildStateName);

        Assert.isNotNull(result); // "expecting Null Pattern"
        Assert.areEqual(StateMachine.UNKNOWN_PARENT_STATE, result);
    }

    @Test
    public function testGetParentByNameShouldReturnParentStateOfChildState():Void {
        var childState:IState = createChildState();
        _instance.addState(childState);
        var knownChildStateName:String = childState.name;
        var expectedParentState:IState = createParentState();
        _instance.addState(expectedParentState);

        var result:IState=_instance.getParentStateByName(knownChildStateName);

        Assert.isNotNull(result); // "expecting Null Pattern"
        Assert.areEqual(expectedParentState, result);
    }

    @Test
    public function testGetParentByNameShouldReturnNoParentStateForChildWithNoParent():Void {
        var stateWithNoParent:IState=createFirstState();
        _instance.addState(stateWithNoParent);
        var stateWithNoParentName:String=stateWithNoParent.name;

        var result:IState=_instance.getParentStateByName(stateWithNoParentName);

        Assert.isNotNull(result); // "expecting Null Pattern"
        Assert.areEqual(StateMachine.NO_PARENT_STATE, result);
    }
    **/

    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function createPlayingState():IState {
        return new StateBuilder()
            .build(
                "playing",
                {
                    enter: mock(IEnter),
                    exit: mock(IExit),
                    from: "paused,stopped"
                }
            );
    }

    private function createPausedState():IState {
        return new StateBuilder()
            .build(
                "paused",
                {
                    enter: mock(IEnter),
                    from: "playing"
                }
            );
    }

    private function createStoppedState():IState {
        return new StateBuilder()
            .build(
                "stopped",
                {
                    enter: mock(IEnter),
                    from: "*"
                }
            );
    }

    private function createFirstState():IState {
        return new StateBuilder()
            .build(
                "first",
                {
                    enter: mock(IEnter),
                    exit: mock(IExit),
                    from: "second"
                }
            );
    }

    private function createSecondState():IState {
        return new StateBuilder()
            .build(
                "second",
                {
                    enter: mock(IEnter),
                    exit: mock(IExit),
                    from: "first"
                }
            );
    }

    private function createParentState():IState {
        return new StateBuilder()
            .build(
                "parent",
                {
                    enter: mock(IEnter),
                    exit: mock(IExit)
                }
            );
    }

    private function createChildState():IState {
        return new StateBuilder()
            .build(
                "child",
                {
                    parent: "parent",
                    enter: mock(IEnter),
                    exit: mock(IExit),
                    from: "first"
                }
            );
    }

    private function createGrandChildState():IState {
        return new StateBuilder()
            .build(
                "grandChild",
                {
                    parent:"child",
                    enter: mock(IEnter),
                    exit: mock(IExit),
                    from: "first"
                }
            );
    }

    /**
	 * It's also possible to create hierarchical state machines using the argument "parent" in the addState method
	 * This example shows the creation of a hierarchical state machine for the monster of a game
	 *(Its a simplified version of the state machine used to control the AI in the original Quake game)
	 **/
    private function setupQuakeStateExample():StringMap<IState> {
        // Create Map for looking up states by name
        var stateMap = new StringMap<IState>();
        stateMap.set("idle", new StateBuilder().build("idle", { enter: mock(IEnter), from: "attack" }));
        stateMap.set("attack", new StateBuilder().build("attack", { enter: mock(IEnter), from: "idle" }));
        stateMap.set("melee attack", new StateBuilder().build("melee attack", { parent: "attack", enter: mock(IEnter), exit: mock(IExit), from: "attack" }));
        stateMap.set("smash", new StateBuilder().build("smash", { parent: "melee attack", enter: mock(IEnter) }));
        stateMap.set("punch", new StateBuilder().build("punch", { parent: "melee attack", enter: mock(IEnter) }));
        stateMap.set("missle attack", new StateBuilder().build("missle attack", { parent: "attack", enter: mock(IEnter) }));
        stateMap.set("die", new StateBuilder().build("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));

        //Add States
        for (state in stateMap) {
            _instance.addState(state);
        }
        _instance.initialState="idle";

        return stateMap;
    }

    private function createNullPatternTestState():IState {
        return new StateBuilder()
            .build(
                "nullPatternTest",
                {}
            );
    }

    private function createFromWildCardState():IState {
        return new StateBuilder()
            .build(
                "fromWildCardTest",
                {
                    from: SubStateMachine.WILDCARD
                }
            );
    }
}