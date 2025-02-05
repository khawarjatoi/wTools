( function _l1_Str_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.str = _.str || Object.create( null );
_.str.lines = _.str.lines || Object.create( null );

// --
// str
// --

/**
 * Function strIs checks incoming param whether it is string.
 * Returns "true" if incoming param is string. Othervise "false" returned
 *
 * @example
 * _.strIsIs( 'song' );
 * // returns true
 *
 * @example
 * _.strIs( 5 );
 * // returns false
 *
 * @param {*} src.
 * @return {Boolean}.
 * @function strIs.
 * @namespace Tools
 */

function is( src )
{
  let result = Object.prototype.toString.call( src ) === '[object String]';
  return result;
}

//

function like( src )
{
  if( _.str.is( src ) )
  return true;
  if( _.regexp.is( src ) )
  return true;
  return false;
}

//

function strsAreAll( src )
{
  _.assert( arguments.length === 1 );

  if( _.argumentsArray.like( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.strIs( src[ s ] ) )
    return false;
    return true;
  }

  return _.strIs( src );
}

//

// function regexpLike( src )
// {
//   if( _.strIs( src ) )
//   return true;
//   if( _.regexpIs( src ) )
//   return true;
//   return false
// }
//
// //
//
// function strsLikeAll( src )
// {
//   _.assert( arguments.length === 1 );
//
//   if( _.argumentsArray.like( src ) )
//   {
//     for( let s = 0 ; s < src.length ; s++ )
//     if( !_.regexpLike( src[ s ] ) )
//     return false;
//     return true;
//   }
//
//   return regexpLike( src );
// }

//

function strDefined( src )
{
  if( !src )
  return false;
  let result = Object.prototype.toString.call( src ) === '[object String]';
  return result;
}

//

function strsDefined( src )
{
  if( _.argumentsArray.like( src ) )
  {
    for( let s = 0 ; s < src.length ; s++ )
    if( !_.strDefined( src[ s ] ) )
    return false;
    return true;
  }
  return false;
}

//

function strHas( src, ins )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src ), () => `Expects string, got ${_.entity.strType( src )}` );
  _.assert( _.regexpLike( ins ), () => `Expects string-like, got ${_.entity.strType( ins )}` );

  if( _.strIs( ins ) )
  return src.indexOf( ins ) !== -1;
  else
  return ins.test( src );

}

// --
// converter
// --

/**
 * Returns source string( src ) with limited number( limit ) of characters.
 * For example: src : 'string', limit : 4, result -> 'stng'.
 * Function can be called in two ways:
 * - First to pass only source string and limit;
 * - Second to pass all options map. Example: ({ src : 'string', limit : 5, delimeter : '.' }).
 *
 * @param {string|object} o - String to parse or object with options.
 * @param {string} [ o.src=null ] - Source string.
 * @param {number} [ o.limit=40 ] - Limit of characters in output.
 * @param {string} [ o.delimeter=null ] - The middle part to fill the reduced characters, if boolLikeTrue - the default ( '...' ) is used.
 * @param {function} [ o.onLength=null ] - callback function that calculates a length based on .
 * @returns {string} Returns simplified source string.
 *
 * @example
 * _.strShort_( 'string', 4 );
 * // returns o, o.result = 'stng'
 *
 * @example
 * _.strShort_( 'a\nb', 3 );
 * // returns o, o.result = 'a\nb'
 *
 * @example
 * _.strShort_( 'string', 0 );
 * // returns o, o.result = ''
 *
 * @example
 * _.strShort_({ src : 'string', limit : 4 });
 * // returns o, o.result = 'stng'
 *
 * @example
 *  _.strShort_({ src : 'string', limit : 3, cutting : 'right' });
 * // returns o, o.result = 'str'
 *
 * @example
 * _.strShort_({ src : 'st\nri\nng', limit : 1, heightLimit : 2, cutting : 'left', heightCutting : 'right' });
 * // returns o, o.result = 't\ni'
 *
 * @method strShort_
 * @throws { Exception } If no argument provided.
 * @throws { Exception } If( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } If( o ) is extended with unknown property.
 * @throws { Exception } If( o.src ) is not a String.
 * @throws { Exception } If( o.limit ) is not a Number.
 * @throws { Exception } If( o.delimeter ) is not a String or null or boolLikeTrue.
 *
 * @namespace Tools
 *
 */

function strShort_( o )  /* version with binary search cutting */
{

  if( arguments.length === 2 )
  o = { src : arguments[ 0 ], widthLimit : arguments[ 1 ] };
  else if( arguments.length === 1 )
  if( _.strIs( o ) )
  o = { src : arguments[ 0 ] };

  _.routine.options( strShort_, o );

  _.assert( _.strIs( o.src ) );
  _.assert( _.number.is( o.widthLimit ) );
  _.assert( o.widthLimit >= 0, 'Option::o.widthLimit must be greater or equal to zero' );
  _.assert
  (
    _.number.is( o.heightLimit ) && o.heightLimit >= 0,
    'If provided option::o.heightLimit must be greater or equal to zero'
  );
  _.assert( o.delimeter === null || _.strIs( o.delimeter ) || _.bool.likeTrue( o.delimeter ));
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( !o.delimeter )
  o.delimeter = '';
  if( !o.heightDelimeter )
  o.heightDelimeter = '';
  if( o.widthLimit === 0 )
  o.widthLimit = Infinity;
  if( o.heightLimit === 0 )
  o.heightLimit = Infinity;

  if( _.bool.likeTrue( o.delimeter ) )
  o.delimeter = '...';

  if( !o.onLength )
  o.onLength = ( src ) => src.length;

  let src = o.src;

  let isOneLine = o.src.indexOf( '\n' ) === -1;

  if( isOneLine && o.onLength( o.src ) < o.widthLimit )
  {
    o.changed = false;
    o.result = o.src;

    return o;
  }

  let options = Object.create( null ); /* width cutting options */
  options.limit = o.widthLimit;
  options.delimeter = o.delimeter;
  options.onLength = o.onLength;
  options.cutting = o.cutting;

  if( isOneLine )
  {
    options.src = src;
    _.strShortWidth( options );

    o.result = options.result;
    o.changed = options.changed;

    return o;
  }
  else
  {
    let splitted = o.src.split( '\n' );

    let options2 = Object.create( null );  /* height cutting */
    options2.src = splitted;
    options2.limit = o.heightLimit;
    options2.delimeter = o.heightDelimeter;
    options2.cutting = o.heightCutting;
    _._strShortHeight( options2 );

    options.src = options2.result;

    _._strShortWidth( options );

    let result = options.result.join( '\n' );

    if( result === o.src )
    o.changed = false;
    else if( result !== o.src )
    o.changed = true;

    o.result = result;

    return o;
  }
}

