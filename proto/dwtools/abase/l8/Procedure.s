( function _Procedure_s_() {

'use strict';

/**
 * Minimal programming interface to launch, stop and track collection of asynchronous procedures. It prevents an application from termination waiting for the last procedure and helps to diagnose your system with many interdependent procedures.
  @module Tools/base/Procedure
*/

/**
 * @file Procedure.s.
 */

/**
 *@summary Collection of routines to launch, stop and track collection of asynchronous procedures.
  @namespace "wTools.procedure"
  @memberof module:Tools/base/Procedure
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wProto' );
  _.include( 'wCopyable' );

  try
  {
    _.include( 'wAppBasic' );
  }
  catch( err )
  {
  }

}

let _global = _global_;
let _ = _global_.wTools;

if( _realGlobal_ !== _global_ )
if( _realGlobal_.wTools && _realGlobal_.wTools.procedure )
return ExportTo( _global_, _realGlobal_ );

_.assert( !!_global_.wTools, 'Does not have wTools' );
_.assert( _global_.wTools.procedure === undefined, 'wTools.procedure is already defined' );
_.assert( _global_.wTools.Procedure === undefined, 'wTools.Procedure is already defined' );

_global_.wTools.procedure = Object.create( null );

// --
// inter
// --

/**
 * @classdesc Minimal programming interface to launch, stop and track collection of asynchronous procedures
 * @class wProcedure
 * @memberof module:Tools/base/Procedure
 */

let Parent = null;
let Self = function wProcedure( o )
{

  if( !( this instanceof Self ) )
  if( o instanceof Self )
  {
    return o;
  }

  o = Self.OptionsFrom( ... arguments );

  _.assert( o._stack === undefined || _.numberIs( o._stack ) || _.strIs( o._stack ) );

  o._stack = _.procedure.stack( o._stack, 1 );

  let args = [ o ];

  if( !( this instanceof Self ) )
  return new( _.constructorJoin( Self, args ) );
  return Self.prototype.init.apply( this, args );
}

Self.shortName = 'Procedure';

// --
// instance
// --

function init( o )
{
  let procedure = this;

  _.workpiece.initFields( procedure );
  Object.preventExtensions( procedure );
  procedure.copy( o );

  _.assert( _.strIs( procedure._stack ) );
  _.assert( procedure._sourcePath === null );

  procedure._sourcePath = procedure._stack.split( '\n' )[ 0 ];

  procedure._longNameMake();

  _.assert( _.strIs( procedure._sourcePath ) );
  _.assert( arguments.length === 1 );
  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );

  // if( _global_.debugger )
  // if( procedure.id === 2 )
  // debugger;

  return procedure;
}

//

function finit()
{
  let procedure = this;

  // if( _global_.debugger )
  // if( procedure.id === 2 )
  // debugger;

  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );
  _.assert( !procedure.isActivated(), `Cant finit ${procedure._longName}, it is activated` );

  delete _.Procedure.NamesMap[ procedure._longName ];

  return _.Copyable.prototype.finit.call( procedure );
}

//

function isAlive()
{
  let procedure = this;
  return procedure._timer !== null;
}

//

/**
 * @summary Launches the procedure.
 * @method begin
 * @memberof module:Tools/base/Procedure.wProcedure
 */

function begin()
{
  let procedure = this;

  _.assert( arguments.length === 0 );

  if( procedure._timer === null )
  if( procedure._object === 'entry' )
  procedure._timer = false;
  else
  procedure._timer = _.time._begin( Infinity );

  if( !procedure._longName )
  procedure._longNameMake();

  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );

  return procedure;
}

//

/**
 * @summary Stops the procedure.
 * @method end
 * @memberof module:Tools/base/Procedure.wProcedure
 */

function end()
{
  let procedure = this;

  _.assert( arguments.length === 0 );
  _.assert( procedure._timer !== null, `${procedure._longName} is not alive` );

  if( procedure._timer )
  _.time._cancel( procedure._timer );
  procedure._timer = null;

  procedure.finit();

  if( _.Procedure.Terminating )
  {
    _.Procedure.TerminationListInvalidated = 1;
    _.Procedure._TerminationRestart();
  }

  return procedure;
}

