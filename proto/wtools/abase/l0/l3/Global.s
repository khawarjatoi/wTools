( function _l3_Global_s_()
{

'use strict';

let _global = _global_;
let _ = _global_.wTools;
_global_.wTools.global = _global_.wTools.global || Object.create( null );

// --
// implementation
// --

function is( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.primitiveIs( src ) )
  return false;

  for( let namespace in _globals_ )
  {
    if( _globals_[ namespace ] === src )
    return true;
  }

  return false;
}

//

function isReal( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  // if( _.primitiveIs( src ) )
  // return false;

  if( src === _realGlobal_ && src.__GLOBAL_NAME__ === 'real' )
  return true;
  return false;
}

//

function isDerivative( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  // if( _.primitiveIs( src ) )
  // return false;

  if( _.global.is( src ) && !_.global.isReal( src ) )
  return true;
  return false;
}

// --
// extension
// --

var Extension =
{
  is,
  isReal,
  isDerivative
}

//

Object.assign( _.global, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