strShort_.defaults =
{
  src : null,
  widthLimit : 40,
  heightLimit : 0,
  delimeter : null, /* xxx qqq : rename to 'widthDelimeter' */
  heightDelimeter : null,
  onLength : null,
  cutting : 'center', /* xxx qqq : rename to 'widthCutting' */
  heightCutting : 'center',
}

//

function strShortWidth( o )
{

  if( arguments.length === 2 )
  o = { src : arguments[ 0 ], limit : arguments[ 1 ] };
  else if( arguments.length === 1 )
  if( _.strIs( o ) )
  o = { src : arguments[ 0 ] };

  _.routine.options( strShortWidth, o );

  _.assert( _.strIs( o.src ) );
  _.assert( _.number.is( o.limit ) );
  _.assert( o.limit >= 0, 'Option::o.limit must be greater or equal to zero' );
  _.assert( o.delimeter === null || _.strIs( o.delimeter ) || _.bool.likeTrue( o.delimeter ));
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let originalSrc = o.src;

  if( !o.delimeter )
  o.delimeter = '';
  if( o.limit === 0 )
  o.limit = Infinity;

  if( _.bool.likeTrue( o.delimeter ) )
  o.delimeter = '...';

  if( !o.onLength )
  o.onLength = ( src ) => src.length;

  let splitted = o.src.split( '\n' );

  o.src = splitted;
  _._strShortWidth( o );

  o.src = originalSrc;
  o.result = o.result.join( '\n' );

  return o;
}

strShortWidth.defaults =
{
  src : null,
  limit : 40,
  onLength : null,
  cutting : 'center',
  delimeter : null
}

//

function _strShortWidth( o )
{
  /*
    input : array of lines
    output : array of lines ( each cutted down to o.limit )
  */
  _.assert( _.arrayIs( o.src ) );
  _.routine.options( _strShortWidth, o );

  let begin = '';
  let end = '';
  let fixLength = o.onLength( o.delimeter );

  o.changed = false;

  let result = o.src.map( ( el ) =>
  {
    let delimeter = o.delimeter;
    fixLength = o.onLength( o.delimeter );

    if( fixLength === o.limit )
    {
      o.changed = true;
      return o.delimeter;
    }
    else if( o.onLength( el ) + fixLength <= o.limit ) /* nothing to cut */
    {
      return el;
    }
    else
    {
      if( o.onLength( delimeter ) > o.limit )
      {
        el = delimeter;
        delimeter = '';
        fixLength = 0;
      }

      o.changed = true;

      if( o.cutting === 'left' )
      {
        return delimeter + cutLeft( el );
      }
      else if( o.cutting === 'right' )
      {
        return cutRight( el ) + delimeter;
      }
      else
      {
        let [ begin, end ] = cutMiddle( el );
        return begin + delimeter + end;
      }
    }
  });

  o.result = result;

  return o;

  /* - */

  function cutLeft( src )
  {
    let startIndex = 0;
    let endIndex = src.length - 1;
    let endLength = o.onLength( src );
    let middleIndex = src.length - o.limit - 1; /* optimize default option::onLength */

    while( endLength + fixLength > o.limit ) /* binary */
    {
      [ begin, end ] = splitInTwo( src, middleIndex + 1 );
      endLength = o.onLength( end );

      startIndex = middleIndex; /* all needed elements are in end */
      middleIndex = Math.floor( ( startIndex + endIndex ) / 2 );
    }

    while( o.onLength( end ) + fixLength <= o.limit ) /* add elements till o.limit is satisfied */
    {
      /*
        add elements and parts of element that might have been sliced,
        example : onLength considers as 1 element substring of the same characters
                  'aabbccdd' with o.limit = 2 might return 'cdd', but need 'ccdd'
      */
      end = begin[ begin.length - 1 ] + end;
      begin = begin.slice( 0, -1 );
    }

    return end.slice( 1 );
  }

  //

  function cutRight( src )
  {
    let startIndex = 0;
    let endIndex = src.length - 1;
    let beginLength = o.onLength( src );
    let middleIndex = o.limit; /* optimize default option::onLength */

    while( beginLength + fixLength > o.limit ) /* binary */
    {
      [ begin, end ] = splitInTwo( src, middleIndex );
      beginLength = o.onLength( begin );

      endIndex = middleIndex; /* all needed elements are in begin */
      middleIndex = Math.floor( ( startIndex + endIndex ) / 2 );
    }

    while( o.onLength( begin ) + fixLength <= o.limit ) /* add elements till o.limit is satisfied */
    {
      /*
        add elements and parts of element that might have been sliced,
        example : onLength considers as 1 element substring of the same characters
                  'aabbccdd' with o.limit = 2 might return 'aab', but need 'aabb'
      */
      begin += end[ 0 ];
      end = end.slice( 1 );
    }

    return begin.slice( 0, -1 );
  }

  //

  function cutMiddle( src )
  {
    let originalStr = src;
    let chunkSize, middleIndexLeft, middleIndexRight;

    if( o.limit % 2 === 0 ) /* optimize default option::onLength */
    {
      middleIndexLeft = ( o.limit / 2 ) - 1;
      middleIndexRight = ( -o.limit / 2 ) + src.length;
    }
    else
    {
      middleIndexLeft = Math.floor( ( o.limit / 2 ) );
      middleIndexRight = Math.ceil( ( -o.limit / 2 ) ) + src.length;
    }

    while( o.onLength( src ) + fixLength > o.limit ) /* binary */
    {
      if( src.length <= 5 ) /* src.length = 4 || 3 || 2, base case */
      {
        let index = Math.floor( src.length / 2 );
        begin = src.slice( 0, index );
        end = src.slice( index+1 );
      }
      else /* begin : first 1/3, end : last 1/3 */
      {
        begin = src.slice( 0, middleIndexLeft + 1 );
        end = src.slice( middleIndexRight );
      }

      /* delete middle, might delete part of the element, check later when desired length is obtained */
      src = begin + end;

      chunkSize = Math.floor( src.length / 3 ); /* split str into 3 'equal' parts, middle is to be removed */
      middleIndexLeft = chunkSize;
      middleIndexRight = chunkSize * 2;
    }

    while( o.onLength( begin + end ) + fixLength < o.limit ) /* overcut */
    {
      if( o.onLength( begin ) > o.onLength( end ) ) /* shrink middle from the right */
      {
        end = originalStr.slice( -end.length - 1 );
      }
      else                                          /* shrink middle from the left */
      {
        begin = originalStr.slice( 0, begin.length + 1 );
      }
    }

    /*
      add parts of elements that might have been sliced,
      example : onLength considers as 1 element substring of the same characters
                'aabbccdd' with o.limit = 2 might return 'ad', but need 'aadd'
    */

    let beginInitial = o.onLength( begin );
    let endInitial = o.onLength( end );

    while( o.onLength( begin ) === beginInitial ) /* try to increase begin */
    {
      begin = originalStr.slice( 0, begin.length + 1 );;
    }

    while( o.onLength( end ) === endInitial ) /* try to increase end */
    {
      end = originalStr.slice( -end.length - 1 );
    }

    return [ begin.slice( 0, -1 ), end.slice( 1 ) ];
  }

  //

  function splitInTwo( src, middle )
  {
    let begin = src.slice( 0, middle );
    let end = src.slice( middle );
    return [ begin, end ];
  }

}

