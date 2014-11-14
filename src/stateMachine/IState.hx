package stateMachine;

interface IState
{
	/** the ID of the State **/
	function get name():String;
	/** the parent States ID(optional)**/
	function get parentName():String;
	/** the States which can transition to this State
	 * will default to *(WILDCARD)is not set
	 **/
	function get from():Array<Dynamic>;
	/** enter state Handler(optional)**/
	function get onEnter():IEnter;
	/** exit state Handler(optional)**/
	function get onExit():IExit;
}