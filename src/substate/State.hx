package substate;

import String;

class State implements IState {
	//----------------------------------
	//  CONSTS
	//----------------------------------
	public static var NO_ENTER:IEnter = new NoopEnter();
    public static var NO_EXIT:IExit = new NoopExit();
	public static inline var WILDCARD:String= "*";
	public static inline var NO_PARENT:String = null;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------
	public function new(stateName:String, params:Dynamic = null){
		name = stateName;
		if (params == null ){
            params = {};
		}

        onEnter = Reflect.hasField(params, "enter") ? cast Reflect.getProperty(params, "enter") : NO_ENTER;
        onExit = Reflect.hasField(params, "exit") ? cast Reflect.getProperty(params, "exit") : NO_EXIT;
        parentName = Reflect.hasField(params, "parent") ? cast Reflect.getProperty(params, "parent") : NO_PARENT;
        froms = getFroms(params);
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

    /** the parent States ID(optional)**/
    public var parentName(default, null):String;

    /** enter state Handler(optional)**/
    public var onEnter(default, null):IEnter;

    /** exit state Handler(optional)**/
    public var onExit(default, null):IExit;

    /** the States which can transition to this State
	 * will default to *(WILDCARD)is not set
	 **/
    public var froms(default, null):Array<String>;

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