//

function isTopMost()
{
  let procedure = this;
  return procedure === _.Procedure.ActiveProcedure;
}

//

function isActivated()
{
  let procedure = this;
  return _.longHas( _.Procedure.ActiveProcedures, procedure );
}

//

function activate( val )
{
  let procedure = this;

  if( val === undefined )
  val = true;
  val = !!val;

  // console.log( `${ val ? 'activate' : 'deactivate'} ${procedure._longName} ${val ? _.Procedure.ActiveProcedures.length : _.Procedure.ActiveProcedures.length-1}` );

  _.assert( !procedure.finitedIs(), () => `${procedure._longName} is finited!` );

  if( val )
  {

    _.assert
    (
        procedure !== _.Procedure.ActiveProcedure
      , () => `${procedure._longName} is already active`
    );

    _.Procedure.ActiveProcedures.push( procedure );
    _.Procedure.ActiveProcedure = procedure;
  }
  else
  {
    _.assert
    (
        procedure === _.Procedure.ActiveProcedure
      , () => `Attempt to deactivate ${procedure._longName}`
            + `\nBut active procedure is ${_.Procedure.ActiveProcedure ? _.Procedure.ActiveProcedure._longName : _.Procedure.ActiveProcedure}`
    );

    _.Procedure.ActiveProcedures.pop();
    _.Procedure.ActiveProcedure = _.Procedure.ActiveProcedures[ _.Procedure.ActiveProcedures.length-1 ] || null;
  }

  return procedure;
}

//

function Activate( procedure, val )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( procedure instanceof Self );

  return procedure.activate( val );
}

//

/**
 * @summary Returns true if procedure is running.
 * @method isBegun
 * @memberof module:Tools/base/Procedure.wProcedure
 */

function isBegun()
{
  let procedure = this;
  _.assert( arguments.length === 0 );
  return !!procedure._timer;
}

//

function object( timer )
{
  let procedure = this;
  if( arguments.length === 1 )
  {
    _.assert( timer !== undefined );
    procedure._object = timer;
    return procedure;
  }
  else
  {
    _.assert( arguments.length === 0 );
    return procedure._object;
  }
}

//

function stack( stack )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._stack;

  if( procedure._stack )
  return;

  _.assert( arguments.length === 1 );

  procedure._stack = procedure.Stack( stack );

  if( procedure._name )
  procedure._longNameMake();

  return procedure;
}

//

function stackElse( stack )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._stack;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( procedure._stack && procedure._stackExplicit )
  return procedure;
  procedure._stackExplicit = 1;

  return procedure.stack( stack );
}

//

// function sourcePath( sourcePath )
// {
//   let procedure = this;
//
//   if( !Config.debug || !_.Procedure.UsingSourcePath )
//   {
//     if( !procedure._sourcePath )
//     procedure._sourcePath = '';
//     return procedure;
//   }
//
//   if( arguments.length === 0 )
//   return procedure._sourcePath;
//
//   _.assert( arguments.length === 1 );
//
//   if( sourcePath === undefined )
//   sourcePath = 1;
//   if( _.numberIs( sourcePath ) )
//   sourcePath += 1;
//   if( _.numberIs( sourcePath ) )
//   sourcePath = _.procedure.sourcePathGet( sourcePath );
//
//   _.assert( _.strIs( sourcePath ) );
//
//   procedure._sourcePath = sourcePath;
//
//   if( procedure._longName )
//   procedure._longNameMake();
//
//   return procedure;
// }
//
// //
//
// function sourcePathFirst( sourcePath )
// {
//   let procedure = this;
//
//   if( !Config.debug || !_.Procedure.UsingSourcePath )
//   {
//     if( !procedure._sourcePath )
//     procedure._sourcePath = '';
//     return procedure;
//   }
//
//   if( arguments.length === 0 )
//   return procedure._sourcePath;
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//
//   if( procedure._sourcePath && procedure._stackExplicit )
//   return procedure;
//
//   procedure._stackExplicit = 1;
//
//   if( sourcePath === undefined )
//   sourcePath = 1;
//   if( _.numberIs( sourcePath ) )
//   sourcePath += 1;
//
//   let result = procedure.sourcePath( sourcePath );
//
//   // if( procedure && procedure._sourcePath && _.strHas( procedure._sourcePath, '\Consequence.s:' ) )
//   // debugger;
//
//   return result;
// }

