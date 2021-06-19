( function _Event_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

  require( '../l8_procedure/Include.s' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
//
// --

function onWithArguments( test )
{
  const self = this;
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'no callbacks for events';
    return null;
  });
  var program = a.program( withoutCallbacks );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[]' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'single callback for single event, single event is given';
    return null;
  });
  var program = a.program( callbackForTerminationBegin );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'single callback for single event, a few events are given';
    return null;
  });
  var program = a.program( callbackForTerminationBeginDouble );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'single callback for single event, a few events are given';
    return null;
  });
  var program = a.program( callbacksForEvents );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var exp = `[ [], 1 ]`;
    test.identical( _.strCount( op.output, exp ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function withoutCallbacks()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure._eventTerminationBeginHandle();
    _.procedure._eventTerminationEndHandle();
    console.log( result );
  }

  /* */

  function callbackForTerminationBegin()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure.on( 'terminationBegin', ( ... args ) => result.push( args ) );
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function callbackForTerminationBeginDouble()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure.on( 'terminationBegin', ( ... args ) => result.push( args ) );
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function callbacksForEvents()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure.on( 'terminationBegin', ( ... args ) => result.push( args ) );
    _.procedure.on( 'terminationEnd', ( e ) => result.push( result.length ) );
    _.procedure.terminationBegin();
    _.procedure.terminationBegin();
    console.log( result );
  }
}

onWithArguments.timeOut = 30000;

// function onWithArguments( test )
// {
//   var self = this;
//
//   /* */
//
//   test.case = 'no callback for events';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [] );
//
//   /* */
//
//   test.case = 'single callback for single event, single event is given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on( 'terminationBegin', onEvent );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//
//   /* */
//
//   test.case = 'single callback for single event, a few events are given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on( 'terminationBegin', onEvent );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0, 1 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//
//   /* */
//
//   test.case = 'single callback for each events in event handler, a few events are given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on( 'terminationBegin', onEvent );
//   var got2 = _.procedure.on( 'terminationEnd', onEvent2 );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0, 1, -2, -3 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//   got2.terminationEnd.off();
// }


//

function onWithOptionsMap( test )
{
  const self = this;
  const a = test.assetFor( false );
  const con = _.take( null );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  con.then( () =>
  {
    test.case = 'no callbacks for events';
    var program = a.program( withoutCallbacks );
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[]' ), 1 );
      return null;
    });
  });

  /* - */

  con.then( () =>
  {
    test.open( 'single callback for event' );
    return null;
  });

  con.then( () =>
  {
    test.case = 'single callback for single event, single event is given';
    var o =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : false,
    };
    var program = a.program({ entry : callbackForTerminationBegin, locals : { o, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
      return null;
    });
  });

  /* */

  con.then( () =>
  {
    test.case = 'single callback for single event, a few events are given';
    var o =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : false,
    };
    var program = a.program({ entry : callbackForTerminationBeginDouble, locals : { o, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
      return null;
    });
  });

  /* */

  con.then( () =>
  {
    test.case = 'single callback for single event, a few events are given';
    var o =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : false,
    };
    var program = a.program({ entry : callbacksForEvents, locals : { o, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ [], 1 ]' ), 1 );
      return null;
    });
  });

  con.then( () =>
  {
    test.close( 'single callback for event' );
    return null;
  });

  /* - */

  con.then( () =>
  {
    test.open( 'options map with option first' );
    return null;
  });

  con.then( () =>
  {
    test.case = 'callback1.first - false, callback2.first - false';
    var o1 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : false,
    };
    var o2 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( result.length ) },
      first : false,
    };
    var program = a.program({ entry : severalCallbacks, locals : { o1, o2, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ [], 1 ]' ), 1 );
      return null;
    });
  });

  /* */

  con.then( () =>
  {
    test.case = 'callback1.first - true, callback2.first - false';
    var o1 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : true,
    };
    var o2 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( result.length ) },
      first : false,
    };
    var program = a.program({ entry : severalCallbacks, locals : { o1, o2, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ [], 1 ]' ), 1 );
      return null;
    });
  });

  /* */

  con.then( () =>
  {
    test.case = 'callback1.first - false, callback2.first - true';
    var o1 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : false,
    };
    var o2 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( result.length ) },
      first : true,
    };
    var program = a.program({ entry : severalCallbacks, locals : { o1, o2, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ 0, [] ]' ), 1 );
      return null;
    });
  });

  /* */

  con.then( () =>
  {
    test.case = 'callback1.first - true, callback2.first - true';
    var o1 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) },
      first : true,
    };
    var o2 =
    {
      callbackMap : { 'terminationBegin' : ( ... args ) => result.push( result.length ) },
      first : true,
    };
    var program = a.program({ entry : severalCallbacks, locals : { o1, o2, result : [] } });
    return program.start()
    .then( ( op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, '[ 0, [] ]' ), 1 );
      return null;
    });
  });

  con.then( () =>
  {
    test.close( 'options map with option first' );
    return null;
  });

  /* */

  if( Config.debug )
  con.then( () =>
  {
    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.procedure.on() );

    test.case = 'wrong type of callback';
    test.shouldThrowErrorSync( () => _.procedure.on( 'event1', {} ) );

    test.case = 'wrong type of event name';
    test.shouldThrowErrorSync( () => _.procedure.on( [], () => 'str' ) );

    test.case = 'wrong type of options map o';
    test.shouldThrowErrorSync( () => _.procedure.on( 'wrong' ) );

    test.case = 'extra options in options map o';
    test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : {}, wrong : {} }) );

    test.case = 'not known event in callbackMap';
    test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : { unknown : () => 'unknown' } }) );
    return null;
  });

  /* - */

  return con;

  /* */

  function withoutCallbacks()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure._eventTerminationBeginHandle();
    _.procedure._eventTerminationEndHandle();
    console.log( result );
  }

  /* */

  function callbackForTerminationBegin()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.procedure.on( o );
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function callbackForTerminationBeginDouble()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.procedure.on( o );
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function callbacksForEvents()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.procedure.on( 'terminationBegin', ( ... args ) => result.push( args ) );
    _.procedure.on( 'terminationEnd', ( e ) => result.push( result.length ) );
    _.procedure.terminationBegin();
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function severalCallbacks()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.procedure.on( o1 );
    _.procedure.on( o2 );
    _.procedure.terminationBegin();
    console.log( result );
  }
}

