( function _Procedure_s_() {

'use strict';

/**
  @module Tools/base/Procedure - Minimal programming interface to launch, stop and track collection of asynchronous procedures. It prevents an application from termination waiting for the last procedure and helps to diagnose your system with many interdependent procedures.
*/

/**
 * @file Procedure.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wProcedure' );

}

debugger;

if( _realGlobal_ !== _global_ )
if( _realGlobal_.wTools && _realGlobal_.wTools.procedure )
{
  _global_.wTools.procedure = _realGlobal_.wTools.procedure;
  if( typeof module !== 'undefined' && module !== null )
  module[ 'exports' ] = _global_.wTools.procedure;
  return;
}

let _global = _global_;
let _ = _global_.wTools;

_.assert( !!_realGlobal_.wTools, 'Real global does not have wTools' );
_.assert( _global_.wTools.procedure === undefined, 'wTools.procedure is already defined' );
_.assert( _global_.wTools.Procedure === undefined, 'wTools.Procedure is already defined' );

_realGlobal_.wTools.procedure = _global_.wTools.procedure = Object.create( null );

// --
//
// --

let Parent = null;
let Self = function wProcedure( o )
{

  if( _.strIs( o ) )
  o = { _name : o }

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( o === undefined || _.objectIs( o ) );

  if( o === undefined )
  o = Object.create( null );

  if( o._sourcePath === undefined )
  o._sourcePath = 1;
  if( _.numberIs( o._sourcePath ) )
  o._sourcePath += 1;
  o._sourcePath = _.procedure.sourcePathGet( o._sourcePath );

  let args = [ o ];

  if( !( this instanceof Self ) )
  if( o instanceof Self )
  {
    return o;
  }
  else
  {
    return new( _.constructorJoin( Self, args ) );
  }

  return Self.prototype.init.apply( this, args );
}

Self.shortName = 'Procedure';

// --
// instance
// --

function init( o )
{
  let procedure = this;

  _.instanceInit( procedure );
  Object.preventExtensions( procedure );
  procedure.copy( o );

  _.assert( _.strIs( procedure._sourcePath ) );

  // debugger;
  // procedure.sourcePath( procedure._sourcePath );
  procedure._longNameMake();

  _.assert( _.strIs( procedure._sourcePath ) );
  _.assert( arguments.length === 1 );
  _.assert( _.procedure.namesMap[ procedure._longName ] === procedure );

  return procedure;
}

//

function begin()
{
  let procedure = this;

  _.assert( arguments.length === 0 );

  if( procedure._timer === null )
  procedure._timer = _.timeBegin( Infinity );

  if( !procedure._longName )
  procedure._longNameMake();

  _.assert( _.procedure.namesMap[ procedure._longName ] === procedure );

  return procedure;
}

//

function end()
{
  let procedure = this;

  _.assert( arguments.length === 0 );
  _.assert( !!procedure._timer );
  _.assert( _.procedure.namesMap[ procedure._longName ] === procedure, () => 'Procedure ' + _.strQuote( o._longName ) + ' not found' );

  delete _.procedure.namesMap[ procedure._longName ];

  _.timeEnd( procedure._timer );
  procedure._timer = null;
  procedure.id = 0;
  procedure._sourcePathSetExplicitly = 0;

  if( _.procedure.terminating )
  {
    _.procedure.terminationListInvalidated = 1;
    _.procedure._terminationRestart();
    // logger.log( 'Waiting for ' + Object.keys( _.procedure.namesMap ).length + ' procedure(s) ... ' )
  }

  return procedure;
}

//

function isBegun()
{
  let procedure = this;
  _.assert( arguments.length === 0 );
  return !!procedure._timer;
}

//

function sourcePath( sourcePath )
{
  let procedure = this;

  if( !Config.debug || !_.procedure.usingSourcePath )
  {
    if( !procedure._sourcePath )
    procedure._sourcePath = '';
    return procedure;
  }

  if( arguments.length === 0 )
  return procedure._sourcePath;

  _.assert( arguments.length === 1 );

  if( sourcePath === undefined )
  sourcePath = 1;
  if( _.numberIs( sourcePath ) )
  sourcePath += 1;
  if( _.numberIs( sourcePath ) )
  sourcePath = _.procedure.sourcePathGet( sourcePath );

  _.assert( _.strIs( sourcePath ) );

  procedure._sourcePath = sourcePath;

  if( procedure._longName )
  procedure._longNameMake();

  return procedure;
}

//

function sourcePathFirst( sourcePath )
{
  let procedure = this;

  if( !Config.debug || !_.procedure.usingSourcePath )
  {
    if( !procedure._sourcePath )
    procedure._sourcePath = '';
    return procedure;
  }

  if( arguments.length === 0 )
  return procedure._sourcePath;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( procedure._sourcePath && procedure._sourcePathSetExplicitly )
  return procedure;

  procedure._sourcePathSetExplicitly = 1;

  if( sourcePath === undefined )
  sourcePath = 1;
  if( _.numberIs( sourcePath ) )
  sourcePath += 1;

  let result = procedure.sourcePath( sourcePath );

  // if( procedure && procedure._sourcePath && _.strHas( procedure._sourcePath, '\Consequence.s:' ) )
  // debugger;

  return result;
}

//

function name( name )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._name;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ), () => 'Expects string, but got ' + _.strType( name ) );

  procedure._name = name;

  if( procedure._longName )
  procedure._longNameMake();

  return procedure;
}

//

function longName( longName )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._longName;

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( longName ) );

  if( procedure._longName )
  {
    _.assert( _.procedure.namesMap[ procedure._longName ] === procedure, () => 'Procedure ' + _.strQuote( procedure._longName ) + ' not found' );
    delete _.procedure.namesMap[ procedure._longName ];
    procedure._longName = null;
  }

  if( procedure.id === 0 )
  procedure.id = procedure.IndexAlloc();

  procedure._longName = longName;
  _.procedure.namesMap[ procedure._longName ] = procedure;

  return procedure;
}

//

function _longNameMake()
{
  let procedure = this;

  if( procedure.id === 0 )
  procedure.id = procedure.IndexAlloc();

  let name = procedure._name || '';
  let sourcePath = procedure._sourcePath;

  _.assert( arguments.length === 0 );
  _.assert( _.strIs( name ) );
  _.assert( procedure.id > 0 );

  let result = ( sourcePath ? ( sourcePath + ' - ' ) : '' ) + name + ' # ' + procedure.id;

  procedure.longName( result );

  return result;
}

// --
// static
// --

function Get( procedure )
{
  _.assert( arguments.length === 1 );

  if( _.numberIs( procedure ) )
  {
    let result = _.filter( _.procedure.namesMap, { id : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    procedure = result[ 0 ];
  }

  if( _.strIs( procedure ) )
  {
    let result = _.filter( _.procedure.namesMap, { _name : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    procedure = result[ 0 ];
  }

  if( _.routineIs( procedure ) )
  {
    let result = _.filter( _.procedure.namesMap, { _routine : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    procedure = result[ 0 ];
  }

  _.assert( procedure instanceof Self, 'Not procedure' );

  return procedure;
}

//

function GetSingleMaybe( procedure )
{
  _.assert( arguments.length === 1 );
  let result = _.procedure.get( procedure );
  if( _.arrayIs( result ) && result.length !== 1 )
  return null;
  return result;
}

//

function Begin( o )
{
  if( _.strIs( o ) )
  o = { _name : o }

  _.assert( o === undefined || _.objectIs( o ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o === undefined )
  o = Object.create( null );

  if( o._sourcePath === undefined || o._sourcePath === null )
  o._sourcePath = 1;
  if( _.numberIs( o._sourcePath ) )
  o._sourcePath += 1;
  o._sourcePath = _.procedure.sourcePathGet( o._sourcePath );

  let result = new Self( o );

  result.begin();

  return result;
}

Begin.defaults =
{
  _name : null,
  _timer : null,
  _routine : null,
}

//

function End( procedure )
{
  _.assert( arguments.length === 1 );
  procedure = _.procedure.get( procedure );
  return procedure.end();
}

//

function TerminationReport()
{
  if( _.procedure.terminationListInvalidated )
  for( let p in _.procedure.namesMap )
  {
    let procedure = _.procedure.namesMap[ p ];
    logger.log( procedure._longName );
  }
  _.procedure.terminationListInvalidated = 0;
  logger.log( 'Waiting for ' + Object.keys( _.procedure.namesMap ).length + ' procedure(s) ... ' );
}

//

function TerminationBegin()
{
  _.routineOptions( TerminationBegin, arguments );
  _.procedure.terminating = 1;
  _.procedure.terminationListInvalidated = 1;
  _.procedure._terminationRestart();
}

TerminationBegin.defaults =
{
}

//

function _TerminationIteration()
{
  _.assert( arguments.length === 1 );
  _.assert( _.procedure.terminating === 1 );
  _.procedure.terminationTimer = null;
  _.procedure.terminationReport();
  _.procedure._terminationRestart();
}

//

function _TerminationRestart()
{
  _.assert( arguments.length === 0 );
  _.assert( _.procedure.terminating === 1 );
  if( _.procedure.terminationTimer )
  _.timeEnd( _.procedure.terminationTimer );
  _.procedure.terminationTimer = null;

  if( Object.keys( _.procedure.namesMap ).length )
  {
    // _.procedure.terminationReport();
    _.procedure.terminationTimer = _.timeBegin( _.procedure.terminationPeriod, _.procedure._terminationIteration );
  }

}

//

function IndexAlloc()
{
  let procedure = this;
  _.assert( arguments.length === 0 );
  _.procedure.counter += 1;
  let result = _.procedure.counter;
  return result;
}

//

function SourcePathGet( sourcePath )
{
  if( !Config.debug || !_.procedure.usingSourcePath )
  return '';

  if( _.numberIs( sourcePath ) )
  sourcePath = _.diagnosticStack([ sourcePath+1, sourcePath+2 ]).trim();

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( sourcePath ), () => 'Expects source path of procedure, but got ' + _.strType( sourcePath ) );

  return sourcePath;
}

// --
// relations
// --

let Associates =
{
  id : 0,
  _name : null,
  _sourcePath : null,
  _sourcePathSetExplicitly : 0,
  _longName : null,
  _timer : null,
  _waitTime : Infinity,
  _routine : null,
}

let Statics =
{

  Get,
  GetSingleMaybe,
  Begin,
  End,

  TerminationReport,
  TerminationBegin,
  _TerminationIteration,
  _TerminationRestart,

  IndexAlloc,
  SourcePathGet,

}

let Fields =
{
  namesMap : Object.create( null ),
  terminating : 0,
  terminationTimer : null,
  terminationPeriod : 7500,
  terminationListInvalidated : 1,
  usingSourcePath : 1,
  counter : 0,
}

let Routines =
{

  get : Get,
  getSingleMaybe : GetSingleMaybe,
  begin : Begin,
  end : End,

  terminationReport : TerminationReport,
  terminationBegin : TerminationBegin,
  _terminationIteration : _TerminationIteration,
  _terminationRestart : _TerminationRestart,

  indexAlloc : IndexAlloc,
  sourcePathGet : SourcePathGet,

}

// --
// declare
// --

let Extend =
{

  // inter

  init,
  begin,
  end,

  isBegun,

  sourcePath,
  sourcePathFirst,
  name,
  longName,
  _longNameMake,

  // relations

  Associates,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

Object.assign( _.procedure, Routines );
Object.assign( _.procedure, Fields );

_[ Self.shortName ] = Self;

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _.procedure;

})();