_strShortWidth.defaults =
{
  src : null,
  limit : 40,
  delimeter : null,
  onLength : null,
  cutting : 'center',
}

//

function strShortHeight( o )
{

  if( arguments.length === 2 )
  o = { src : arguments[ 0 ], limit : arguments[ 1 ] };
  else if( arguments.length === 1 )
  if( _.strIs( o ) )
  o = { src : arguments[ 0 ] };

  _.routine.options( strShortHeight, o );

  _.assert( _.strIs( o.src ) );
  _.assert
  (
    ( _.number.is( o.limit ) && o.limit >= 0 ),
    'option::o.limit must be greater or equal to zero'
  );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let originalSrc = o.src;
  let splitted = o.src.split( '\n' );

  if( !o.delimeter )
  o.delimeter = '';

  o.src = splitted;

  _._strShortHeight( o );
  o.src = originalSrc;
  o.result = o.result.join( '\n' );

  return o;

}

strShortHeight.defaults =
{
  src : null,
  limit : null,
  cutting : 'center',
  delimeter : null,
}

//

function _strShortHeight( o )  /* version with binary search cutting */
{
  /*
    input : array of lines
    output : array of lines ( cutted down to o.limit )
  */

  _.assert( _.arrayIs( o.src ) );
  _.routine.options( strShortHeight, o );

  o.changed = false;

  let delimeterLength = o.delimeter === '' ? 0 : 1;

  if( delimeterLength === o.limit )
  {
    o.changed = true;
    o.result = [ o.delimeter ];

    return o;
  }

  let result = cut( o.src.slice() );
  o.result = result;

  return o;

  /* - */

  function cut( src )
  {
    if( src.length + delimeterLength > o.limit )
    {
      o.changed = true;

      if( o.cutting === 'left' )
      {
        src = src.slice( - ( o.limit - delimeterLength ) );

        if( o.delimeter !== '' )
        src.unshift( o.delimeter );
      }
      else if( o.cutting === 'right' )
      {
        src = src.slice( 0, o.limit - delimeterLength );

        if( o.delimeter !== '' )
        src.push( o.delimeter );
      }
      else
      {
        let [ left, right ] = handleHeightCuttingCenter( src );
        let result = [];

        result.push( ... left );

        if( o.delimeter !== '' )
        result.push( o.delimeter );

        if( right !== undefined ) /* no right when o.limit = 2 and there is a delimeter */
        result.push( ... right );

        src = result;

      }
    }

    return src;
  }

  //

  function handleHeightCuttingCenter( src )
  {
    let indexLeft, indexRight;

    let limit = o.limit - delimeterLength;

    if( limit === 1 )
    {
      return [ src.slice( 0, 1 ) ];
    }
    else if( limit % 2 === 0 )
    {
      indexLeft = limit / 2;
      indexRight = -indexLeft;
    }
    else
    {
      indexLeft = Math.floor( ( limit / 2 ) ) + 1;
      indexRight = -indexLeft + 1;
    }

    let splittedLeft = src.slice( 0, indexLeft );
    let splittedRight = src.slice( indexRight );

    return [ splittedLeft, splittedRight ];
  }

}

_strShortHeight.defaults =
{
  src : null,
  limit : null,
  cutting : 'center',
  prefix : null,
  postfix : null,
  infix : null,
}

//

