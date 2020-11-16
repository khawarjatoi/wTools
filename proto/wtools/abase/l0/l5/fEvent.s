( function _fEvent_s_()
{

'use strict';

let _global = _global_;
let _ = _global_.wTools;
let Self = _.event = _.event || Object.create( null );

// --
// implementation
// --

function _chainGenerate( args )
{
  let chain = [];

  _.assert( arguments.length === 1 );
  _.assert( _.longIs( args ) );

  for( let a = 0 ; a < args.length-2 ; a++ )
  chainMake( a );

  chain.push([ _.event.nameValueFrom( args[ args.length-2 ] ), args[ args.length-1 ] ]);

  _.assert( _.routineIs( args[ args.length-1 ] ) );

  return chain;

  /* */

  function chainMake( a )
  {
    let e1 = _.event.nameValueFrom( args[ a ] );
    // let e2 = _.event.nameValueFrom( args[ a+1 ] ); /* Dmytro : the variable is not used in scope */
    chain.push([ e1, on ]);
    function on()
    {
      let self = this;
      let next = chain[ a + 1 ];

      if( _.routineIs( self.on ) )
      {
        /*
            Dmytro : it is strange code because the owners of ehandler can be classes like Process.
            And this solution allows direct call of callbacks when the routine eventGive is not used :
            https://github.com/Wandalen/wProcess/blob/master/proto/wtools/abase/l4_process/Basic.s#L210
            https://github.com/Wandalen/wProcedure/blob/master/proto/wtools/abase/l8_procedure/Namespace.s#L59
        */
        self.on( next[ 0 ], next[ 1 ] );
        if( self.eventHasHandler( e1, on ) )
        self.off( e1, on );
      }
      else
      {
        let o = _.event.on.head( _.event.on, next );
        _.event.on( self, o );

        if( _.event.eventHasHandler( self, { eventName : e1, eventHandler : on } ) )
        _.event.off( self, { callbackMap : { [ e1 ] : on } } );
      }

      // this.on( next[ 0 ], next[ 1 ] ); /* Dmytro : previous implementation, use routines of _.process */
      // if( this.eventHasHandler( e1, on ) )
      // {
      //   this.off( e1, on );
      // }
    }
  }
}

//

function _chainToCallback( args )
{
  let chain = _.event._chainGenerate( args );
  let firstPair = chain[ 0 ];
  return firstPair[ 1 ];
}

//

function _chainValidate( chain )
{

  for( let i = 0 ; i < chain.length - 1 ; i++ )
  {
    _.assert( _.event.nameIs( chain[ i ] ) );
  }
  _.assert( _.routineIs( chain[ chain.length - 1 ] ) );

  return true;
}

//

function _callbackMapValidate( callbackMap )
{

  _.assert( _.mapIs( callbackMap ) );
  for( let k in callbackMap )
  {
    let callback = callbackMap[ k ];
    _.assert( _.routineIs( callback ) || _.longIs( callback ) );
    if( _.routineIs( callback ) )
    continue;
    _.event._chainValidate( callback );
  }

}

//

function nameValueFrom( name )
{
  if( _.strIs( name ) )
  return name;
  _.assert( _.event.nameIs( name ) );
  return name.value;
}

//

function nameIs( name )
{
  return name instanceof Name;
}

//

/**
 * The routine chainIs() checks of whether the passed value {-src-} is an instance of wTools.event.Chain.
 *
 * @example
 * var chain = { chain : [ 'event1', 'event2' ] };
 * console.log( _.event.chainIs( chain ) );
 * // log : false
 *
 * @example
 * var chain = _.event.chain( 'event1', 'event2' );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 *
 * @param { * } src - The value to check.
 * @returns { Boolean } - Returns true if {-src-} is an instance of class wTools.event.Chain.
 * Otherwise, routine returns false.
 * @function chainIs
 * @namespace wTools.event
 * @extends Tools
 */

function chainIs( src )
{
  return src instanceof Chain;
}

//

/* xxx aaa for Dmytro : introduce mini-class _.event.Chain() // Dmytro : introduced, covered
_.process.on( 'available', _.event.Name( 'exit' ), _.event.Name( 'exit' ), _.procedure._eventProcessExitHandle )
->
_.process.on( _.event.Chain( 'available', 'exit', 'exit' ), _.procedure._eventProcessExitHandle )
aaa for Dmytro : restrict routines _.*.on() to accept 2 arguments // Dmytro : restricted for _.event before I'd seen this task, improved routine on_head for another namespaces
*/

function Name( name )
{
  if( !( this instanceof Name ) )
  {
    if( _.event.nameIs( name ) )
    return name;
    return new Name( ... arguments );
  }
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );
  this.value = name;
  return this;
}

Name.prototype = Object.create( null );

//

/**
 * The routine Chain() implements class Chain. The instance of the class holds chain of event names.
 *
 * @example
 * var chain = _.event.chain( 'event1', 'event2' );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 * console.log( chain.chain );
 * // log : [ 'event1', 'event2' ]
 *
 * @example
 * var name1 = _.event.Name( 'event1' );
 * var name2 = _.event.Name( 'event2' );
 * var chain = _.event.chain( name1, name2 );
 * console.log( _.event.chainIs( chain ) );
 * // log : true
 * console.log( chain.chain.length );
 * // log : 2
 * console.log( chain.chain[ 0 ] === name1 );
 * // log : true
 * console.log( chain.chain[ 1 ] === name2 );
 * // log : true
 *
 * @param { String|wTools.event.Name|wTools.event.Chain } ... arguments - The set of event names of single instance of Chain.
 * @returns { wTools.event.Chain } - Returns instance of class.
 * @function Chain
 * @class wTools.event.Chain
 * @throws { Error } If arguments.length is less than 1.
 * @throws { Error } If arguments have incompatible type.
 * @throws { Error } If arguments contain instance of Chain and another elements.
 * @namespace wTools.event
 * @extends Tools
 */

function Chain()
{
  if( !( _.event.chainIs( this ) ) )
  {
    if( _.event.chainIs( arguments[ 0 ] ) )
    {
      _.assert( arguments.length === 1, 'Expects single Chain or set of event names' );
      return arguments[ 0 ];
    }

    return new Chain( ... arguments );
  }

  let result = _.arrayMake( arguments.length );
  _.assert( arguments.length >= 1, 'Expects events names' );
  for( let i = 0 ; i < arguments.length ; i++ )
  result[ i ] = _.event.Name( arguments[ i ] );

  this.chain = result;
  return this;
}

Chain.prototype = Object.create( null );

//

function on_head( routine, args )
{
  let o;

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );

  // _.assert( args.length >= 1 );

  // if( args.length > 1 ) /* Dmytro : deprecated feature, should be deleted */
  // {
  //   _.assert( _.strIs( args[ 0 ] ) );
  //   o = Object.create( null );
  //   o.callbackMap = Object.create( null );
  //   o.callbackMap[ args[ 0 ] ] = _.longShrink( args, 1 );
  // }
  if( args.length === 2 )
  {
    _.assert( _.routineIs( args[ 1 ] ) );

    o = Object.create( null );
    o.callbackMap = Object.create( null );

    if( _.event.chainIs( args[ 0 ] ) )
    {
      let chain = args[ 0 ].chain;
      o.callbackMap[ chain[ 0 ].value ] = _.longShrink( chain, 1 );
      o.callbackMap[ chain[ 0 ].value ].push( args[ 1 ] );
    }
    else if( _.strIs( args[ 0 ] ) )
    {
      o.callbackMap[ args[ 0 ] ] = args[ 1 ];
    }
    else if( _.event.nameIs( args[ 0 ] ) )
    {
      o.callbackMap[ args[ 0 ].value ] = args[ 1 ];
    }
    else
    {
      _.assert( 0, 'Expects Chain with names or single name of event.' );
    }
  }
  else if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    _.assert( 0, 'Expects single options map {-o-} or events Chain and callback as arguments.' );
  }

  if( Config.debug )
  {
    _.assert( _.mapIs( o ) );
    _.event._callbackMapValidate( o.callbackMap );
  }

  // _.event._callbackMapNormalize( o.callbackMap );

  return o;
}

