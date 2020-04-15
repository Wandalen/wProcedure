( function _Procedure_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

_.assert( !!_global_.wTools, 'Does not have wTools' );
_.assert( _global_.wTools.Procedure === undefined, 'wTools.Procedure is already defined' );

// --
// inter
// --

/**
 *@summary Collection of routines to launch, stop and track collection of asynchronous procedures.
  @namespace wTools.procedure
  @extends Tools
  @module Tools/base/Procedure
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
  o._stack = _.Procedure.Stack( o._stack, 1 );

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

  _.arrayAppendOnceStrictly( _.Procedure.InstancesArray, procedure );

  _.assert( _.strIs( procedure._sourcePath ) );
  _.assert( arguments.length === 1 );
  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );

  return procedure;
}

//

function finit()
{
  let procedure = this;

  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );
  _.assert( !procedure.isActivated(), `Cant finit ${procedure._longName}, it is activated` );

  delete _.Procedure.NamesMap[ procedure._longName ];

  _.arrayRemoveOnceStrictly( _.Procedure.InstancesArray, procedure );

  return _.Copyable.prototype.finit.call( procedure );
}

//

function isAlive()
{
  let procedure = this;
  return procedure._waitTimer !== null;
}

//

/**
 * @summary Launches the procedure.
 * @method begin
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

function begin()
{
  let procedure = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( procedure._waitTimer === null )
  procedure._waitTimer = _.time._begin( Infinity );

  if( !procedure._longName )
  procedure._longNameMake();

  _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );

  return procedure;
}

//

/**
 * @summary Stops the procedure.
 * @method end
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

function end()
{
  let procedure = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( procedure._waitTimer !== null, `${procedure._longName} is not alive` );

  if( procedure._waitTimer )
  _.time._cancel( procedure._waitTimer );
  procedure._waitTimer = null;

  procedure.finit();

  if( _.Procedure._Terminating )
  {
    _.procedure._terminationListInvalidated = 1;
    _.procedure._terminationRestart();
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

  _.assert( !procedure.isFinited(), () => `${procedure._longName} is finited!` );

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

function use()
{
  let procedure = this;
  let result = procedure.isUsed();
  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( procedure._counter >= 0 );
  _.assert( !procedure.isFinited() );
  procedure._counter += 1;
  return result;
}

//

function unuse()
{
  let procedure = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !procedure.isFinited() );
  procedure._counter -= 1;
  _.assert( procedure._counter >= 0 );
  let result = procedure.isUsed();
  return result;
}

//

function isUsed()
{
  let procedure = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( procedure._counter >= 0 );
  return procedure._counter > 0;
}

//

/**
 * @summary Returns true if procedure is running.
 * @method isBegun
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

function isBegun()
{
  let procedure = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return !!procedure._waitTimer;
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
    _.assert( arguments.length === 0, 'Expects no arguments' );
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

  if( procedure._stack && procedure._explicit )
  return procedure;
  procedure._explicit = true;

  return procedure.stack( stack );
}

//

/**
 * @summary Getter/Setter routine for `name` property.
 * @description
 * Returns name of the procedure if no args provided. Sets name of procedure if provided single argument `name`.
 * @param {String} [name] Name of the procedure.
 * @method name
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
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
 * @summary Getter/Setter routine for `routine` property.
 * @description
 * Returns routine of the procedure if no args provided. Sets routine of procedure if provided single argument `routine`.
 * @param {String} [routine] Name of the procedure.
 * @method routine
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

function routine( routine )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._routine;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( routine ), () => 'Expects routine, but got ' + _.strType( routine ) );

  procedure._routine = routine;

  if( procedure._longName )
  procedure._longNameMake();

  return procedure;
}

//

function routineElse( routine )
{
  let procedure = this;

  if( arguments.length === 0 )
  return procedure._routine;

  _.assert( arguments.length === 1 );

  if( procedure._routine )
  return procedure;

  return procedure.routine( routine );
}

//

/**
 * @summary Getter/Setter routine for `longName` property.
 * @description
 * Returns `longName` of the procedure if no args provided. Sets name of procedure if provided single argument `name`.
 * @param {String} [longName] Full name of the procedure.
 * @method longName
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
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

  _.assert( arguments.length === 0, 'Expects no arguments' );
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
 * @param {Number|String|Routine} filter Filter to filter procedures.
 * @routine Filter
 * @returns {Object|Array} Returns one or several instances of {@link module:Tools/base/Procedure.wProcedure}.
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

 /**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} filter Filter to filter procedures.
 * @routine Filter
 * @returns {Object|Array} Returns one or several instances of {@link module:Tools/base/Procedure.wProcedure}.
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function Filter( filter )
{
  let Cls = this;

  _.assert( arguments.length === 1 );

  if( _.arrayIs( filter ) )
  {
    let result = filter.map( ( p ) => Cls.Filter( p ) );
    result = _.arrayFlatten( result );
    return result;
  }

  let result = filter;
  let procedures = _.mapVals( _.Procedure.NamesMap );

  if( _.mapIs( filter ) )
  {
    if( filter._quasi === null )
    delete filter._quasi;
    if( _.boolLike( filter._quasi ) )
    filter._quasi = !!filter._quasi;

    if( filter.procedures )
    procedures = filter.procedures;
    delete filter.procedures;

    _.assert( _.arrayIs( procedures ) );
    result = _.filter( procedures, filter );
    if( !result.length )
    return result;
  }

  if( _.numberIs( filter ) )
  {
    result = _.filter( procedures, { id : filter } );
    if( !result.length )
    return result;
  }

  if( _.strIs( filter ) )
  {
    result = _.filter( procedures, { _name : filter } );
    if( !result.length )
    return result;
  }

  if( _.routineIs( filter ) )
  {
    result = _.filter( procedures, { _routine : filter } );
    if( !result.length )
    return result;
  }

  if( _.arrayIs( result ) )
  _.assert( result.every( ( result ) => result instanceof Self, 'Not a filter' ) );
  else
  _.assert( result instanceof Self, `${_.strType( result )} is not a filter` );

  return result;
}

//

function NativeWatchingEnable( o )
{

  o = _.routineOptions( NativeWatchingEnable, o );
  _.assert( !!o.enable, 'not tested' );

  let original = _.Procedure._OriginalTimeRoutines = _.Procedure._OriginalTimeRoutines || Object.create( null );

  if( o.enable )
  {
    _.assert( _.lengthOf( original ) === 0 );

    original.setTimeout = _global_.setTimeout;
    original.clearTimeout = _global_.clearTimeout;
    original.setInterval = _global_.setInterval;
    original.clearInterval = _global_.clearInterval;
    if( _global_.requestAnimationFrame )
    original.requestAnimationFrame = _global_.requestAnimationFrame;
    if( _global_.cancelAnimationFrame )
    original.cancelAnimationFrame = _global_.cancelAnimationFrame;

    _global_.setTimeout = setTimeout;
    _global_.clearTimeout = clearTimeout;
    _global_.setInterval = setInterval;
    _global_.clearInterval = clearInterval;
    if( _global_.requestAnimationFrame )
    _global_.requestAnimationFrame = requestAnimationFrame;
    if( _global_.cancelAnimationFrame )
    _global_.cancelAnimationFrame = cancelAnimationFrame;

  }
  else
  {

    for( let k in original )
    {
      _.assert( _.routineIs( original[ k ] ) );
      _global_[ k ] = original[ k ];
      delete original[ k ];
    }

  }

  /* */

  function setTimeout( onTime, ... args )
  {
    let object = original.setTimeout.call( _global_, onTime2, ... args );
    let procedure = procedureMake({ _object : object });
    return object;
    function onTime2()
    {
      procedureRemove( procedure );
      return onTime( ... arguments );
    }
  }

  /* */

  function clearTimeout( timer )
  {
    let result = original.clearTimeout.call(  _global_, ... arguments );
    let procedures = _.Procedure.Filter({ _object : timer })
    if( procedures.length )
    procedureRemove( procedures[ 0 ] );
    return result;
  }

  /* */

  function setInterval( onTime, ... args )
  {
    let object = original.setInterval.call(  _global_, onTime, ... args );
    let procedure = procedureMake({ _object : object });
    return object;
  }

  /* */

  function clearInterval( timer )
  {
    let result = original.clearInterval.call( _global_, ... arguments );
    let procedures = _.Procedure.Filter({ _object : timer })
    if( procedures.length )
    procedureRemove( procedures[ 0 ] );
    return result;
  }

  /* */

  function requestAnimationFrame( onTime, ... args )
  {
    let object = original.requestAnimationFrame.call( _global_, onTime, ... args );
    let procedure = procedureMake({ _object : object });
    return object;
  }

  /* */

  function cancelAnimationFrame( timer )
  {
    let result = original.cancelAnimationFrame.call( _global_, ... arguments );
    let procedures = _.Procedure.Filter({ _object : timer })
    if( procedures.length )
    procedureRemove( procedures[ 0 ] );
    return result;
  }

  /* */

  function procedureMake( o )
  {
    let procedure = new _.Procedure
    ({
      _waitTimer : false,
      _stack : 2,
      ... o,
    });
    return procedure;
  }

  /* */

  function procedureRemove( procedure )
  {
    procedure.finit();
  }

  /* */

}