/**
 * The routine strConcat() provides the concatenation of array of elements ( or single element )
 * into a String. Returned string can be formatted by using options in options map {-o-}.
 *
 * @example
 * _.strConcat( 'str' );
 * // returns : 'str'
 *
 * @example
 * _.strConcat( 11 );
 * // returns : '11'
 *
 * @example
 * _.strConcat([ 1, 2, 'str', [ 3, 4 ] ]);
 * // returns : '1 2 str 3,4 '
 *
 * @example
 * let options =
 * {
 *   linePrefix : '** ',
 *   linePostfix : ' **'
 * };
 * _.strConcat( [ 1, 2, 'str', [ 3, 4 ] ], options );
 * // returns : '** 1 2 str 3,4 **'
 *
 * @example
 * let options =
 * {
 *   linePrefix : '** ',
 *   linePostfix : ' **'
 * };
 * _.strConcat( [ 'a\n', 'b\n', 'c' ], options );
 * // returns :
 * // `** a **
 * // ** b **
 * // ** c **
 *
 * @example
 * let onToStr = ( src ) => String( src ) + '*';
 * let options = { onToStr };
 * _.strConcat( [ 'a', 'b', 'c' ], options );
 * // returns : 'a* b* c*'
 *
 * @example
 * let onPairWithDelimeter = ( src1, src2 ) => src1 + ' ..' + src2;
 * let options = { onPairWithDelimeter };
 * _.strConcat( [ 'a\n', 'b\n', 'c' ], options );
 * // returns :
 * // `a ..
 * // b ..
 * // c`
 *
 * @param { ArrayLike|* } srcs - ArrayLike container with elements or single element to make string.
 * If {-srcs-} is not ArrayLike, routine converts to string provided instance.
 * @param { Map } o - Options map.
 * @param { String } o.lineDelimter - The line delimeter. Default value is new line symbol '\n'.
 * If an element of array has not delimeter at the end or next element has not delimeter at the begin,
 * then routine inserts one space between this elements.
 * @param { String } o.linePrefix - The prefix, which is added to each line. Default value is empty string.
 * @param { String } o.linePostfix - The postfix, which is added to each line. Default value is empty string.
 * @param { Map } o.optionsForToStr - The options for routine _.entity.exportString that uses as default callback {-o.onToStr-}. Default value is null.
 * @param { Function } o.onToStr - The callback, which uses for conversion of each element of {-srcs-}. Accepts element {-src-} and options map {-o-}.
 * @param { Function } o.onPairWithDelimeter - The callback, which uses for concatenation of two strings.
 * The callback calls if first string {-src1-} end with line delimeter {-o.lineDelimter-} or second string {-src2-}
 * begins with line delimeter. Additionally accepts options map {-o-}.
 * @returns { String } - Returns concatenated string.
 * @function strConcat
 * @throws { Error } If arguments.length is less then one or greater than two.
 * @throws { Error } If options map {-o-} has unknown property.
 * @throws { Error } If property {-o.optionsForToStr-} is not a Aux.
 * @throws { Error } If routine strConcat does not belong module Tools.
 * @namespace Tools
 */

