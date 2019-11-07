( function _Typing_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../Layer2.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function nothingIs( test )
{
  test.case = 'without argument';
  var got = _.nothingIs();
  test.identical( got, true );

  test.case = 'check null';
  var got = _.nothingIs( null );
  test.identical( got, true );

  test.case = 'check undefined';
  var got = _.nothingIs( undefined );
  test.identical( got, true );

  test.case = 'check _.nothing';
  var got = _.nothingIs( _.nothing );
  test.identical( got, true );

  /* */

  test.case = 'check zero';
  var got = _.nothingIs( 0 );
  test.identical( got, false );

  test.case = 'check empty string';
  var got = _.nothingIs( '' );
  test.identical( got, false );

  test.case = 'check false';
  var got = _.nothingIs( false );
  test.identical( got, false );

  test.case = 'check NaN';
  var got = _.nothingIs( NaN );
  test.identical( got, false );

  test.case = 'check empty array';
  var got = _.nothingIs( [] );
  test.identical( got, false );

  test.case = 'check empty arguments array';
  var got = _.nothingIs( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty unroll';
  var got = _.nothingIs( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty map';
  var got = _.nothingIs( {} );
  test.identical( got, false );

  test.case = 'check empty pure map';
  var got = _.nothingIs( Object.create( null ) );
  test.identical( got, false );

  test.case = 'check empty Set';
  var got = _.nothingIs( new Set( [] ) );
  test.identical( got, false );

  test.case = 'check empty Map';
  var got = _.nothingIs( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check empty BufferRaw';
  var got = _.nothingIs( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check empty BufferTyped';
  var got = _.nothingIs( new U8x() );
  test.identical( got, false );

  test.case = 'check number';
  var got = _.nothingIs( 3 );
  test.identical( got, false );

  test.case = 'check string';
  var got = _.nothingIs( 'str' );
  test.identical( got, false );

  test.case = 'check not empty array';
  var got = _.nothingIs( [ null ] );
  test.identical( got, false );

  test.case = 'check not empty map';
  var got = _.nothingIs( { '' : null } );
  test.identical( got, false );
}

function objectLike( t )
{

  t.description = 'array-like entities should not overlap with array-like entities set';

  t.identical( _.objectLike( new ArrayBuffer( 10 ) ),false );
  t.identical( _.objectLike( new Float32Array( 10 ) ),false );
  t.identical( _.objectLike( new Int32Array( 10 ) ),false );
  t.identical( _.objectLike( new DataView( new ArrayBuffer( 10 ) ) ),false );
  t.identical( _.objectLike( new Array( 10 ) ),false );
  t.identical( _.objectLike( [ 1,2,3 ] ),false );
  t.identical( _.objectLike( new Map ),false );

  t.description = 'this entities are object-like';

  t.identical( _.objectLike( _global_ ),true );
  t.identical( _.objectLike( new Object() ),true );
  t.identical( _.objectLike( {} ),true );
  t.identical( _.objectLike( Object.create( null ) ),true );

}

//

function consequenceLike( test )
{
  test.case = 'check if entity is a consequenceLike';

  if( !_.consequenceLike )
  return test.identical( true,true );

  test.is( !_.consequenceLike() );
  test.is( !_.consequenceLike( {} ) );
  test.is( _.consequenceLike( Promise.resolve( 0 ) ) );

  var promise = new Promise( ( resolve, reject ) => { resolve( 0 ) } )
  test.is( _.consequenceLike( promise ) );

}

//

function promiseIs( test )
{
  test.case = 'check if entity is a Promise';

  test.is( !_.promiseIs() );
  test.is( !_.promiseIs( {} ) );

  var _Promise = function Promise(){};
  test.is( !_.promiseIs( new _Promise() ) );

  test.is( _.promiseIs( Promise.resolve( 0 ) ) );

  var promise = new Promise( ( resolve, reject ) => { resolve( 0 ) } )
  test.is( _.promiseIs( promise ) );
}

//

function isPrototypeOf( test )
{

  test.case = 'map';
  var src = {};
  var got = _.isPrototypeOf( src, src );
  test.identical( got, true );
  var got = _.isPrototypeOf( Object.prototype, src );
  test.identical( got, true );
  var got = _.isPrototypeOf( src, Object.prototype );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, {} );
  test.identical( got, false );
  var got = _.isPrototypeOf( {}, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.isPrototypeOf( Object.create( null ), src );
  test.identical( got, false );
  var got = _.isPrototypeOf( null, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, null );
  test.identical( got, false );

  test.case = 'pure map';
  var src = Object.create( null );
  var got = _.isPrototypeOf( src, src );
  test.identical( got, true );
  var got = _.isPrototypeOf( src, Object.prototype );
  test.identical( got, false );
  var got = _.isPrototypeOf( Object.prototype, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, {} );
  test.identical( got, false );
  var got = _.isPrototypeOf( {}, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.isPrototypeOf( Object.create( null ), src );
  test.identical( got, false );
  var got = _.isPrototypeOf( null, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, null );
  test.identical( got, false );

  test.case = 'map chain';
  var prototype = Object.create( null );
  var src = Object.create( prototype );
  var got = _.isPrototypeOf( src, src );
  test.identical( got, true );
  var got = _.isPrototypeOf( prototype, src );
  test.identical( got, true );
  var got = _.isPrototypeOf( src, prototype );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, Object.prototype );
  test.identical( got, false );
  var got = _.isPrototypeOf( Object.prototype, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, {} );
  test.identical( got, false );
  var got = _.isPrototypeOf( {}, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, Object.create( null ) );
  test.identical( got, false );
  var got = _.isPrototypeOf( Object.create( null ), src );
  test.identical( got, false );
  var got = _.isPrototypeOf( null, src );
  test.identical( got, false );
  var got = _.isPrototypeOf( src, null );
  test.identical( got, false );

}

// --
// declaration
// --

var Self =
{

  name : 'Tools.base.Typing',
  silencing : 1,

  tests :
  {

    nothingIs,

    objectLike,
    consequenceLike,
    promiseIs,

    isPrototypeOf,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