//

/**
 * @summary Getter/Setter routine for `name` property.
 * @description
 * Returns name of the procedure if no args provided. Sets name of procedure if provided single argument `name`.
 * @param {String} [name] Name of the procedure.
 * @method name
 * @memberof module:Tools/base/Procedure.wProcedure
 */

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

function nameElse( name )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._name;

  _.assert( arguments.length === 1 );

  if( procedure._name )
  return procedure;

  return procedure.name( name );
}

//

/**
 * @summary Getter/Setter routine for `longName` property.
 * @description
 * Returns `longName` of the procedure if no args provided. Sets name of procedure if provided single argument `name`.
 * @param {String} [longName] Full name of the procedure.
 * @method longName
 * @memberof module:Tools/base/Procedure.wProcedure
 */

function longName( longName )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._longName;

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( longName ) );
  _.assert( procedure.id > 0 );

  if( procedure._longName )
  {
    _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );
    delete _.Procedure.NamesMap[ procedure._longName ];
    procedure._longName = null;
  }

  procedure._longName = longName;
  _.assert( _.Procedure.NamesMap[ procedure._longName ] === undefined, () => `${procedure._longName} already exist` );
  _.Procedure.NamesMap[ procedure._longName ] = procedure;

  return procedure;
}

//

function _longNameMake()
{
  let procedure = this;

  let name = procedure._name || '';
  let sourcePath = procedure._sourcePath;

  _.assert( arguments.length === 0 );
  _.assert( _.strIs( name ) );

  if( procedure.id === 0 )
  procedure.id = procedure._IdAlloc();

  let result = 'procedure::' + name + '#' + procedure.id + ' @ ' + ( sourcePath ? ( sourcePath + '' ) : '' );

  procedure.longName( result );

  _.assert( procedure.id > 0 );

  return result;
}

// --
// static
// --