function strConcat( srcs, o )
{

  o = _.routine.options( strConcat, o || Object.create( null ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( this.strConcat === strConcat );

  if( o.onToStr === null )
  o.onToStr = onToStr;

  let defaultOptionsForToStr =
  {
    stringWrapper : '',
  };

  o.optionsForToStr = _.props.supplement( o.optionsForToStr, defaultOptionsForToStr );
  o.optionsForToStr.format = o.optionsForToStr.format || 'string.diagnostic';

  if( _.routine.is( srcs ) )
  srcs = srcs();

  if( !_.argumentsArray.like( srcs ) )
  srcs = [ srcs ];

  let result = '';
  if( !srcs.length )
  return result;

  let concatenatePairWithLineDelimeter = o.onPairWithDelimeter ? o.onPairWithDelimeter : concatenateSimple;

  /* */

  let a = 0;

  while( !result && a < srcs.length )
  {
    result = o.onToStr( srcs[ a ], o );
    ++a;
  }

  for( ; a < srcs.length ; a++ )
  {
    let src = srcs[ a ];
    src = o.onToStr( src, o );

    result = result.replace( /[^\S\n]\s*$/, '' );

    if( _.strEnds( result, o.lineDelimter ) || _.strBegins( src, o.lineDelimter ) )
    result = concatenatePairWithLineDelimeter( result, src, o );
    else
    result = `${result} ${src.replace( /^\s+/, '' )}`;
  }

  /* */

  if( o.linePrefix || o.linePostfix )
  {
    result = result.split( o.lineDelimter );
    result = o.linePrefix + result.join( o.linePostfix + o.lineDelimter + o.linePrefix ) + o.linePostfix;
  }

  /* */

  return result;

  /* */

  function onToStr( src, op )
  {
    return _.entity.exportString( src, op.optionsForToStr );
  }

  /* */

  function concatenateSimple( src1, src2 )
  {
    return src1 + src2;
  }
}

strConcat.defaults =
{
  linePrefix : '',
  linePostfix : '',
  lineDelimter : '\n',
  optionsForToStr : null,
  onToStr : null,
  onPairWithDelimeter : null,
}

//

function _strBeginOf( src, begin )
{

  // _.assert( _.strIs( src ), 'Expects string' );
  // _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.strIs( begin ) )
  {
    if( src.lastIndexOf( begin, 0 ) === 0 )
    return begin;
  }
  else if( _.regexpIs( begin ) )
  {
    let matched = begin.exec( src );
    if( matched && matched.index === 0 )
    return matched[ 0 ];
  }
  else _.assert( 0, 'Expects string-like ( string or regexp )' );

  return undefined;
}

//

function _strEndOf( src, end )
{

  // _.assert( _.strIs( src ), 'Expects string' );
  // _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( _.strIs( end ) )
  {
    if( src.indexOf( end, src.length - end.length ) !== -1 )
    return end;
  }
  else if( _.regexpIs( end ) )
  {
    // let matched = end.exec( src );
    let newEnd = RegExp( end.toString().slice(1, -1) + '$' );
    let matched = newEnd.exec( src );

    //if( matched && matched.index === 0 )
    if( matched && matched.index + matched[ 0 ].length === src.length )
    return matched[ 0 ];
  }
  else _.assert( 0, 'Expects string-like ( string or regexp )' );

  return undefined;
}

//

/**
 * Compares two strings.
 *
 * @param { String } src - Source string.
 * @param { String } begin - String to find at begin of source.
 *
 * @example
 * let scr = _.strBegins( "abc", "a" );
 * // returns true
 *
 * @example
 * let scr = _.strBegins( "abc", "b" );
 * // returns false
 *
 * @returns { Boolean } Returns true if param( begin ) is match with first chars of param( src ), otherwise returns false.
 * @function strBegins
 * @throws { Exception } If one of arguments is not a String.
 * @throws { Exception } If( arguments.length ) is not equal 2.
 * @namespace Tools
 */

function strBegins( src, begin )
{

  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ), 'Expects string/regexp or array of strings/regexps {-begin-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !_.longIs( begin ) )
  {
    let result = _._strBeginOf( src, begin );
    return !( result === undefined );
    // return result === undefined ? false : true;
  }

  for( let b = 0, blen = begin.length ; b < blen; b++ )
  {
    let result = _._strBeginOf( src, begin[ b ] );
    if( result !== undefined )
    return true;
  }

  return false;
}

//

/**
 * Compares two strings.
 *
 * @param { String } src - Source string.
 * @param { String } end - String to find at end of source.
 *
 * @example
 * let scr = _.strEnds( "abc", "c" );
 * // returns true
 *
 * @example
 * let scr = _.strEnds( "abc", "b" );
 * // returns false
 *
 * @return { Boolean } Returns true if param( end ) is match with last chars of param( src ), otherwise returns false.
 * @function strEnds
 * @throws { Exception } If one of arguments is not a String.
 * @throws { Exception } If( arguments.length ) is not equal 2.
 * @namespace Tools
 */

function strEnds( src, end )
{

  _.assert( _.strIs( src ), () => `Expects argument::src of type::string, but got ${_.entity.strType( src )}` );
  _.assert( _.strIs( end ) || _.regexpIs( end ) || _.longIs( end ), 'Expects string/regexp or array of strings/regexps {-end-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !_.longIs( end ) )
  {
    let result = _._strEndOf( src, end );
    return !( result === undefined );
  }

  for( let b = 0, blen = end.length ; b < blen; b++ )
  {
    let result = _._strEndOf( src, end[ b ] );
    if( result !== undefined )
    return true;
  }

  return false;
}

//

/**
 * Finds occurrence of( end ) at the end of source( src ) and removes it if exists.
 * Returns begin part of a source string if occurrence was finded or empty string if arguments are equal, otherwise returns undefined.
 *
 * @param { String } src - The source string.
 * @param { String } end - String to find.
 *
 * @example
 * _.strBeginOf( 'abc', 'c' );
 * // returns 'ab'
 *
 * @example
 * _.strBeginOf( 'abc', 'x' );
 * // returns undefined
 *
 * @returns { String } Returns part of source string without tail( end ) or undefined.
 * @throws { Exception } If all arguments are not strings;
 * @throws { Exception } If ( argumets.length ) is not equal 2.
 * @function strBeginOf
 * @namespace Tools
 */

function strBeginOf( src, begin )
{

  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ), 'Expects string/regexp or array of strings/regexps {-begin-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !_.longIs( begin ) )
  {
    let result = _._strBeginOf( src, begin );
    return result;
  }

  for( let b = 0, blen = begin.length ; b < blen ; b++ )
  {
    let result = _._strBeginOf( src, begin[ b ] );
    if( result !== undefined )
    return result;
  }

  return undefined;
}

//

/**
 * Finds occurrence of( begin ) at the begining of source( src ) and removes it if exists.
 * Returns end part of a source string if occurrence was finded or empty string if arguments are equal, otherwise returns undefined.
 * otherwise returns undefined.
 *
 * @param { String } src - The source string.
 * @param { String } begin - String to find.
 *
 * @example
 * _.strEndOf( 'abc', 'a' );
 * // returns 'bc'
 *
 * @example
 * _.strEndOf( 'abc', 'c' );
 * // returns undefined
 *
 * @returns { String } Returns part of source string without head( begin ) or undefined.
 * @throws { Exception } If all arguments are not strings;
 * @throws { Exception } If ( argumets.length ) is not equal 2.
 * @function strEndOf
 * @namespace Tools
 */

function strEndOf( src, end )
{

  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.strIs( end ) || _.regexpIs( end ) || _.longIs( end ), 'Expects string/regexp or array of strings/regexps {-end-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( !_.longIs( end ) )
  {
    let result = _._strEndOf( src, end );
    return result;
  }

  for( let b = 0, blen = end.length ; b < blen; b++ )
  {
    let result = _._strEndOf( src, end[ b ] );
    if( result !== undefined )
    return result;
  }

  return undefined;
}

//

/**
 * Finds substring prefix ( begin ) occurrence from the very begining of source ( src ) and removes it.
 * Returns original string if source( src ) does not have occurrence of ( prefix ).
 *
 * @param { String } src - Source string to parse.
 * @param { String } prefix - String that is to be dropped.
 * @returns { String } Returns string with result of prefix removement.
 *
 * @example
 * _.strRemoveBegin( 'example', 'exa' );
 * // returns mple
 *
 * @example
 * _.strRemoveBegin( 'example', 'abc' );
 * // returns example
 *
 * @function strRemoveBegin
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( prefix ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
 * @namespace Tools
 *
 */

function strRemoveBegin( src, begin )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.strIs( begin ) || _.regexpIs( begin ), 'Expects string/regexp {-begin-}' );

  let result = src;
  let beginOf = _._strBeginOf( result, begin );
  if( beginOf !== undefined )
  result = result.substr( beginOf.length, result.length );
  return result;
}

//

/**
 * Removes occurrence of postfix ( end ) from the very end of string( src ).
 * Returns original string if no occurrence finded.
 * @param { String } src - Source string to parse.
 * @param { String } postfix - String that is to be dropped.
 * @returns { String } Returns string with result of postfix removement.
 *
 * @example
 * _.strRemoveEnd( 'example', 'le' );
 * // returns examp
 *
 * @example
 * _.strRemoveEnd( 'example', 'abc' );
 * // returns example
 *
 * @function strRemoveEnd
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( postfix ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
 * @namespace Tools
 *
 */

function strRemoveEnd( src, end )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( src ), 'Expects string {-src-}' );
  _.assert( _.strIs( end ) || _.regexpIs( end ), 'Expects string/regexp {-end-}' );

  let result = src;
  let endOf = _._strEndOf( result, end );
  if( endOf !== undefined )
  result = result.substr( 0, result.length - endOf.length );

  return result;
}

//

