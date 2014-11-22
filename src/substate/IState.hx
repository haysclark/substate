package substate;

interface IState extends IEnter extends IExit
{
	/** the ID of the State **/
    var name(default, null):String;

	/** the parent States ID(optional)**/
    var parentName(default, null):String;

    /** the States which can transition to this State
	 * will default to *(WILDCARD)is not set
	 **/
    var froms(default, null):Array<String>;
}