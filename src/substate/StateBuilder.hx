package substate;

import substate.SubStateMachine;
import substate.SubStateMachine;

class StateBuilder {
    //----------------------------------
    //  CONSTS
    //----------------------------------
    private static var NO_ENTER:IEnter = new NoopEnter();
    private static var NO_EXIT:IExit = new NoopExit();

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
        if (params == null ){
            params = {};
        }

        var parentName = Reflect.hasField(params, "parent") ? cast Reflect.getProperty(params, "parent") : SubStateMachine.NO_PARENT;
        var froms = getFroms(params);
        var onEnter = Reflect.hasField(params, "enter") ? cast Reflect.getProperty(params, "enter") : NO_ENTER;
        var onExit = Reflect.hasField(params, "exit") ? cast Reflect.getProperty(params, "exit") : NO_EXIT;

        return new BuiltState(
            stateName,
            parentName,
            froms,
            onEnter,
            onExit
        );
    }

    //--------------------------------------------------------------------------
    //
    //  PRIVATE METHODS
    //
    //--------------------------------------------------------------------------
    private function getFroms(data:Dynamic):Array<String> {
        var froms:Array<String> = new Array<String>();
        if(Reflect.hasField(data, "from")) {
            var fromData:String = cast Reflect.getProperty(data, "from");
            froms = Std.string(fromData).split(",");
        }
        return froms;
    }
}

private class BuiltState implements IState {
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
    public function new(stateName:String, stateParentName:String, stateFroms:Array<String>, enter:IEnter, exit:IExit) {
        name = stateName;
        parentName = stateParentName;
        froms = stateFroms;
        _onEnter = enter;
        _onExit = exit;
    }

    //----------------------------------
    //  IState
    //----------------------------------
    public var name(default, null):String;
    public var parentName(default, null):String;
    public var froms(default, null):Array<String>;

    public function enter(toState:String, fromState:String, currentState:String):Void {
        _onEnter.enter(toState, fromState, currentState);
    }
    public function exit(fromState:String, toState:String, currentState:String = null):Void {
        _onExit.exit(fromState, toState, currentState);
    }
}

private class NoopEnter implements IEnter {
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
    //----------------------------------
    //  IState
    //----------------------------------
    public function enter(toState:String, fromState:String, currentState:String):Void {
        //
    }
}

private class NoopExit implements IExit {
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
    //----------------------------------
    //  IState
    //----------------------------------
    public function exit(fromState:String, toState:String, currentState:String = null):Void {
        //
    }
}
