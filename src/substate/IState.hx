package substate;

interface IState
{
	/** the ID of the State **/
    var name(default, null):String;

	/** the parent States ID(optional)**/
    var parentName(default, null):String;

    /** enter state Handler(optional)**/
    var onEnter(default, null):IEnter;

    /** exit state Handler(optional)**/
    var onExit(default, null):IExit;

    /** the States which can transition to this State
	 * will default to *(WILDCARD)is not set
	 **/
    var froms(default, null):Array<String>;
}