onWithOptionsMap.timeOut = 30000;

// //
//
// function onWithOptionsMap( test )
// {
//   var self = this;
//
//   /* - */
//
//   test.open( 'option first - 0' );
//
//   test.case = 'no callback for events';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [] );
//
//   /* */
//
//   test.case = 'single callback for single event, single event is given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//
//   /* */
//
//   test.case = 'single callback for single event, a few events are given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent }} );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0, 1 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//
//   /* */
//
//   test.case = 'single callback for each events in event handler, a few events are given';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent, 'terminationEnd' : onEvent2 } });
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ 0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0, 1, -2, -3 ] );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
//   got.terminationBegin.off();
//   got.terminationEnd.off();
//
//   test.close( 'option first - 0' );
//
//   /* - */
//
//   test.open( 'option first - 1' );
//
//   test.case = 'callback added before other callback';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
//   var got2 = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent2 }, 'first' : 1 });
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ -0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ -0, 1, -2, 3 ] );
//   got.terminationBegin.off();
//   got2.terminationBegin.off();
//
//   /* */
//
//   test.case = 'callback added after other callback';
//
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var onEvent2 = () => result.push( -1 * result.length );
//   var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent2 }, 'first' : 1 });
//   var got2 = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ -0, 1 ] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [ -0, 1, -2, 3 ] );
//
//   test.close( 'option first - 1' );
//
//   /* - */
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'without arguments';
//   test.shouldThrowErrorSync( () => _.procedure.on() );
//
//   test.case = 'wrong type of callback';
//   test.shouldThrowErrorSync( () => _.procedure.on( 'terminationBegin', {} ) );
//
//   test.case = 'wrong type of event name';
//   test.shouldThrowErrorSync( () => _.procedure.on( [], () => 'str' ) );
//
//   test.case = 'wrong type of options map o';
//   test.shouldThrowErrorSync( () => _.procedure.on( 'wrong' ) );
//
//   test.case = 'extra options in options map o';
//   test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : {}, wrong : {} }) );
//
//   test.case = 'not known event in callbackMap';
//   test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : { unknown : () => 'unknown' } }) );
// }

//

function onWithChain( test )
{
  const self = this;
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'chain in args';
    return null;
  });
  var program = a.program( chainInArgs );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'chain in map';
    return null;
  });
  var program = a.program( chainInMap );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ [] ]' ), 1 );
    return null;
  });

  /* - */

  return a.ready

  /* */

  function chainInArgs()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure.on( _.event.Chain( 'terminationBegin', 'terminationEnd' ), ( ... args ) => result.push( args ) );
    _.procedure.terminationBegin();
    _.procedure.terminationBegin();
    console.log( result );
  }

  /* */

  function chainInMap()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    _.procedure.on({ callbackMap : { 'terminationBegin' : [ _.event.Name( 'terminationEnd' ), ( ... args ) => result.push( args ) ] } });
    _.procedure.terminationBegin();
    _.procedure.terminationBegin();
    console.log( result );
  }
}