//

function on( ehandler, o )
{

  // if( _.longIs( o.callbackMap ) )
  // o.callbackMap = callbackMapFromChain( o.callbackMap );

  _.routineOptions( on, o );
  _.assert( _.mapIs( o.callbackMap ) );
  _.assert( _.objectIs( ehandler ) );
  _.assert( _.objectIs( ehandler.events ) );
  _.assertMapHasOnly( o.callbackMap, ehandler.events, 'Unknown kind of event' );
  _.assert( arguments.length === 2 );

  for( let c in o.callbackMap )
  {
    let callback = o.callbackMap[ c ];

    if( _.longIs( callback ) )
    callback = _.event._chainToCallback( [ c, ... callback ] );

    _.assert( _.routineIs( callback ) );

    callback = callbackOn_functor( callback );

    if( o.first )
    _.arrayPrepend( ehandler.events[ c ], callback );
    else
    _.arrayAppend( ehandler.events[ c ], callback );

  }

  o.off = off_functor( ehandler, o.callbackMap );
  o.enabled = true;

  return o;

  /* */

  function callbackOn_functor( callback )
  {
    function callbackOn()
    {
      let result;
      if( o.enabled )
      result = callback.apply( this, arguments );
      return result;
    }
    callbackOn.native = callback;

    return callbackOn;
  }
}

