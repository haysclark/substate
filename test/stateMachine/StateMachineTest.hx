package stateMachine;

import haxe.ds.StringMap;
import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class StateMachineTest 
{
    //----------------------------------
    //  vars
    //----------------------------------
	private var _instance:StateMachine;

    //--------------------------------------------------------------------------
    //
    //  SETUP
    //
    //--------------------------------------------------------------------------
    public function new() { }

    @Before
	public function setup():Void {
		_instance = new StateMachine();
		_instance.init();
	}
	
	@After
	public function tearDown():Void {
		_instance = null;
	}

    //--------------------------------------------------------------------------
    //
    //  TESTS
    //
    //--------------------------------------------------------------------------
/**
    @Test
    public function test_UNINITIAL_STATE_IsExpectedValue():Void {
        var expected:String="uninitializedState";

        Assert.areEqual(expected, StateMachine.UNINITIALIZED_STATE);
    }

    @Test
    public function testStateShouldBeInitializedTo_NO_STATE():Void {
        var expected:String=StateMachine.UNINITIALIZED_STATE;

        Assert.areEqual(expected, _instance.state);
    }

    @Test
    public function testHasStateByNameShouldReturnFalseForUnknownState():Void {
        var unknownStateName:String = "foo";

        var result:Bool = _instance.hasStateByName(unknownStateName);

        Assert.isFalse(result); //"expecting hasStateByName to return false for unknown state"
    }

    @Test
    public function testHasStateByNameShouldReturnTrueForKnownState():Void {
        var knownState:IState=createPlayingState();
        var expectedKnownStateName:String=knownState.name;
        _instance.addState(createPlayingState());

        var result:Bool=_instance.hasStateByName(expectedKnownStateName);

        Assert.isTrue(result); //"expecting hasStateByName to return true for known state"
    }

    @Test
    public function testAddStateShouldNotChangeCurrentState():Void {
        var expected:String=StateMachine.UNINITIALIZED_STATE;

        _instance.addState(createPlayingState());

        Assert.areEqual(expected, _instance.state);
    }

    @Test
    public function testAddStateShouldTakeIStateArgument():Void {
        var knownState:IState = mock(IState);

        _instance.addState(createPlayingState());
    }

    @Test
    public function testAddStateShouldBeCallableMultipleTimes():Void {
        _instance.addState(createPlayingState());
        _instance.addState(createPausedState());
        _instance.addState(createStoppedState());
    }

    @Test
    public function testInitialStateShouldNoChangeForUnknownState():Void {
        var expected:String=StateMachine.UNINITIALIZED_STATE;
        var unknownState:String="foo";

        _instance.initialState=unknownState;

        Assert.areEqual(expected, _instance.state);
    }

    @Test
    public function testInitialStateShouldNotBeNull():Void {
        Assert.isNotNull(_instance.state);
    }

    @Test
    public function testInitialStateShouldBeSetableToKnownState():Void {
        var initialState:IState=createStoppedState();
        var expectedInitialStateName:String=initialState.name;
        _instance.addState(initialState);

        _instance.initialState=expectedInitialStateName;

        Assert.areEqual(expectedInitialStateName, _instance.state);
    }

    @Test
    public function testIStateMock():Void {
        var mockmock = Mockatoo.mock(IEnter);
        mockmock.enter("a", "b", "c");

        mockmock.enter(cast anyString, cast anyString, cast anyString).verify();
    }
**/

    @Test
    public function testInitialStateShouldCallEnterCallbackOfNewState():Void {
        var mockmock = Mockatoo.mock(IEnter);
        var initialState:IState = new State(
            "stopped",
            {
                enter: mockmock,
                from: "*"
            }
        );
        _instance.addState(initialState);
        _instance.initialState = initialState.name;

       // mockmock.enter(cast anyString, cast anyString, cast anyString).verify();
        mockmock.enter("stopped", null, "stopped").verify();
    }

/**
    @Test
    public function testInitialStateShouldCallEnterCallbackWithExpectedArguments():Void {
        var initialState:IState = createStoppedState();
        _instance.addState(initialState);

        _instance.initialState = initialState.name;

        initialState.onEnter.enter(initialState.name, cast any, cast anyString)
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
    public function testCanChangeStateToShouldReturnFalseForUnknownState():Void {
        var unknownStateName:String = "foo";

        var result:Bool = _instance.canChangeStateTo(unknownStateName);

         Assert.isFalse(result);
    }

    @Test
    public function testCanChangeStateToShouldReturnFalseForSameState():Void {
        var initialState:IState = createPausedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var sameStateName:String = initialState.name;

        var result:Bool = _instance.canChangeStateTo(sameStateName);

         Assert.isFalse(result);
    }

    @Test
    public function testCanChangeStateToShouldTrueWhenNewStatesFromIsWildcard():Void {
        var initialState:IState = createStoppedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState:IState = createFromWildCardState();
        _instance.addState(nextState);

        var result:Bool = _instance.canChangeStateTo(nextState.name);

        Assert.isTrue(result);
    }

    @Test
    public function testCanChangeStateToShouldTrueWhenNewStatesFromIncludeCurrentState():Void {
        var initialState:IState=createStoppedState();
        _instance.addState(initialState);
        _instance.initialState=initialState.name;
        var nextState:IState=createPlayingState();
        _instance.addState(nextState);

        var result:Bool=_instance.canChangeStateTo(nextState.name);

        Assert.isTrue(result);
    }

    @Test
    public function testCanChangeStateToShouldTrueWhenParentStateIncludesDestinationState():Void {
        setupQuakeStateExample();

        var result:Bool=_instance.canChangeStateTo("smash");

        Assert.isTrue(result);
    }

    /////

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

    //////

    @Test
    public function testChangeStateShouldDoNothingForUnknownState():Void {
        var initialState:IState=createStoppedState();
        _instance.addState(initialState);
        _instance.initialState=initialState.name;
        var unknowStateName:String="foo";

        _instance.changeState(unknowStateName);

        Assert.areEqual(initialState.name, _instance.state);
    }

    @Test
    public function testChangeStateShouldDoNothingForIllegalStateTransition():Void {
        var initialState = createStoppedState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var illegalState = createPausedState();
        _instance.addState(illegalState);
        var illegalStateName:String = illegalState.name;

        _instance.changeState(illegalStateName);

        Assert.areEqual(initialState.name, _instance.state);
    }

    @Test
    public function testChangeStateShouldNotifyTransitionDeniedForIllegalStateTransition():Void {
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

        _instance.changeState(illegalStateName);

        mockObserver.transitionDenied(illegalState.name, initialState.name, cast any).verify();
        Assert.isNotNull(allowedFromStatesResult);
        Assert.areEqual(1, allowedFromStatesResult.length);
        Assert.areEqual(illegalState.froms, allowedFromStatesResult[0]);
    }

    @Test
    public function testChangeStateShouldCallFromStatesExitHandler():Void {
        var initialState = createFirstState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState = createSecondState();
        _instance.addState(nextState);
        var nextStateName:String = nextState.name;

        _instance.changeState(nextStateName);

        initialState.onExit.exit(cast any, cast any, cast any).verify();
    }

    @Test
    public function testChangeStateShouldCallFromStatesExitHandlerWithExpectedPayload():Void {
        var initialState = createFirstState();
        _instance.addState(initialState);
        _instance.initialState = initialState.name;
        var nextState = createSecondState();
        _instance.addState(nextState);
        var nextStateName:String = nextState.name;

        _instance.changeState(nextStateName);

        initialState.onExit.exit(initialState.name, nextState.name, initialState.name).verify();
    }

    @Test
    public function testChangeStateShouldBeAbleToNavigateToAChildState():Void {
        setupQuakeStateExample();

        Assert.areEqual("idle", _instance.state); // "not expected initial state"
        _instance.changeState("smash");
        Assert.areEqual("smash", _instance.state); // "not expected state after smash"
        _instance.changeState("idle");
        Assert.areEqual("idle", _instance.state); // "not expected state after return to idle"
    }

    @Test
    public function testChangeStateShouldBeAbleToNavigateToStateAndCallAllParentStateEnterCallbacks():Void {
        var mockOnAttack = mock(IEnter);
        var mockOnMeleeAttack = mock(IEnter);
        var mockOnSmash = mock(IEnter);

        _instance.addState(new State("idle", { enter: mock(IEnter), from: "attack" }));
        _instance.addState(new State("attack", { enter: mockOnAttack, from: "idle" }));
        _instance.addState(new State("melee attack", { parent: "attack", enter: mockOnMeleeAttack, exit: mock(IExit), from: "attack" }));
        _instance.addState(new State("smash", { parent: "melee attack", enter: mockOnSmash }));
        _instance.addState(new State("punch", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new State("missle attack", { parent: "attack", enter: mock(IEnter) }));
        _instance.addState(new State("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));
        _instance.initialState="idle";

        Assert.areEqual("idle", _instance.state); // "not expected initial state"
        _instance.changeState("smash");

        mockOnAttack.enter("smash", "idle", "attack").verify();
        mockOnMeleeAttack.enter("smash", "idle", "melee attack").verify();
        mockOnSmash.enter("smash", "idle", "smash").verify();

        _instance.changeState("idle");
        Assert.areEqual("idle", _instance.state); // "not expected state after return to idle",
    }

    @Test
    public function testChangeStateShouldCallExitStatesForParentsStates():Void {
        var mockOnExitMeleeAttack = mock(IExit);

        _instance.addState(new State("idle", { enter: mock(IEnter), from: "attack" }));
        _instance.addState(new State("attack", { enter: mock(IEnter), from: "idle" }));
        _instance.addState(new State("melee attack", { parent: "attack", enter: mock(IEnter), exit: mockOnExitMeleeAttack, from: "attack" }));
        _instance.addState(new State("smash", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new State("punch", { parent: "melee attack", enter: mock(IEnter) }));
        _instance.addState(new State("missle attack", { parent: "attack", enter: mock(IEnter) }));
        _instance.addState(new State("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));
        _instance.initialState="idle";

        _instance.changeState("smash");
        mockOnExitMeleeAttack.exit(cast any, cast any, cast any).verify(never);

        _instance.changeState("idle");
        mockOnExitMeleeAttack.exit("smash", "idle", "melee attack").verify();
    }
    **/

    /**
    @Test
    public function testGetStateByNameShouldUseNullPattern():Void {
        var unknownStateName:String = "foo";

        var result:IState = _instance.getStateByName(unknownStateName);

        Assert.isNotNull(result);
        Assert.areEqual(StateMachine.UNKNOWN_STATE, result);
    }

    @Test
    public function testGetStateByNameShouldReturnKnownState():Void {
        var state:IState=createStoppedState();
        _instance.addState(state);
        var knownStateName:String=state.name;

        var result:IState=_instance.getStateByName(knownStateName);

        Assert.areEqual(state, result);
    }
    **/

    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function createPlayingState():IState {
        return new State(
            "playing",
            {
                enter: mock(IEnter),
                exit: mock(IExit),
                from: "paused,stopped"
            }
        );
    }

    private function createPausedState():IState {
        return new State(
            "paused",
            {
                enter: mock(IEnter),
                from: "playing"
            }
        );
    }

    private function createStoppedState():IState {
        return new State(
            "stopped",
            {
                enter: mock(IEnter),
                from: "*"
            }
        );
    }

    private function createFirstState():IState {
        return new State(
            "first",
            {
                enter: mock(IEnter),
                exit: mock(IExit),
                from: "second"
            }
        );
    }

    private function createSecondState():IState {
        return new State(
            "second",
            {
                enter: mock(IEnter),
                exit: mock(IExit),
                from: "first"
            }
        );
    }

    private function createParentState():IState {
        return new State(
            "parent",
            {
                enter: mock(IEnter),
                exit: mock(IExit)
            }
        );
    }

    private function createChildState():IState {
        return new State(
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
        return new State(
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
        stateMap.set("idle", new State("idle", { enter: mock(IEnter), from: "attack" }));
        stateMap.set("attack", new State("attack", { enter: mock(IEnter), from: "idle" }));
        stateMap.set("melee attack", new State("melee attack", { parent: "attack", enter: mock(IEnter), exit: mock(IExit), from: "attack" }));
        stateMap.set("smash", new State("smash", { parent: "melee attack", enter: mock(IEnter) }));
        stateMap.set("punch", new State("punch", { parent: "melee attack", enter: mock(IEnter) }));
        stateMap.set("missle attack", new State("missle attack", { parent: "attack", enter: mock(IEnter) }));
        stateMap.set("die", new State("die", { enter: mock(IEnter), from: "attack", exit: mock(IExit) }));

        //Add States
        for (state in stateMap) {
            _instance.addState(state);
        }
        _instance.initialState="idle";

        return stateMap;
    }

    private function createNullPatternTestState():IState {
        return new State(
            "nullPatternTest",
            {}
        );
    }

    private function createFromWildCardState():IState {
        return new State(
            "fromWildCardTest",
            {
                from: State.WILDCARD
            }
        );
    }
}