/**
 * Finds substring or regexp ( insStr ) first occurrence from the source string ( srcStr ) and removes it.
 * Returns original string if source( src ) does not have occurrence of ( insStr ).
 *
 * @param { String } srcStr - Source string to parse.
 * @param { String } insStr - String/RegExp that is to be dropped.
 * @returns { String } Returns string with result of substring removement.
 *
 * @example
 * _.strRemove( 'source string', 's' );
 * // returns ource tring
 *
 * @example
 * _.strRemove( 'example', 's' );
 * // returns example
 *
 * @function strRemove
 * @throws { Exception } Throws a exception if( srcStr ) is not a String.
 * @throws { Exception } Throws a exception if( insStr ) is not a String or a RegExp.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
 * @namespace Tools
 *
 */

function strRemove( srcStr, insStr )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( srcStr ), 'Expects string {-src-}' );
  _.assert( _.strIs( insStr ) || _.regexpIs( insStr ), 'Expects string/regexp {-begin-}' );

  let result = srcStr;

  result = result.replace( insStr, '' );

  return result;
}

// --
// lines
// --

function split( src )
{
  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 );
  if( _.arrayIs( src ) )
  return src;
  return src.split( '\n' );
}

//

function join( src )
{
  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 );
  let result = src;
  if( _.arrayIs( src ) )
  result = src.join( '\n' );
  return result;
}

//

/**
 * Remove espace characters and white spaces at the begin or at the end of each line.
 * Input arguments can be strings or arrays of strings. If input is a string, it splits it in lines and
 * removes the white/escape characters from the beggining and the end of each line. If input is an array,
 * it treats it as a single string split into lines, where each entry corresponds to a line. Therefore,
 * it removes the white/escape characters only from the beggining and the end of the strings in the array.
 *
 * @param { String/Array } [ src ] - Source string or array of strings.
 * @returns { String/Array } Returns string/array with empty lines and spaces removed.
 *
 * @example input string
 * _.str.lines.strip( '  Hello \r\n\t World \n\n ' );
 * // returns 'Hello\nWorld'
 *
 * @example input array
 * _.str.lines.strip( [ '  Hello \r\n\t world \n\n ', '\n! \n' ] );
 * // returns  [ 'Hello \r\n\t world', '!' ]
 *
 * @example input strings
 * _.str.lines.strip( '  Hello \r\n\t', ' World \n\n  ! \n\n', '\n\n' );
 * // returns [ 'Hello', 'World\n!', '' ]
 *
 * @example input arrays
 * _.str.lines.strip( [ '  Hello \r\n\t world \n\n ', '\n! \n' ], [ '\n\nHow\n\nAre  ', '  \r\nyou ? \n'], [ '\t\r\n  ' ] );
 * // returns [ [ 'Hello \r\n\t world', '!' ], [ 'How\n\nAre', 'you ?' ], [] ]
 *
 * @method strip
 * @throws { Exception } Throw an exception if( src ) is not a String or Array.
 * @namespace Tools/str/lines/strip
 */

/* qqq : measure time and optimize. ask */
function strip( src )
{

  if( arguments.length > 1 )
  {
    let result = _.unroll.make( null );
    for( let a = 0 ; a < arguments.length ; a++ )
    result[ a ] = _.str.lines.strip( arguments[ a ] );
    return result;
  }

  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  _.assert( arguments.length === 1 );

  let lines = _.strLinesSplit( src );
  lines = lines.map( ( line ) => line.trim() ).filter( ( line ) => line );

  if( _.strIs( src ) )
  lines = _.str.lines.join( lines );
  return lines;
}

//

function atLeft( src, index, nlTokens )
{
  let result;

  _.assert( _.number.is( index ) );

  if( index < 0 )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ 0, -1 ];
    return result;
  }

  let o2 = Object.create( null );
  o2.src = src;
  o2.nlTokens = nlTokens;
  o2.onEach = onEach;
  o2.interval = [ index, index ];
  o2.withLine = false;
  this.eachLeft( o2 );

  if( !result )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ src.length, src.length-1 ];
  }

  delete result.nlTokens;
  delete result.onEach;
  delete result.interval;
  delete result.withLine;

  return result;

  function onEach( it )
  {
    result = it;
    result.line = src.slice( it.charInterval[ 0 ], it.charInterval[ 1 ]-it.nl.length+1 );
  }

}

//

function atRight( src, index, nlTokens )
{
  let result;

  _.assert( _.number.is( index ) );

  if( index < 0 )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ src.length, src.length-1 ];
    return result;
  }

  let o2 = Object.create( null );
  o2.src = src;
  o2.nlTokens = nlTokens;
  o2.onEach = onEach;
  o2.interval = [ index, index ];
  o2.withLine = false;

  this.eachRight( o2 );

  if( !result )
  {
    result = Object.create( null );
    result.src = src;
    result.lineIndex = index;
    result.charInterval = [ 0, -1 ];
  }

  delete result.nlTokens;
  delete result.onEach;
  delete result.interval;
  delete result.withLine;

  return result;

  function onEach( it )
  {
    result = it;
    result.line = src.slice( it.charInterval[ 0 ], it.charInterval[ 1 ]-it.nl.length+1 );
  }

}

//