NativeWatchingEnable.defaults =
{
  enable : 1,
}

//

/**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} filter Filter to filter procedures.
 * @routine GetSingleMaybe
 * @returns {Object} Returns single instance of {@link module:Tools/base/Procedure.wProcedure} or null.
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

/**
 * @summary Find procedure using id/name/routine as key.
 * @param {Number|String|Routine} filter Filter to filter procedures.
 * @routine getSingleMaybe
 * @returns {Object} Returns single instance of {@link module:Tools/base/Procedure.wProcedure} or null.
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function GetSingleMaybe( filter )
{
  _.assert( arguments.length === 1 );
  let result = this.Filter( filter );
  if( _.arrayIs( result ) && result.length !== 1 )
  return null;
  return result;
}

//

function ExportInfo( o )
{
  let result = '';

  if( _.longIs( arguments[ 0 ] ) )
  o = { procedures : o }
  o = _.routineOptions( ExportInfo, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  let procedures = this.Filter( o );

  for( let p = 0 ; p < procedures.length ; p++ )
  {
    let procedure = procedures[ p ];
    result += procedure._longName + '\n';
  }

  return result;
}

ExportInfo.defaults =
{
  procedures : null,
  _quasi : null,
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
  o._stack = _.Procedure.Stack( o._stack, 1 );
  let result = Self( o );
  return result;
}

//

/**
 * @summary Short-cut for `begin` method. Creates instance of `wProcedure` and launches the routine.
 * @param {Object} o Options map
 * @param {String} o._name Name of procedure.
 * @param {Number} o._waitTimer Timer for procedure.
 * @param {Function} o._routine Routine to lauch.
 * @routine Begin
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

/**
 * @summary Short-cut for `begin` method. Creates instance of `wProcedure` and launches the routine.
 * @param {Object} o Options map
 * @param {String} o._name Name of procedure.
 * @param {Number} o._waitTimer Timer for procedure.
 * @param {Function} o._routine Routine to lauch.
 * @routine begin
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
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
  _waitTimer : null,
  _routine : null,
}

//

/**
 * @summary Short-cut for `end` method. Selects procedure using `get` routine and stops the execution.
 * @param {Number|String|Routine} procedure Procedure selector.
 * @routine End
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

/**
 * @summary Short-cut for `end` method. Selects procedure using `get` routine and stops the execution.
 * @param {Number|String|Routine} procedure Procedure selector.
 * @routine end
 * @returns {Object} Returns instance of {@link module:Tools/base/Procedure.wProcedure}
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function End( procedure )
{
  _.assert( arguments.length === 1 );
  procedure = _.procedure.find( procedure );
  return procedure.end();
}

//

/**
 * @summary Increases counter of procedures and returns it value.
 * @routine _IdAlloc
 * @class wProcedure
 * @namespace Tools
 * @module Tools/base/Procedure
 */

