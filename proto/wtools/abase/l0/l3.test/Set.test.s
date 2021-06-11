( function _l0_l3_Set_test_s_()
{
'use strict';

  if( typeof module !== 'undefined' )
  {
    const _ = require( '../Include3.s' );
    require( 'wTesting' );
  }

  const _global = _global_;
  const _ = _global.wTools;
  const __ = _globals.testing.wTools;

  // --
  // tests
  // --

  function aptLeft( test )
  {
    /* */

    test.case = 'left';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptLeft( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 1 )return val + 10;
    } );
    var exp = [ 11, 1, 0, true ];
    test.identical( got, exp );
    var exp = [ [ 1, 1, 0, src ] ];
    test.identical( ops, exp );

    /* */

    test.case = 'middle';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptLeft( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 2 )return val + 10;
    } );
    var exp = [ 12, 2, 1, true ];
    test.identical( got, exp );
    var exp = [
      [ 1, 1, 0, src ],
      [ 2, 2, 1, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'right';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptLeft( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 3 )return val + 10;
    } );
    var exp = [ 13, 3, 2, true ];
    test.identical( got, exp );
    var exp = [
      [ 1, 1, 0, src ],
      [ 2, 2, 1, src ],
      [ 3, 3, 2, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'no';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptLeft( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 4 )return val + 10;
    } );
    var exp = [ 3, 3, 2, false ];
    test.identical( got, exp );
    var exp = [
      [ 1, 1, 0, src ],
      [ 2, 2, 1, src ],
      [ 3, 3, 2, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'empty';
    var src = new Set( [] );
    var ops = [];
    var got = _.set.aptLeft( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 4 )return val + 10;
    } );
    var exp = [ undefined, undefined, -1, false ];
    test.identical( got, exp );
    var exp = [];
    test.identical( ops, exp );

    /* */

    test.case = 'without callback';
    var src = new Set( [ 1, 2, 3 ] );
    var exp = [ 1, 1, 0, true ];
    var got = _.set.aptLeft( src );
    test.identical( got, exp );
    var exp = [ 1, 1, 0, true ];
    var got = _.set.first( src );
    test.identical( got, exp );

    /* */

    test.case = 'without callback, empty';
    var src = new Set( [] );
    var exp = [ undefined, undefined, -1, false ];
    var got = _.set.aptLeft( src );
    test.identical( got, exp );
    var exp = [ undefined, undefined, -1, false ];
    var got = _.set.first( src );
    test.identical( got, exp );

    /* */
  }

  //

  function aptRight( test )
  {
    /* */

    test.case = 'left';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptRight( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 1 )return val + 10;
    } );
    var exp = [ 11, 1, 0, true ];
    test.identical( got, exp );
    var exp = [
      [ 3, 3, 2, src ],
      [ 2, 2, 1, src ],
      [ 1, 1, 0, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'middle';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptRight( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 2 )return val + 10;
    } );
    var exp = [ 12, 2, 1, true ];
    test.identical( got, exp );
    var exp = [
      [ 3, 3, 2, src ],
      [ 2, 2, 1, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'right';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptRight( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 3 )return val + 10;
    } );
    var exp = [ 13, 3, 2, true ];
    test.identical( got, exp );
    var exp = [ [ 3, 3, 2, src ] ];
    test.identical( ops, exp );

    /* */

    test.case = 'no';
    var src = new Set( [ 1, 2, 3 ] );
    var ops = [];
    var got = _.set.aptRight( src, function ( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 4 )return val + 10;
    } );
    var exp = [ 1, 1, 0, false ];
    test.identical( got, exp );
    var exp = [
      [ 3, 3, 2, src ],
      [ 2, 2, 1, src ],
      [ 1, 1, 0, src ],
    ];
    test.identical( ops, exp );

    /* */

    test.case = 'empty';
    var src = new Set( [] );
    var ops = [];
    var got = _.set.aptRight( src, function( val )
    {
      ops.push( Array.prototype.slice.call( arguments ) );
      if( val === 4 )
      return val + 10;
    } );
    var exp = [ undefined, undefined, -1, false ];
    test.identical( got, exp );
    var exp = [];
    test.identical( ops, exp );

    /* */

    test.case = 'without callback';
    var src = new Set( [ 1, 2, 3 ] );
    var exp = [ 3, 3, 2, true ];
    var got = _.set.aptRight( src );
    test.identical( got, exp );
    var exp = [ 3, 3, 2, true ];
    var got = _.set.last( src );
    test.identical( got, exp );

    /* */

    test.case = 'without callback, empty';
    var src = new Set( [] );
    var exp = [ undefined, undefined, -1, false ];
    var got = _.set.aptRight( src );
    test.identical( got, exp );
    var exp = [ undefined, undefined, -1, false ];
    var got = _.set.last( src );
    test.identical( got, exp );

    /* */
  }

  //

  function lengthOf( test )
  {
    test.case = 'no argument';
    var src = new Set();
    var got = _.set.lengthOf( src );
    var expected = 0;
    test.identical( got, expected );

    test.case = 'empty array';
    var src = new Set( [] );
    var got = _.set.lengthOf( src );
    var expected = 0;
    test.identical( got, expected );

    test.case = 'array of numbers';
    var src = new Set( [ 1, 2, 3 ] );
    var got = _.set.lengthOf( src );
    var expected = 3;
    test.identical( got, expected );

    test.case = 'array with undefined and boolean';
    var src = new Set( [ 1, undefined, false ] );
    var got = _.set.lengthOf( src );
    var expected = 3;
    test.identical( got, expected );

    test.case = 'extra argument';
    test.shouldThrowErrorSync( () => _.set.lengthOf( new Set( [ 1, 3 ] ), [] ) );
    test.shouldThrowErrorSync( () => _.set.lengthOf( new Set( [ 1, 3 ] ), 2 ) );
    test.shouldThrowErrorSync( () => _.set.lengthOf( new Set( [ 1, 3 ] ), 'str' ) );

    test.case = 'wrong src';
    test.shouldThrowErrorSync( () => _.set.lengthOf( 'wrong' ) );
    test.shouldThrowErrorSync( () => _.set.lengthOf( 2 ) );
    test.shouldThrowErrorSync( () => _.set.lengthOf( [] ) );
    test.shouldThrowErrorSync( () => _.set.lengthOf( new Set( {} ) ) );
  }

  // --
  // declaration
  // --

  const Proto =
  {
    name : 'Tools.Set.l0.l3',
    silencing : 1,

    tests :
    {
      aptLeft,
      aptRight,

      lengthOf,
    },
  };

  //

  const Self = wTestSuite( Proto );
  if( typeof module !== 'undefined' && !module.parent ) wTester.test( Self.name );
} )();