// //
//
// function onWithChain( test )
// {
//   var self = this;
//
//   /* */
//
//   test.case = 'call with arguments';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var got = _.procedure.on( _.event.Chain( 'terminationBegin', 'terminationEnd' ), onEvent );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0 ] );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
//   _.event.off( _.procedure._edispatcher, { callbackMap : { terminationEnd : null } } );
//
//   /* */
//
//   test.case = 'call with options map';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var got = _.procedure.on({ callbackMap : { terminationBegin : [ _.event.Name( 'terminationEnd' ), onEvent ] } });
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationBegin' );
//   test.identical( result, [] );
//   _.event.eventGive( _.procedure._edispatcher, 'terminationEnd' );
//   test.identical( result, [ 0 ] );
//   test.false( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
//   _.event.off( _.procedure._edispatcher, { callbackMap : { terminationEnd : null } } );
// }

//

function onCheckDescriptor( test )
{
  const self = this;
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'from arguments';
    return null;
  });
  var program = a.program( callbackInArgs );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ \'terminationBegin\' ]' ), 1 );
    test.identical( _.strCount( op.output, '[ \'off\', \'enabled\', \'first\', \'callbackMap\' ]' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.enabled : true' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.first : false' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.callbackMap : terminationBegin' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'from map';
    return null;
  });
  var program = a.program( callbackInMap );
  program.start();
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '[ \'terminationBegin\' ]' ), 1 );
    test.identical( _.strCount( op.output, '[ \'off\', \'enabled\', \'first\', \'callbackMap\' ]' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.enabled : true' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.first : true' ), 1 );
    test.identical( _.strCount( op.output, 'descriptor.callbackMap : terminationBegin' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function callbackInArgs()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    const descriptor = _.procedure.on( 'terminationBegin', ( ... args ) => result.push( args ) );
    console.log( _.props.keys( descriptor ) );
    console.log( _.props.keys( descriptor.terminationBegin ) );
    console.log( `descriptor.enabled : ${ descriptor.terminationBegin.enabled }` );
    console.log( `descriptor.first : ${ descriptor.terminationBegin.first }` );
    console.log( `descriptor.callbackMap : ${ _.props.keys( descriptor.terminationBegin.callbackMap ) }` );
  }

  /* */

  function callbackInMap()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    const result = [];
    const descriptor = _.procedure.on({ callbackMap : { 'terminationBegin' : ( ... args ) => result.push( args ) }, first : true });
    console.log( _.props.keys( descriptor ) );
    console.log( _.props.keys( descriptor.terminationBegin ) );
    console.log( `descriptor.enabled : ${ descriptor.terminationBegin.enabled }` );
    console.log( `descriptor.first : ${ descriptor.terminationBegin.first }` );
    console.log( `descriptor.callbackMap : ${ _.props.keys( descriptor.terminationBegin.callbackMap ) }` );
  }
}

// //
//
// function onCheckDescriptor( test )
// {
//   var self = this;
//
//   /* */
//
//   test.case = 'call with arguments';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var descriptor = _.procedure.on( 'terminationBegin', onEvent );
//   test.identical( _.props.keys( descriptor ), [ 'terminationBegin' ] );
//   test.identical( _.props.keys( descriptor.terminationBegin ), [ 'off', 'enabled', 'first', 'callbackMap' ] );
//   test.identical( descriptor.terminationBegin.enabled, true );
//   test.identical( descriptor.terminationBegin.first, 0 );
//   test.equivalent( descriptor.terminationBegin.callbackMap, { terminationBegin : onEvent } );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   descriptor.terminationBegin.off();
//
//   /* */
//
//   test.case = 'call with arguments';
//   var result = [];
//   var onEvent = () => result.push( result.length );
//   var descriptor = _.procedure.on({ callbackMap : { 'terminationBegin' : onEvent } });
//   test.identical( _.props.keys( descriptor ), [ 'terminationBegin' ] );
//   test.identical( _.props.keys( descriptor.terminationBegin ), [ 'off', 'enabled', 'first', 'callbackMap' ] );
//   test.identical( descriptor.terminationBegin.enabled, true );
//   test.identical( descriptor.terminationBegin.first, 0 );
//   test.equivalent( descriptor.terminationBegin.callbackMap, { terminationBegin : onEvent } );
//   test.true( _.event.eventHasHandler( _.procedure._edispatcher, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
//   descriptor.terminationBegin.off();
// }

// --
// declare
// --

const Proto =
{

  name : 'Tools.procedure.Event',
  silencing : 1,
  enabled : 1,

  tests :
  {

    onWithArguments,
    onWithOptionsMap,
    onWithChain,
    onCheckDescriptor,

  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

