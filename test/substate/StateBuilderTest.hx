package substate;

import massive.munit.Assert;

import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class StateBuilderTest {

    //public var mockIEnter:IEnter;
    //public var mockIExit:IExit;

    //----------------------------------
    //  vars
    //----------------------------------
    private var _instance:StateBuilder;

    public function new() { }

    //--------------------------------------------------------------------------
    //
    //  SETUP
    //
    //--------------------------------------------------------------------------
    @Before
    public function setup():Void {
        _instance = new StateBuilder();
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
    public function testBuildShouldNotErrorIfNoParamsArgument():Void {
        var result = _instance.build("foo");
    }

    @Test
    public function testBuildShouldIState():Void {
        var expected = "playing";

        var result = _instance.build(expected);

        Assert.isNotNull(result);
    }

    @Test
    public function testBuildShouldSetNameToExpectedValue():Void {
        var expected = "playing";

        var result = _instance.build(expected);

        Assert.areEqual(expected, result.name);
    }

    @Test
    public function testBuildShouldSetParentNameToNoopWhenNotInParams():Void {
        var expected = SubStateMachine.NO_PARENT;

        var result = _instance.build("name");

        Assert.isNotNull(result.parentName);
        Assert.areEqual(expected, result.parentName);
    }

    @Test
    public function testBuildShouldSetParentNameToExpectedValue():Void {
        var expected = "root";
        var params = {
            parent: expected
        };

        var result = _instance.build("name", params);

        Assert.isNotNull(result.parentName);
        Assert.areEqual(expected, result.parentName);
    }

    @Test
    public function testBuildShouldSetFromsToEmptyArrayWhenNoValueInParams():Void {
        var expectedSize = 0;
        var params = {
        };

        var result = _instance.build("name", params);

        Assert.isNotNull(result.froms);
        Assert.areEqual(expectedSize, result.froms.length);
    }

    @Test
    public function testBuildShouldSetFromsToExpectedValuesFromCSVString():Void {
        var params = {
            from: "paused,stopped",
        };

        var result = _instance.build("name", params);

        Assert.isNotNull(result.froms);
        Assert.areEqual(2, result.froms.length);
        Assert.isTrue(result.froms.indexOf("paused") >= 0);
        Assert.isTrue(result.froms.indexOf("stopped") >= 0);
    }

    @Test
    public function testBuildShouldSetEnterToNoopWhenNotInParams():Void {
        var params = {
        };

        var result = _instance.build("name", params);

        Assert.isNotNull(result.enter);
        result.enter("a", "b", "c");
        // should not error
    }

    @Test
    public function testBuildShouldSetEnterToExpectedIEnter():Void {
        var mockIEnter:IEnter = mock(IEnter);
        var params = {
            enter: mockIEnter
        };
        var expectedA = "AAA";
        var expectedB = "BBB";
        var expectedC = "CCC";

        var result = _instance.build("foo", params);

        result.enter(expectedA, expectedB, expectedC);
        mockIEnter.enter(expectedA, expectedB, expectedC)
            .verify();
    }

    @Test
    public function testBuildShouldSetExitToNoopWhenNotInParams():Void {
        var params = {
        };

        var result = _instance.build("name", params);

        Assert.isNotNull(result.exit);
        result.exit("a", "b", "c");
        // should not error
    }

    @Test
    public function testBuildShouldSetExitToExpectedIExit():Void {
        var mockIExit:IExit = mock(IExit);
        var params = {
            exit: mockIExit
        };
        var expectedA = "AAA";
        var expectedB = "BBB";
        var expectedC = "CCC";

        var result = _instance.build("foo", params);

        result.exit(expectedA, expectedB, expectedC);
        mockIExit.exit(expectedA, expectedB, expectedC)
            .verify();
    }
}