/**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} procedure Selector for procedure.
 * @routine Get
 * @returns {Object|Array} Returns one or several instances of {@link module:Tools/base/Procedure.wProcedure}.
 * @memberof module:Tools/base/Procedure.wProcedure
 */

 /**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} procedure Selector for procedure.
 * @routine get
 * @returns {Object|Array} Returns one or several instances of {@link module:Tools/base/Procedure.wProcedure}.
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function Get( procedure )
{
  let Cls = this;

  _.assert( arguments.length === 1 );

  if( _.arrayIs( procedure ) )
  {
    let result = procedure.map( ( p ) => Cls.Get( p ) );
    result = _.arrayFlatten( result );
    return result;
  }

  let result = procedure;

  if( _.numberIs( procedure ) )
  {
    result = _.filter( _.Procedure.NamesMap, { id : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    // procedure = result[ 0 ];
  }

  if( _.strIs( procedure ) )
  {
    result = _.filter( _.Procedure.NamesMap, { _name : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    // procedure = result[ 0 ];
  }

  if( _.routineIs( procedure ) )
  {
    result = _.filter( _.Procedure.NamesMap, { _routine : procedure } );
    result = _.mapVals( result );
    if( result.length > 1 )
    return result;
    if( !result.length )
    return result;
    // procedure = result[ 0 ];
  }

  if( _.arrayIs( result ) )
  _.assert( result.every( ( result ) => result instanceof Self, 'Not procedure' ) );
  else
  _.assert( result instanceof Self, 'Not procedure' );

  return result;
}

//

/**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} procedure Selector for procedure.
 * @routine GetSingleMaybe
 * @returns {Object} Returns single instance of {@link module:Tools/base/Procedure.wProcedure} or null.
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} procedure Selector for procedure.
 * @routine getSingleMaybe
 * @returns {Object} Returns single instance of {@link module:Tools/base/Procedure.wProcedure} or null.
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function GetSingleMaybe( procedure )
{
  _.assert( arguments.length === 1 );
  let result = _.procedure.get( procedure );
  if( _.arrayIs( result ) && result.length !== 1 )
  return null;
  return result;
}

//

function OptionsFrom( o )
{
  if( _.strIs( o ) )
  o = { _name : o }
  else if( _.numberIs( o ) )
  o = { _stack : o }

  _.assert( o === undefined || o === null || _.objectIs( o ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o === undefined || o === null )
  o = Object.create( null );

  return o;
}

//

function From( o )
{
  o = Self.OptionsFrom( ... arguments );
  o._stack = _.procedure.stack( o._stack, 1 );
  let result = Self( o );
  return result;
}

//

/**
 * @summary Short-cut for `begin` method. Creates instance of `wProcedure` and launches the routine.
 * @param {Object} o Options map
 * @param {String} o._name Name of procedure.
 * @param {Number} o._timer Timer for procedure.
 * @param {Function} o._routine Routine to lauch.
 * @routine Begin
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Short-cut for `begin` method. Creates instance of `wProcedure` and launches the routine.
 * @param {Object} o Options map
 * @param {String} o._name Name of procedure.
 * @param {Number} o._timer Timer for procedure.
 * @param {Function} o._routine Routine to lauch.
 * @routine begin
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function Begin( o )
{
  let result = Self.From( ... arguments );
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

/**
 * @summary Short-cut for `end` method. Selects procedure using `get` routine and stops the execution.
 * @param {Number|String|Routine} procedure Procedure selector.
 * @routine End
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Short-cut for `end` method. Selects procedure using `get` routine and stops the execution.
 * @param {Number|String|Routine} procedure Procedure selector.
 * @routine end
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function End( procedure )
{
  _.assert( arguments.length === 1 );
  procedure = _.procedure.get( procedure );
  return procedure.end();
}

//

/**
 * @summary Prints report with number of procedures that are still working.
 * @routine TerminationReport
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Prints report with number of procedures that are still working.
 * @routine terminationReport
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function TerminationReport()
{
  if( _.Procedure.TerminationListInvalidated )
  for( let p in _.Procedure.NamesMap )
  {
    let procedure = _.Procedure.NamesMap[ p ];
    if( procedure._object === 'entry' )
    continue;
    logger.log( procedure._longName );
  }
  _.Procedure.TerminationListInvalidated = 0;
  logger.log( 'Waiting for ' + ( Object.keys( _.Procedure.NamesMap ).length-1 ) + ' procedure(s) ... ' );
}

//

/**
 * @summary Starts procedure of termination.
 * @routine TerminationReport
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Starts procedure of termination.
 * @routine terminationReport
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function TerminationBegin()
{

  _.assert( this === _.Procedure );

  if( _.Procedure.Terminating )
  return;

  _.routineOptions( TerminationBegin, arguments );
  _.Procedure.Terminating = 1;
  _.Procedure.TerminationListInvalidated = 1;

  _.Procedure._OnTerminationBegin.forEach( ( callback ) =>
  {
    try
    {
      callback();
    }
    catch( err )
    {
      logger.error( _.errOnce( 'Error in callback of event "terminationBegin"\n', err ) );
    }
  });

  _.Procedure._TerminationRestart();
}

TerminationBegin.defaults =
{
}

//

function _TerminationIteration()
{
  _.assert( arguments.length === 1 );
  _.assert( _.Procedure.Terminating === 1 );

  _.Procedure.TerminationTimer = null;
  _.Procedure.TerminationReport();

  _.Procedure._TerminationRestart();

}

//

function _TerminationRestart()
{
  _.assert( arguments.length === 0 );
  _.assert( _.Procedure.Terminating >= 1 );

  if( _.Procedure.Terminating === 2 )
  {
    return;
  }

  if( _.Procedure.TerminationTimer )
  _.time._cancel( _.Procedure.TerminationTimer );
  _.Procedure.TerminationTimer = null;

  if( Object.keys( _.Procedure.NamesMap ).length-1 > 0 )
  {
    _.Procedure.TerminationTimer = _.time._begin( _.Procedure.TerminationPeriod, _.Procedure._TerminationIteration );
  }
  else
  {
    _.Procedure._TerminationEnd();
  }

}

//

function _TerminationEnd()
{
  _.assert( arguments.length === 0 );
  _.assert( _.Procedure.Terminating === 1 );
  _.assert( _.Procedure.TerminationTimer === null );

  _.Procedure.Terminating = 2;

  if( _.Procedure.EntryProcedure && _.Procedure.EntryProcedure.isAlive() )
  {
    _.Procedure.EntryProcedure.activate( 0 );
    _.Procedure.EntryProcedure.end();
  }

  _.Procedure._OnTerminationEnd.forEach( ( callback ) =>
  {
    try
    {
      callback();
    }
    catch( err )
    {
      logger.error( _.errOnce( 'Error in callback of event "terminationEnd"\n', err ) );
    }
  });

}

//

function _OnProcessExit()
{
  debugger;
  _.Procedure.TerminationBegin();
  debugger;
}

//

function _Setup()
{
  _.assert( _.strIs( _.setup._entryProcedureStack ) );

  if( !_.Procedure.EntryProcedure )
  _.Procedure.EntryProcedure = _.procedure.begin({ _stack : _.setup._entryProcedureStack, _object : 'entry' });

  _.assert( _.Procedure.ActiveProcedures.length === 0 );

  _.Procedure.EntryProcedure.activate( true );

  if( _.process && _.process.exitHandlerOnce )
  _.process.exitHandlerOnce( _.Procedure._OnProcessExit );

}

//

/**
 * @summary Increases counter of procedures and returns it value.
 * @routine _IdAlloc
 * @memberof module:Tools/base/Procedure.wProcedure
 */

