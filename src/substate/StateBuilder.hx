package substate;

import String;

class StateBuilder {
    private static var NO_ENTER:IEnter = new NoopEnter();
    private static var NO_EXIT:IExit = new NoopExit();

    public function new() {}
}

private class State implements IState {
    //----------------------------------
    //  vars
    //----------------------------------
    private var _onEnter:IEnter;
    private var _onExit:IExit;

    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    public function new() {}

    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    public function build(stateName:String, params:Dynamic = null):IState {
        var state = new State(stateName);
        name = stateName;
        if (params == null ){
            params = {};
        }
        parentName = Reflect.hasField(params, "parent") ? cast Reflect.getProperty(params, "parent") : NO_PARENT;
        froms = getFroms(params);
        _onEnter = Reflect.hasField(params, "enter") ? cast Reflect.getProperty(params, "enter") : NO_ENTER;
        _onExit = Reflect.hasField(params, "exit") ? cast Reflect.getProperty(params, "exit") : NO_EXIT;
    }

    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  IState
    //----------------------------------
    public var name(default, null):String;

    /**
     * the parent States ID(optional)
     **/
    public var parentName(default, null):String;

    /**
     * the States which can transition to this State
	 * will default to *(WILDCARD)is not set
	 **/
    public var froms(default, null):Array<String>;

    public function enter(toState:String, fromState:String, currentState:String):Void {
        _onEnter.enter(toState, fromState, currentState);
    }

    public function exit(fromState:String, toState:String, currentState:String = null):Void {
        _onExit.exit(fromState, toState, currentState);
    }

    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function getFroms(data:Dynamic):Array<String> {
        var froms:Array<String> = new Array<String>();
        if(!Reflect.hasField(data, "from")) {
            froms.push(WILDCARD);
        } else {
            var fromData:String = cast Reflect.getProperty(data, "from");
            froms = Std.string(fromData).split(",");
        }
        return froms;
    }
}

private class State implements IState {
    //--------------------------------------------------------------------------
    //
    //  CONSTRUCTOR
    //
    //--------------------------------------------------------------------------
    public function new(uid:String) {
        name = uid;
    }

    //----------------------------------
    //  IState
    //----------------------------------
    public var name(default, null):String;
    public var parentName(default, null):String;
    public var froms(default, null):Array<String>;
    public function enter(toState:String, fromState:String, currentState:String):Void {}
    public function exit(fromState:String, toState:String, currentState:String = null):Void {}
}

private class NoopEnter implements IEnter {

    public function new() {}

    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  IState
    //----------------------------------
    public function enter(toState:String, fromState:String, currentState:String):Void {
        //
    }
}

private class NoopExit implements IExit {

    public function new() {}

    //--------------------------------------------------------------------------
    //
    //  PUBLIC METHODS
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  IState
    //----------------------------------
    public function exit(fromState:String, toState:String, currentState:String = null):Void {
        //
    }
}