on.head = on_head;
on.defaults =
{
  callbackMap : null,
  first : 0,
};

//

/**
 * The routine once() registers callback of some kind in event handler {-ehandler-}.
 * Registered callback executes once and deleted from queue.
 *
 * @example
 * let ehandler = { events : { begin : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * console.log( ehandler.events.begin.length );
 * // log : 0
 * _.event.once( ehandler, { callbackMap : { begin : onBegin } } );
 * console.log( ehandler.events.begin.length );
 * // log : 1
 * console.log( result );
 * // log : []
 *
 * @example
 * let ehandler = { events : { begin : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * _.event.once( ehandler, { callbackMap : { begin : onBegin } } );
 * _.event.eventGive( ehandler, 'begin' );
 * console.log( ehandler.events.begin.length );
 * // log : 0
 * console.log( result );
 * // log : [ 0 ]
 *
 * @example
 * let ehandler = { events : { begin : [], end : [] } };
 * let result = [];
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length + 1 );
 * let onEnd = result.splice();
 * _.event.once( ehandler, { callbackMap : { begin : onBegin } } );
 * _.event.once( ehandler, { callbackMap : { begin : onBegin2 } } );
 * _.event.once( ehandler, { callbackMap : { end : onEnd } } );
 * _.event.eventGive( ehandler, 'begin' );
 * console.log( ehandler.events.begin.length );
 * // log : 0
 * console.log( result );
 * // log : [ 0, 2 ]
 * _.event.eventGive( ehandler, 'end' );
 * console.log( result );
 * // log : []
 *
 * @param { Object } ehandler - The events handler with map of available events.
 * @param { Map|MapLike } o - Options map.
 * @param { Map } o.callbackMap - Map with pairs: [ eventName ] : [ callback ]. The value
 * [ callback ] can be a Function or Array with callbacks.
 * @param { Boolean|BoolLike } o.first - If it has value `true`, then callback prepends to callback queue.
 * Otherwise, callback appends to callback queue.
 * @returns { Map|MapLike } - Returns options map {-o-}.
 * @function once
 * @throws { Error } If arguments.length is not equal to 2.
 * @throws { Error } If {-ehandler-} is not an Object.
 * @throws { Error } If {-ehandler.events-} is not an Object.
 * @throws { Error } If {-o-} has incompatible type.
 * @throws { Error } If {-o-} has extra options.
 * @throws { Error } If {-o.callbackMap-} is not a Map.
 * @throws { Error } If {-o.callbackMap-} has events than does not exist in map {-ehandler.events-}.
 * @namespace wTools.event
 * @extends Tools
 */

