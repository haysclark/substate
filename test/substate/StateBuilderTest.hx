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