/**
 * @summary Increases counter of procedures and returns it value.
 * @routine _IdAlloc
 * @memberof module:Tools/base/Procedure.wTools.procedure
 */

function _IdAlloc()
{

  _.assert( arguments.length === 0 );
  _.Procedure.Counter += 1;
  let result = _.Procedure.Counter;

  // if( result === 35 )
  // debugger;

  return result;
}

//

function WithObject( timer )
{
  let result = _.filter( _.Procedure.NamesMap, { _object : timer } );
  return _.mapVals( result )[ 0 ];
}

//

function Stack( stack, delta )
{

  if( !Config.debug || !_.Procedure.UsingSourcePath )
  return '';

  _.assert( delta === undefined || _.numberIs( delta ) );
  _.assert( stack === undefined || stack === null || _.numberIs( stack ) || _.strIs( stack ) );
  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( _.strIs( stack ) )
  return stack;

  if( stack === undefined || stack === null )
  stack = 1;
  if( _.numberIs( stack ) )
  stack += 1;
  if( delta )
  stack += delta;
  if( _.numberIs( stack ) )
  stack = _.diagnosticStack([ stack, Infinity ]);

  _.assert( _.strIs( stack ) );

  return stack;
}

//

function On( o )
{

  if( arguments.length === 2 )
  o = { callbackMap : { [ arguments[ 0 ] ] : arguments[ 1 ] } }

  _.assertMapHasOnly( o.callbackMap, _.Procedure.KnownEvents );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.callbackMap.terminationBegin )
  _.arrayAppend( _.Procedure._OnTerminationBegin, o.callbackMap.terminationBegin );
  if( o.callbackMap.terminationEnd )
  _.arrayAppend( _.Procedure._OnTerminationEnd, o.callbackMap.terminationEnd );

  return this;
}

On.defaults =
{
  callbackMap : null,
}

//