function once( ehandler, o )
{

  _.routineOptions( once, o );
  _.assert( _.mapIs( o.callbackMap ) );
  _.assert( _.objectIs( ehandler ) );
  _.assert( _.objectIs( ehandler.events ) );
  _.assertMapHasOnly( o.callbackMap, ehandler.events, 'Unknown kind of event' );
  _.assert( arguments.length === 2 );

  for( let c in o.callbackMap )
  {
    let callback = o.callbackMap[ c ];

    if( _.longIs( callback ) )
    {
      let length = callback.length;
      _.assert( _.routineIs( callback[ length - 1 ] ), 'Expects routine to execute.' );

      let name = callback[ length - 2 ] || c;
      name = name.value !== undefined ? name.value : name;
      callback[ length - 1 ] = callbackOnce_functor( name, callback[ length - 1 ] );
      callback = _.event._chainToCallback( [ c, ... callback ] );
    }
    else
    {
      callback = callbackOnce_functor( c, callback );
    }

    _.assert( _.routineIs( callback ) );

    callbackAdd( ehandler, c, callback );
  }

  o.off = off_functor( ehandler, o.callbackMap );
  o.enabled = true;

  return o;

  /* */

  function callbackOnce_functor( name, callback )
  {
    function callbackOnce()
    {
      let result;
      if( o.enabled )
      {
        callback.apply( this, arguments );
        _.event.off( ehandler, { callbackMap : { [ name ] : callbackOnce } } );
      }
      return result;
    }
    callbackOnce.native = callback; /* Dmytro : this solution does not affects original callback and interfaces of calls. And simultaneously it slow down searching in routine `off` */

    return callbackOnce;
  }

  function callbackAdd( handler, name, callback )
  {
    if( o.first )
    _.arrayPrepend( handler.events[ name ], callback );
    else
    _.arrayAppend( handler.events[ name ], callback );
  }
}

once.head = on_head;
once.defaults =
{
  callbackMap : null,
  first : 0,
};

//  aaa for Dmytro : implement /* Dmytro : implemented */
// let descriptor = _.procedure.on( 'terminationBegin', _handleProcedureTerminationBegin );
// descriptor.off();
// descriptor.enabled = false;
// _.procedure.eventHas( descriptor ); /* true */
// _.procedure.eventHas( descriptor.callback ); /* true */
// descriptoro.enabled = true;
// _.procedure.eventHas( descriptor ); /* true */
// _.procedure.eventHas( descriptor.callback ); /* true */

//

/**
 * The routine off() removes callback of some kind in event handler {-ehandler-}.
 *
 * @example
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length );
 * let ehandler = { events : { begin : [ onBegin, onBegin2 ] } };
 * _.event.off( ehandler, { callbackMap : { begin : onBegin } } );
 * console.log( ehandler.events.begin.length );
 * // log : 1
 * console.log( ehandler.events.begin[ 0 ] === onBegin2 );
 * // log : true
 *
 * @example
 * let onBegin = () => result.push( result.length );
 * let onBegin2 = () => result.push( result.length );
 * let ehandler = { events : { begin : [ onBegin, onBegin2 ] } };
 * _.event.off( ehandler, { callbackMap : { begin : null } } );
 * console.log( ehandler.events.begin.length );
 * // log : 0
 *
 * @param { Object } ehandler - The events handler with map of available events.
 * @param { Map|MapLike } o - Options map.
 * @param { Map } o.callbackMap - Map with pairs: [ eventName ] : [ callback ]. The value
 * [ callback ] can be a Function or Null. If null is provided, routine removes all callbacks.
 * @returns { Map|MapLike } - Returns options map {-o-}.
 * @function off
 * @throws { Error } If arguments.length is not equal to 2.
 * @throws { Error } If {-ehandler-} is not an Object.
 * @throws { Error } If {-ehandler.events-} is not an Object.
 * @throws { Error } If {-o-} has incompatible type.
 * @throws { Error } If {-o-} has extra options.
 * @throws { Error } If {-o.callbackMap-} is not a Map.
 * @throws { Error } If {-o.callbackMap-} has events than does not exist in map {-ehandler.events-}.
 * @throws { Error } If {-ehandler.events-} callback queue has a few callbacks
 * which should be removed separately.
 * @namespace wTools.event
 * @extends Tools
 */

function off_head( routine, args )
{

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];
  if( args.length === 2 )
  o = { callbackMap : { [ args[ 0 ] ] : args[ 1 ] } }
  else if( _.strIs( args[ 0 ] ) )
  o = { callbackMap : { [ args[ 0 ] ] : null } }

  _.assert( _.mapIs( o ) );

  return o;
}

//

