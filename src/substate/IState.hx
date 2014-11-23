package substate;

interface IState extends IEnter extends IExit
{
	/** the state's UID **/
    var name(default, null):String;

	/** the parent state's UID (optional) **/
    var parentName(default, null):String;

    /**
     * the state UIDs which can transition to this state
	 * defaults to None.  Use WILDCARD to allow all states
	 **/
    var froms(default, null):Array<String>;
}