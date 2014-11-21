package substate;

import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class StateTest {

    @:mock
    public var mockIEnter:IEnter;

    @:mock
    public var mockIExit:IExit;

    //----------------------------------
    //  vars
    //----------------------------------
    private var _instance:State;

    //--------------------------------------------------------------------------
    //
    //  SETUP
    //
    //--------------------------------------------------------------------------
    public function new() { }

    @Before
    public function setup():Void {
        _instance = createTestState();
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
    @Test
    public function testNameIsSetToExpectExpectedValue():Void {
        var expected = "playing";

        Assert.areEqual(expected, _instance.name);
    }

    @Test
    public function testOnEnterIsSetToExpectExpectedValue():Void {
        var expected = mockIEnter;

        Assert.areEqual(expected, _instance.onEnter);
    }

    @Test
    public function testOnEnterIsSetToNoopWhenNotInParams():Void {
        var expected = State.NO_ENTER;
        _instance = createNoopTest();

        Assert.isNotNull(_instance.onEnter);
        Assert.areEqual(expected, _instance.onEnter);
    }

    @Test
    public function testOnExitIsSetToExpectExpectedValue():Void {
        var expected = mockIExit;

        Assert.areEqual(expected, _instance.onExit);
    }

    @Test
    public function testOnExitIsSetToNoopWhenNotInParams():Void {
        var expected = State.NO_EXIT;
        _instance = createNoopTest();

        Assert.isNotNull(_instance.onExit);
        Assert.areEqual(expected, _instance.onExit);
    }

    @Test
    public function testParentIsSetToExpectExpectedValue():Void {
        var expected = "root";

        Assert.areEqual(expected, _instance.parentName);
    }

    @Test
    public function testParentIsSetToNoopWhenNotInParams():Void {
        var expected = State.NO_PARENT;
        _instance = createNoopTest();

        Assert.areEqual(expected, _instance.parentName);
    }

    @Test
    public function testFromsAreSetToExpectedValuesFromCSVString():Void {
        Assert.isNotNull(_instance.froms);
        Assert.isTrue(_instance.froms.indexOf("paused") >= 0);
        Assert.isTrue(_instance.froms.indexOf("stopped") >= 0);
        Assert.areEqual(2, _instance.froms.length);
    }

    @Test
    public function testFromsAreSetToWildCardWhenNotInParams():Void {
        var expected = State.WILDCARD;
        _instance = createNoopTest();

        Assert.isNotNull(_instance.froms);
        Assert.isTrue(_instance.froms.indexOf(expected) >= 0);
        Assert.areEqual(1, _instance.froms.length);
    }

    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function createTestState():State {
        var params =  {
            enter: mockIEnter,
            exit: mockIExit,
            from: "paused,stopped",
            parent: "root"
        };
        return new State(
            "playing",
            params
        );
    }

    private function createNoopTest():State {
        return new State("noop");
    }
}
