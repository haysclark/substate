package stateMachine;

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
	public function new(stateName:String, stateData:Dynamic = null){
		name = stateName;
		if (stateData == null ){
		 	stateData = {};
		}

		if(!stateData.from){
            froms = [WILDCARD];
		//} else if ($type(stateData.from) == Array<String>()) {
		// 	from = stateData.from;
		} else { //} if ($type(stateData.from) == String) {
           froms = Std.string(stateData.from).split(",");
		}

        onEnter = (stateData.enter) ? stateData.enter : NO_ENTER;
		onExit = (stateData.exit) ? stateData.exit : NO_EXIT;
		
		parentName = (stateData.parent) ? stateData.parent : NO_PARENT;
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