function Off( o )
{

  if( arguments.length === 2 )
  o = { callbackMap : { [ arguments[ 0 ] ] : arguments[ 1 ] } }
  if( _.strIs( arguments[ 0 ] ) )
  o = { callbackMap : { [ arguments[ 0 ] ] : null } }

  _.assertMapHasOnly( o.callbackMap, _.Procedure.KnownEvents );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.callbackMap.terminationBegin !== undefined )
  if( o.callbackMap.terminationBegin === null )
  _.arrayEmpty( _.Procedure._OnTerminationBegin );
  else
  _.arrayRemoveOnceStrictly( _.Procedure._OnTerminationBegin, o.callbackMap.terminationBegin );

  if( o.callbackMap.terminationEnd !== undefined )
  if( o.callbackMap.terminationEnd === null )
  _.arrayEmpty( _.Procedure._OnTerminationBegin );
  else
  _.arrayRemoveOnceStrictly( _.Procedure._OnTerminationBegin, o.callbackMap.terminationEnd );

  return this;
}

Off.defaults =
{
  callbackMap : null,
}

// --
// meta
// --

function ExportTo( dstGlobal, srcGlobal )
{
  _.assert( _.mapIs( srcGlobal.wTools.Procedure.ToolsExtension ) );
  _.mapExtend( dstGlobal.wTools, srcGlobal.wTools.Procedure.ToolsExtension );
  dstGlobal.wTools.time = _.mapExtend( dstGlobal.wTools.time || Object.create( null ), srcGlobal.wTools.Procedure.TimeExtension );
  if( typeof module !== 'undefined' && module !== null );
  module[ 'exports' ] = dstGlobal.wTools.procedure;
}

// --
// time
// --

function timeBegin( delay, procedure, onEnd )
{
  _.assert( arguments.length === 2 || arguments.length === 3 );
  if( onEnd === undefined && !_.procedureIs( procedure ) )
  {
    onEnd = arguments[ 1 ];
    procedure = 1;
  }
  if( procedure === undefined || procedure === null )
  procedure = 1;
  procedure = _.Procedure( procedure );
  let wasAlive = procedure.isAlive();
  if( !wasAlive )
  {
    procedure._timer = false;
    procedure.begin();
  }
  let timer = _.time._begin( delay, onEnd2 );
  procedure.object( timer );
  return timer;

  function onEnd2()
  {
    procedure.activate( true );
    try
    {
      if( onEnd )
      return onEnd( ... arguments );
    }
    finally
    {
      if( !procedure.isAlive() )
      {
        _.assert( procedure.finitedIs() );
        return;
      }
      procedure.activate( false );
      _.assert( !procedure.isActivated() );
      if( !wasAlive )
      procedure.end();
    }
  }

}

//

function timeCancel( timer )
{
  let procedure = _.Procedure.WithObject( timer );
  let result = _.time._cancel( ... arguments );
  if( procedure )
  {
    if( !procedure.isActivated() )
    procedure.end();
  }
  return result;
}

// --
// relations
// --

var KnownEvents =
{
  terminationBegin : null,
  terminationEnd : null,
}

let ToolsExtension =
{
  [ Self.shortName ] : Self,
  procedure : _.procedure,
}

let TimeExtension =
{
  begin : timeBegin,
  cancel : timeCancel,
}

let Composes =
{
}

let Associates =
{
  _name : null,
  _stack : null,
  _stackExplicit : 0,
  _object : null,
}

let Restricts =
{
  id : 0,
  _sourcePath : null,
  _longName : null,
  _timer : null,
  _waitTime : Infinity,
  _routine : null,
}

let Statics =
{

  // fields

  NamesMap : Object.create( null ),
  Terminating : 0,
  TerminationTimer : null,
  TerminationPeriod : 7500,
  TerminationListInvalidated : 1,
  UsingSourcePath : 1,
  Counter : 0,
  ActiveProcedure : null,
  ActiveProcedures : [],
  EntryProcedure : null,
  _OnTerminationBegin : [],
  _OnTerminationEnd : [],

  // routines

  Get, /* xxx : check. cover static routine Get */
  GetSingleMaybe,
  OptionsFrom,
  From,
  Begin,
  End,
  Activate,

  TerminationReport,
  TerminationBegin,
  _TerminationIteration,
  _TerminationRestart,
  _TerminationEnd,
  _OnProcessExit,
  _Setup,

  _IdAlloc,
  WithObject,
  Stack,
  On,
  Off,

  KnownEvents,
  ToolsExtension,
  TimeExtension,

}

