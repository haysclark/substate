package stateMachine;

class State implements IState
{
	//----------------------------------
	//  CONSTS
	//----------------------------------
	public static inline var NO_ENTER:IEnter=new NoopEnter();
	public static inline var NO_EXIT:IExit=new NoopExit();
	
	public static inline var WILDCARD:String="*";
	public static inline var NO_PARENT:String=null;
	
	//----------------------------------
	//  vars
	//----------------------------------
	private var _name:String;
	private var _parentName:String;
	private var _from:Array<Dynamic>;
	private var _onEnter:IEnter;
	private var _onExit:IExit;
	
	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------
	public function new(stateName:String, stateData:Dynamic=null){
		_name=stateName;
		if(stateData==null){
			stateData={};
		}
		
		if(!stateData.from){
			_from=[WILDCARD];
		} else if(stateData.from as Array){
			_from=stateData.from;
		} else if(stateData.from as String){
			_from=Std.string(stateData.from).split(",");
		}
		
		_onEnter=(stateData.enter)? stateData.enter:NO_ENTER;
		_onExit=(stateData.exit)? stateData.exit:NO_EXIT;
		
		_parentName=(stateData.parent)? stateData.parent:NO_PARENT;
	}
	
	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  IState
	//----------------------------------		
	public var name(get_name, null):String;
 	private function get_name():String {
		return _name;
	}
	
	public var from(get_from, null):Array;
 	private function get_from():Array {
		return _from;
	}
		
	public var onEnter(get_onEnter, null):IEnter;
 	private function get_onEnter():IEnter {
		return _onEnter;
	}
	
	public var onExit(get_onExit, null):IExit;
 	private function get_onExit():IExit {
		return _onExit;
	}
	
	public var parentName(get_parentName, null):String;
 	private function get_parentName():String {
		return _parentName;
	}
}