function off( ehandler, o )
{

  _.routineOptions( off, o );
  _.assert( _.mapIs( o.callbackMap ) );
  _.assert( _.objectIs( ehandler ) );
  _.assert( _.objectIs( ehandler.events ) );
  _.assertMapHasOnly( o.callbackMap, ehandler.events, 'Unknown kind of event' );
  _.assert( arguments.length === 2 );

  for( let c in o.callbackMap )
  {
    if( o.callbackMap[ c ] === null )
    _.arrayEmpty( ehandler.events[ c ] );
    else
    _.arrayRemoveOnceStrictly( ehandler.events[ c ], o.callbackMap[ c ], callbackEqualize );
  }

  return o;

  /* */

  function callbackEqualize( callback, handler )
  {
    return handler === callback || handler === callback.native;
  }
}

off.head = off_head;
off.defaults =
{
  callbackMap : null,
}

//

function off_functor( ehandler, o )
{
  return function( o2 )
  {
    _.assert( arguments.length === 0 || arguments.length === 1, 'Expects single options map {-o-} or no arguments.' );

    if( o2 === undefined )
    {
      o2 = { callbackMap : o };
    }
    else if( _.strIs( o2 ) )
    {
      let callback = o[ o2 ];
      _.assert( _.routineIs( callback ) );
      o2 = { callbackMap : { [ o2 ] : callback } };
    }
    else if( !_.mapIs( o2 ) )
    {
      _.assert( 0, 'Expects options map {-o-} or event name.' );
    }

    return _.event.off( ehandler, o2 );
  }
}

//

function eventHasHandler_head( routine, args )
{
  let o;

  _.assert( _.longIs( args ) );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );

  if( args.length > 1 )
  {
    o = Object.create( null );
    o.eventName = args[ 0 ];
    o.eventHandler = args[ 1 ];
  }
  else
  {
    o = args[ 0 ]
  }

  _.assert( _.mapIs( o ) );

  return o;
}

//

/* xxx */
function eventHasHandler( ehandler, o )
{

  _.routineOptions( eventHasHandler, o );
  _.assert( _.strIs( o.eventName ) );
  _.assert( _.routineIs( o.eventHandler ) );
  _.assert( _.mapIs( ehandler ) );
  _.assert( _.mapIs( ehandler.events ) );
  _.assert( arguments.length === 2 );

  return _.longHas( ehandler.events[ o.eventName ], o.eventHandler, handlerEqualize );

  /* */

  function handlerEqualize( callback, handler )
  {
    return handler === callback || handler === callback.native;
  }
}

eventHasHandler.head = eventHasHandler_head;
eventHasHandler.defaults =
{
  eventName : null,
  eventHandler : null,
}

//

function eventGive( ehandler, o )
{
  if( _.strIs( o ) )
  o = { event : o }

  _.routineOptions( eventGive, o );

  if( o.onError === null )
  o.onError = onError;
  if( o.args === null )
  {
    o.args = [ Object.create( null ) ];
    o.args[ 0 ].event = o.event;
  }

  _.assert( !!ehandler.events[ o.event ], `Unknown event ${o.event}` );
  _.assert( _.longIs( o.args ) );
  _.assert( arguments.length === 2 );

  let was;
  let visited = [];
  do
  {
    was = visited.length;
    let events = ehandler.events[ o.event ].slice();
    _.each( events, ( callback ) =>
    {
      if( _.longHas( visited, callback ) )
      return;
      visited.push( callback );
      try
      {
        // callback.apply( _.process, o.args ); /* Dmytro : it allows use different handlers instead of _.process._ehandler */
        callback.apply( ehandler, o.args );
      }
      catch( err )
      {
        o.onError( err, o );
      }
    });
  }
  while( was !== visited.length );

  /* */

  function onError( err, o )
  {
    throw _.err( `Error on handing event ${o.event}\n`, err );
  }

}

eventGive.defaults =
{
  event : null,
  args : null,
  onError : null,
}

// --
// extension
// --

let Extension =
{

  _chainGenerate,
  _chainToCallback,
  _chainValidate,
  _callbackMapValidate,

  nameValueFrom,
  nameIs,
  chainIs,
  Name,
  Chain,

  on, /* aaa : cover please, take into accout chain case */ /* Dmytro : covered */
  once,
  off, /* aaa : cover please */ /* Dmytro : covered */
  off_functor,

  eventHasHandler, /* aaa : cover please */ /* Dmytro : covered */
  eventGive, /* aaa : cover please */ /* Dmytro : covered */

}

_.mapSupplement( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