let Forbids =
{

  namesMap : 'namesMap',
  terminating : 'terminating',
  terminationTimer : 'terminationTimer',
  terminationPeriod : 'terminationPeriod',
  terminationListInvalidated : 'terminationListInvalidated',
  usingSourcePath : 'usingSourcePath',
  counter : 'counter',
  activeProcedure : 'activeProcedure',
  activeProcedures : 'activeProcedures',
  entryProcedure : 'entryProcedure',
  _onTerminationBegin : '_onTerminationBegin',
  _onTerminationEnd : '_onTerminationEnd',

}

// --
// define class
// --

let ExtendClass =
{

  // inter

  init,
  finit,

  isAlive,
  begin,
  end,

  isTopMost,
  isActivated,
  activate,
  Activate,

  isBegun,

  object,
  stack,
  stackElse,
  name,
  nameElse,
  longName,
  _longNameMake,

  // relations

  Composes,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : ExtendClass,
});

_.Copyable.mixin( Self );

// --
// define namspeces
// --

// let Fields =
// {
//   namesMap : Object.create( null ),
//   terminating : 0,
//   terminationTimer : null,
//   terminationPeriod : 7500,
//   terminationListInvalidated : 1,
//   usingSourcePath : 1,
//   counter : 0,
//   activeProcedure : null,
//   activeProcedures : [],
//   entryProcedure : null,
//   _onTerminationBegin : [],
//   _onTerminationEnd : [],
// }

// let Routines =
// {
//
//   get : Get,
//   getSingleMaybe : GetSingleMaybe,
//   from : From,
//   begin : Begin,
//   end : End,
//   activate : Activate,
//   stack : Stack,
//
//   terminationReport : TerminationReport,
//   terminationBegin : TerminationBegin,
//
// }

_.assert( _.routineIs( _.accessor.define.getter.alias ) );
_.assert( _.routineIs( _.accessor.define.suite.alias ) );

let alias = ( originalName ) => _.accessor.define.suite.alias({ originalName, container : Self });
let join = ( originalName ) => _.routineJoin( Self, Self[ originalName ] );
let NamespaceBlueprint =
{

  // fields

  namesMap : alias( 'NamesMap' ),
  terminating : alias( 'Terminating' ),
  terminationTimer : alias( 'TerminationTimer' ),
  terminationPeriod : alias( 'TerminationPeriod' ),
  terminationListInvalidated : alias( 'TerminationListInvalidated' ),
  usingSourcePath : alias( 'UsingSourcePath' ),
  counter : alias( 'Counter' ),
  activeProcedure : alias( 'ActiveProcedure' ),
  activeProcedures : alias( 'ActiveProcedures' ),
  entryProcedure : alias( 'EntryProcedure' ),

  // routines

  get : join( 'Get' ),
  getSingleMaybe : join( 'GetSingleMaybe' ),
  from : join( 'From' ),
  begin : join( 'Begin' ),
  end : join( 'End' ),
  activate : join( 'Activate' ),
  stack : join( 'Stack' ),
  terminationReport : join( 'TerminationReport' ),
  terminationBegin : join( 'TerminationBegin' ),

}

_.construction.extend( _.procedure, NamespaceBlueprint );

// Object.assign( _.procedure, Routines );
// Object.assign( _.procedure, Fields );

Object.assign( _, ToolsExtension );
Object.assign( _.time, TimeExtension );

_[ Self.shortName ] = Self;

_Setup();

_.assert( _.routineIs( _.procedure.get ) );
_.assert( _.routineIs( Self.Get ) );

// --
// export
// --

if( _realGlobal_ !== _global_ )
return ExportTo( _realGlobal_, _global_ );

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _.procedure;

})();
