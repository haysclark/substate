package substate;

import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class StateTest {

    public var mockIEnter:IEnter;
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
    public function testEnterIsExecuted():Void {
        var expectedA = "AAA";
        var expectedB = "BBB";
        var expectedC = "CCC";

        _instance.enter(expectedA, expectedB, expectedC);

        mockIEnter.enter(expectedA, expectedB, expectedC)
            .verify();
    }

    @Test
    public function testOnEnterIsSetToNoopWhenNotInParams():Void {
        _instance = createNoopTest();

        Assert.isNotNull(_instance.enter);
        _instance.enter("a", "b", "c");
    }

    @Test
    public function testExitIsExecuted():Void {
        var expectedA = "AAA";
        var expectedB = "BBB";
        var expectedC = "CCC";

        _instance.exit(expectedA, expectedB, expectedC);

        mockIExit.exit(expectedA, expectedB, expectedC)
            .verify();
    }

    @Test
    public function testOnExitIsSetToNoopWhenNotInParams():Void {
        _instance = createNoopTest();

        Assert.isNotNull(_instance.exit);
        _instance.exit("a", "b", "c");
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
        mockIEnter = mock(IEnter);
        mockIExit = mock(IExit);

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