/**
 * @summary Increases counter of procedures and returns it value.
 * @routine _IdAlloc
 * @module Tools/base/Procedure
 * @namespace Tools.procedure
 */

function _IdAlloc()
{

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.Procedure.Counter += 1;
  let result = _.Procedure.Counter;

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

  if( !Config.debug || !_.Procedure.UsingStack )
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
  stack = _.introspector.stack([ stack, Infinity ]);

  _.assert( _.strIs( stack ) );

  return stack;
}

// --
// relations
// --

let Composes =
{
}

let Associates =
{
  _name : null,
  _stack : null,
  _object : null,
  _waitTimer : null,
  _explicit : false,
  _quasi : false,
}

let Restricts =
{
  id : 0,
  _counter : 0,
  _sourcePath : null,
  _longName : null,
  _routine : null,
  _waitTime : Infinity,
}

let Statics =
{

  // fields

  NamesMap : Object.create( null ),
  InstancesArray : [],
  _Terminating : 0,
  _Exiting : 0,
  _TerminationTimer : null,
  _TerminationListInvalidated : 1,
  TerminationPeriod : 7500,
  UsingStack : 1,
  Counter : 0,
  ActiveProcedure : null,
  ActiveProcedures : [],
  EntryProcedure : null,
  _OriginalTimeRoutines : null,

  // routines

  NativeWatchingEnable,

  Filter, /* qqq : cover please. one test routine per type of input data */
  GetSingleMaybe,
  ExportInfo,
  OptionsFrom,
  From,
  Begin,
  End,
  Activate,

  _IdAlloc,
  WithObject,
  Stack,

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
  _timer : '_timer',

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

  use,
  unuse,
  isUsed,

  isBegun,

  object,
  stack,
  stackElse,
  name,
  nameElse,
  routine,
  routineElse,
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

_.assert( _.routineIs( _.accessor.define.getter.alias ) );
_.assert( _.routineIs( _.accessor.define.suite.alias ) );

let alias = ( originalName ) => _.accessor.define.suite.alias({ originalName, container : Self });
let join = ( originalName ) => _.routineJoin( Self, Self[ originalName ] );
let NamespaceBlueprint =
{

  // fields

  namesMap : alias( 'NamesMap' ),
  instancesArray : alias( 'InstancesArray' ),

  terminationPeriod : alias( 'TerminationPeriod' ),
  usingSourcePath : alias( 'UsingStack' ),
  counter : alias( 'Counter' ),
  activeProcedure : alias( 'ActiveProcedure' ),
  activeProcedures : alias( 'ActiveProcedures' ),
  entryProcedure : alias( 'EntryProcedure' ),

  // routines

  find : join( 'Filter' ),
  getSingleMaybe : join( 'GetSingleMaybe' ),
  from : join( 'From' ),
  begin : join( 'Begin' ),
  end : join( 'End' ),
  activate : join( 'Activate' ),
  stack : join( 'Stack' ),
  exportInfo : join( 'ExportInfo' ),

}

_.construction.extend( _.procedure, NamespaceBlueprint );

_[ Self.shortName ] = Self;
_.procedure[ Self.shortName ] = Self;

_.procedure._Setup1();

_.assert( _.routineIs( _.procedure.find ) );
_.assert( _.routineIs( Self.Filter ) );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _.procedure;

})();
