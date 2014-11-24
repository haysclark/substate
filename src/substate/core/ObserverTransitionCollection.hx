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

package substate.core;

/**
 * A Collection class for IObserverTransitions which parrots
 * messages to subscribrers.
 * 
 * See Observer Pattern(GOF)
 */
class ObserverTransitionCollection implements IObserverTransition
{
	//----------------------------------
	//  vars
	//----------------------------------
	private var _observerTransitions:Array<IObserverTransition>;

    public function new():Void {}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function init():Void {
		_observerTransitions = new Array<IObserverTransition>();
	}
	
	public function destroy():Void {
		while(_observerTransitions.length > 0){
			unsubscribe(_observerTransitions.pop());
		}
		_observerTransitions = null;
	}
	
	public function subscribe(observer:IObserverTransition):Void {
		_observerTransitions.push(observer);
	}
	
	public function unsubscribe(observer:IObserverTransition):Void {
        _observerTransitions.remove(observer);
	}
	
	//----------------------------------
	//  IObserverTransition
	//----------------------------------
	public function transitionComplete(toState:String, fromState:String):Void {
		for (i in 0..._observerTransitions.length) {
			var observer:IObserverTransition = _observerTransitions[i];
            observer.transitionComplete(toState, fromState);
		}
    }

    public function transitionDenied(toState:String, fromState:String, allowedFromStates:Array<String>):Void {
        for (i in 0..._observerTransitions.length) {
			var observer:IObserverTransition = _observerTransitions[i];
			observer.transitionDenied(toState, fromState, allowedFromStates);
		}
	}
}