function _eachLeft( o )
{

  if( o.nlTokens === undefined )
  o.nlTokens = [ '\r\n', '\n\r', '\n' ];
  else if( !_.str.is( o.nlTokens ) )
  o.nlTokens = [ ... o.nlTokens ];

  const lastIndex = o.interval ? o.interval[ 1 ] : Infinity;
  const src = o.src;
  let foundTokenIndex;
  let foundOffset;
  let handleEach;

  o.charInterval = [ -1, -1 ];
  o.lineIndex = -1;

  if( o.interval && o.interval[ 1 ] < 0 )
  {
    o.charInterval[ 0 ] = 0;
    return o;
  }

  o.nl = '';

  if( o.interval )
  {
    if( o.withLine )
    handleEach = handleWithIntervalWithLine;
    else
    handleEach = handleWithIntervalWithoutLine;
  }
  else
  {
    if( o.withLine )
    handleEach = handleWithoutIntervalWithLine;
    else
    handleEach = handleWithoutIntervalWithoutLine;
  }

  if( _.str.is( o.nlTokens ) )
  single();
  else
  multiple();

  if( !o.interval || o.lineIndex < o.interval[ 1 ] )
  {
    o.lineIndex += 1;
    o.charInterval[ 0 ] = src.length;
    _.assert( o.charInterval[ 1 ] === src.length - 1 );
    if( o.withLine )
    o.line = '';
  }

  return o;

  /* */

  function single()
  {

    o.nl = o.nlTokens;
    while( o.lineIndex !== lastIndex )
    {
      o.charInterval[ 0 ] = Math.max( o.charInterval[ 0 ], o.charInterval[ 1 ] ) + 1;
      o.charInterval[ 1 ] = src.indexOf( o.nlTokens, o.charInterval[ 0 ] );
      o.lineIndex += 1;

      if( o.charInterval[ 1 ] === -1 )
      {
        o.charInterval[ 1 ] = src.length - 1;
        o.nl = '';
        handleEach();
        break;
      }
      else
      {
        o.charInterval[ 1 ] += o.nl.length - 1;
        handleEach();
      }

    }

  }

  /* */

  function multiple()
  {

    foundTokenIndex = -1;
    foundOffset = src.length;

    let first = indexInit();

    if( first.length === 1 )
    {
      o.nlTokens = o.nlTokens[ foundTokenIndex ];
      return single();
    }

    if( first.length === 0 )
    {

      o.lineIndex = 0;
      o.charInterval[ 0 ] = 0;
      o.charInterval[ 1 ] = src.length-1;
      handleEach();

      return;
    }

    while( o.lineIndex !== lastIndex )
    {
      o.charInterval[ 0 ] = Math.max( o.charInterval[ 0 ], o.charInterval[ 1 ] ) + 1;
      o.charInterval[ 1 ] = indexOf( first );
      o.lineIndex += 1;

      if( o.charInterval[ 1 ] === o.src.length )
      {
        o.charInterval[ 1 ] = src.length - 1;
        o.nl = '';
        handleEach();
        break;
      }
      else
      {
        o.nl = o.nlTokens[ foundTokenIndex ];
        o.charInterval[ 1 ] += o.nl.length - 1;
        handleEach();
      }

    }

  }

  /* */

  function indexInit()
  {
    let first = [];
    for( let i = o.nlTokens.length - 1 ; i >= 0 ; i-- )
    {
      let offset = src.indexOf( o.nlTokens[ i ] );
      if( offset !== -1 )
      {
        first.unshift( offset );
        if( foundOffset >= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
      else
      {
        o.nlTokens.splice( i, 1 );
        foundTokenIndex -= 1;
      }
    }
    return first;
  }

  /* */

  function indexOf( first )
  {
    if( first[ foundTokenIndex ] >= o.charInterval[ 0 ] )
    return first[ foundTokenIndex ];
    foundOffset = src.length;
    for( let i = first.length - 1; i >= 0 ; i-- )
    {
      let offset = first[ i ];
      if( offset < o.charInterval[ 0 ] )
      {
        offset = src.indexOf( o.nlTokens[ i ], first[ i ]+1 );
        if( offset === -1 )
        {
          tokenDelete( first, i );
          if( first.length === 0 )
          return src.length;
        }
        else
        {
          first[ i ] = offset;
          if( foundOffset >= offset )
          {
            foundOffset = offset;
            foundTokenIndex = i;
          }
        }
      }
      else
      {
        if( foundOffset >= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
    }
    return first[ foundTokenIndex ];
  }

  /* */

  function tokenDelete( first, i )
  {
    o.nlTokens.splice( i, 1 );
    first.splice( i, 1 );
    if( foundTokenIndex > i )
    foundTokenIndex -= 1;
  }

  /* */

  function handleWithoutIntervalWithoutLine()
  {
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithoutLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.onEach( o );
  }

  /* */

  function handleWithoutIntervalWithLine()
  {
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

}

_eachLeft.defaults =
{
  src : null,
  nlTokens : null,
  interval : null,
  withLine : true,
}

//

function eachLeft( o )
{

  if( !_.map.is( o ) )
  {
    _.assert( arguments.length === 2 || arguments.length === 3 );
    if( arguments.length === 3 )
    o = { src : arguments[ 0 ], interval : arguments[ 1 ], onEach : arguments[ 2 ] };
    else
    o = { src : arguments[ 0 ], onEach : arguments[ 1 ] };
  }
  else
  {
    _.assert( arguments.length === 1 );
  }

  if( o.withLine === undefined )
  o.withLine = true;

  _.assert( _.routine.is( o.onEach ) );
  _.assert( _.str.is( o.src ) );

  return this._eachLeft( o );
}

//

function _eachRight( o )
{

  if( o.nlTokens === undefined )
  o.nlTokens = [ '\r\n', '\n\r', '\n' ];
  else if( !_.str.is( o.nlTokens ) )
  o.nlTokens = [ ... o.nlTokens ];

  const lastIndex = o.interval ? o.interval[ 1 ] : Infinity;
  const src = o.src;
  let foundTokenIndex;
  let foundOffset;
  let nnl = '';
  let handleEach;

  if( o.interval )
  {
    if( o.withLine )
    handleEach = handleWithIntervalWithLine;
    else
    handleEach = handleWithIntervalWithoutLine;
  }
  else
  {
    if( o.withLine )
    handleEach = handleWithoutIntervalWithLine;
    else
    handleEach = handleWithoutIntervalWithoutLine;
  }

  o.charInterval = [ o.src.length, o.src.length ];
  o.lineIndex = -1;

  if( o.interval && o.interval[ 1 ] < 0 )
  {
    o.charInterval[ 1 ] = o.src.length-1;
    return o;
  }

  o.nl = '';

  if( _.str.is( o.nlTokens ) )
  single();
  else
  multiple();

  if( !o.interval || o.lineIndex < o.interval[ 1 ] )
  {
    o.lineIndex += 1;
    o.charInterval[ 1 ] = -1;
    _.assert( o.charInterval[ 0 ] === 0 );
    if( o.withLine )
    o.line = '';
  }

  return o;

  /* */

  function single()
  {

    while( o.lineIndex !== lastIndex )
    {

      o.lineIndex += 1;
      o.nl = nnl;

      o.charInterval[ 1 ] = o.charInterval[ 0 ] - 1;
      let right = o.charInterval[ 1 ] - o.nl.length;
      if( right >= 0 || o.lineIndex === 0 )
      o.charInterval[ 0 ] = src.lastIndexOf( o.nlTokens, right );
      else
      o.charInterval[ 0 ] = -1;

      if( o.charInterval[ 0 ] === -1 )
      {
        o.charInterval[ 0 ] = 0;
        handleEach();
        break;
      }
      else
      {
        nnl = o.nlTokens;
        o.charInterval[ 0 ] += nnl.length;
        handleEach();
      }

    }

  }

  /* */

  function multiple()
  {

    foundTokenIndex = -1;
    foundOffset = 0;

    let first = indexInit();

    if( first.length === 1 )
    {
      o.nlTokens = o.nlTokens[ foundTokenIndex ];
      return single();
    }

    if( first.length === 0 )
    {
      o.lineIndex = 0;
      o.charInterval[ 0 ] = 0;
      o.charInterval[ 1 ] = src.length-1;
      handleEach();
      return;
    }

    while( o.lineIndex !== lastIndex )
    {

      o.lineIndex += 1;
      o.nl = nnl;

      o.charInterval[ 1 ] = o.charInterval[ 0 ] - 1;
      o.charInterval[ 0 ] = indexOf( first );

      if( o.charInterval[ 0 ] === -1 )
      {
        o.charInterval[ 0 ] = 0;
        handleEach();
        break;
      }
      else
      {
        nnl = o.nlTokens[ foundTokenIndex ];
        handleEach();
      }

    }

  }

  /* */

  function indexInit()
  {
    let first = [];
    for( let i = o.nlTokens.length - 1 ; i >= 0 ; i-- )
    {
      let offset = src.lastIndexOf( o.nlTokens[ i ] );
      if( offset !== -1 )
      {
        offset += o.nlTokens[ i ].length;
        first.unshift( offset );
        if( foundOffset <= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
      else
      {
        o.nlTokens.splice( i, 1 );
        foundTokenIndex -= 1;
      }
    }
    return first;
  }

  /* */

  function indexOf( first )
  {
    let left = o.charInterval[ 0 ] - nnl.length - 1;
    if( first[ foundTokenIndex ] <= left )
    return first[ foundTokenIndex ];
    foundOffset = -1;
    for( let i = first.length - 1; i >= 0 ; i-- )
    {
      let offset = first[ i ];
      if( offset > left )
      {
        if( left >= 0 )
        offset = src.lastIndexOf( o.nlTokens[ i ], left );
        else
        offset = -1;
        if( offset === -1 )
        {
          tokenDelete( first, i );
          if( first.length === 0 )
          return -1;
        }
        else
        {
          offset += o.nlTokens[ i ].length;
          first[ i ] = offset;
          if( foundOffset <= offset )
          {
            foundOffset = offset;
            foundTokenIndex = i;
          }
        }
      }
      else
      {
        if( foundOffset <= offset )
        {
          foundOffset = offset;
          foundTokenIndex = i;
        }
      }
    }
    return first[ foundTokenIndex ];
  }

  /* */

  function tokenDelete( first, i )
  {
    o.nlTokens.splice( i, 1 );
    first.splice( i, 1 );
    if( foundTokenIndex > i )
    foundTokenIndex -= 1;
  }

  /* */

  // function handleEach()
  // {
  //   if( !o.interval || o.interval[ 0 ] <= o.lineIndex )
  //   o.onEach( o );
  // }

  /* */

  function handleWithoutIntervalWithoutLine()
  {
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithoutLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.onEach( o );
  }

  /* */

  function handleWithoutIntervalWithLine()
  {
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

  function handleWithIntervalWithLine()
  {
    if( o.interval && o.interval[ 0 ] > o.lineIndex )
    return;
    o.line = src.slice( o.charInterval[ 0 ], o.charInterval[ 1 ] - o.nl.length + 1 );
    o.onEach( o );
  }

  /* */

}

_eachRight.defaults =
{
  ... _eachLeft.defaults,
}

//

function eachRight( o )
{

  if( !_.map.is( o ) )
  {
    _.assert( arguments.length === 2 || arguments.length === 3 );
    if( arguments.length === 3 )
    o = { src : arguments[ 0 ], interval : arguments[ 1 ], onEach : arguments[ 2 ] };
    else
    o = { src : arguments[ 0 ], onEach : arguments[ 1 ] };
  }
  else
  {
    _.assert( arguments.length === 1 );
  }

  if( o.withLine === undefined )
  o.withLine = true;

  _.assert( _.routine.is( o.onEach ) );
  _.assert( _.str.is( o.src ) );

  return this._eachRight( o );
}


// --
// str extension
// --

let StrExtension =
{

  // dichotomy

  is,
  like,

}

Object.assign( _.str, StrExtension );

// --
// str extension
// --

let StrLinesExtension =
{

  split,
  join,
  strip,

  atLeft,
  atRight,
  at : atLeft,

  _eachLeft,
  eachLeft,
  _eachRight,
  eachRight,
  each : eachLeft,

}

Object.assign( _.str.lines, StrLinesExtension );

// --
// tools extension
// --

let ToolsExtension =
{

  // dichotomy

  strIs : is,
  strsAreAll,
  // regexpLike,
  // strsLikeAll,
  strDefined,
  strsDefined,

  strHas,

  // converter

  strstrShort_ : strShort_, /* xxx : remove */
  strShort_,
  strShortWidth,
  _strShortWidth,
  strShortHeight,
  _strShortHeight,
  // strShort, /* original version without binary search cutting */
  // strShort_2, /* non-binary search implementation */
  strConcat,

  //

  _strBeginOf,
  _strEndOf,

  strBegins,
  strEnds,

  strBeginOf,
  strEndOf,

  strRemoveBegin,
  strRemoveEnd,
  strRemove,

  // lines

  strLinesSplit : split,
  strLinesJoin : join,
  strLinesStrip : strip,

}

Object.assign( _, ToolsExtension );

//

})();
