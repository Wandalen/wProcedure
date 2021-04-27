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
  var self = this;

  /* */

  test.case = 'no callback for events';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [] );

  /* */

  test.case = 'single callback for single event, single event is given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on( 'terminationBegin', onEvent );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();

  /* */

  test.case = 'single callback for single event, a few events are given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on( 'terminationBegin', onEvent );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0, 1 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();

  /* */

  test.case = 'single callback for each events in event handler, a few events are given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on( 'terminationBegin', onEvent );
  var got2 = _.procedure.on( 'terminationEnd', onEvent2 );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0, 1, -2, -3 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();
  got2.terminationEnd.off();
}

//

function onWithOptionsMap( test )
{
  var self = this;

  /* - */

  test.open( 'option first - 0' );

  test.case = 'no callback for events';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [] );

  /* */

  test.case = 'single callback for single event, single event is given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();

  /* */

  test.case = 'single callback for single event, a few events are given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent }} );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0, 1 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();

  /* */

  test.case = 'single callback for each events in event handler, a few events are given';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent, 'terminationEnd' : onEvent2 } });
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ 0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0, 1, -2, -3 ] );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent2 } ) );
  got.terminationBegin.off();
  got.terminationEnd.off();

  test.close( 'option first - 0' );

  /* - */

  test.open( 'option first - 1' );

  test.case = 'callback added before other callback';
  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
  var got2 = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent2 }, 'first' : 1 });
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ -0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ -0, 1, -2, 3 ] );
  got.terminationBegin.off();
  got2.terminationBegin.off();

  /* */

  test.case = 'callback added after other callback';

  var result = [];
  var onEvent = () => result.push( result.length );
  var onEvent2 = () => result.push( -1 * result.length );
  var got = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent2 }, 'first' : 1 });
  var got2 = _.procedure.on({ 'callbackMap' : { 'terminationBegin' : onEvent } });
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ -0, 1 ] );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [ -0, 1, -2, 3 ] );

  test.close( 'option first - 1' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.procedure.on() );

  test.case = 'wrong type of callback';
  test.shouldThrowErrorSync( () => _.procedure.on( 'terminationBegin', {} ) );

  test.case = 'wrong type of event name';
  test.shouldThrowErrorSync( () => _.procedure.on( [], () => 'str' ) );

  test.case = 'wrong type of options map o';
  test.shouldThrowErrorSync( () => _.procedure.on( 'wrong' ) );

  test.case = 'extra options in options map o';
  test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : {}, wrong : {} }) );

  test.case = 'not known event in callbackMap';
  test.shouldThrowErrorSync( () => _.procedure.on({ callbackMap : { unknown : () => 'unknown' } }) );
}

//

function onWithChain( test )
{
  var self = this;

  /* */

  test.case = 'call with arguments';
  var result = [];
  var onEvent = () => result.push( result.length );
  var got = _.procedure.on( _.event.Chain( 'terminationBegin', 'terminationEnd' ), onEvent );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0 ] );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
  _.event.off( _.procedure._ehandler, { callbackMap : { terminationEnd : null } } );

  /* */

  test.case = 'call with options map';
  var result = [];
  var onEvent = () => result.push( result.length );
  var got = _.procedure.on({ callbackMap : { terminationBegin : [ _.event.Name( 'terminationEnd' ), onEvent ] } });
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
  _.event.eventGive( _.procedure._ehandler, 'terminationBegin' );
  test.identical( result, [] );
  _.event.eventGive( _.procedure._ehandler, 'terminationEnd' );
  test.identical( result, [ 0 ] );
  test.false( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationEnd', eventHandler : onEvent } ) );
  _.event.off( _.procedure._ehandler, { callbackMap : { terminationEnd : null } } );
}

//

function onCheckDescriptor( test )
{
  var self = this;

  /* */

  test.case = 'call with arguments';
  var result = [];
  var onEvent = () => result.push( result.length );
  var descriptor = _.procedure.on( 'terminationBegin', onEvent );
  test.identical( _.props.keys( descriptor ), [ 'terminationBegin' ] );
  test.identical( _.props.keys( descriptor.terminationBegin ), [ 'off', 'enabled', 'first', 'callbackMap' ] );
  test.identical( descriptor.terminationBegin.enabled, true );
  test.identical( descriptor.terminationBegin.first, 0 );
  test.equivalent( descriptor.terminationBegin.callbackMap, { terminationBegin : onEvent } );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  descriptor.terminationBegin.off();

  /* */

  test.case = 'call with arguments';
  var result = [];
  var onEvent = () => result.push( result.length );
  var descriptor = _.procedure.on({ callbackMap : { 'terminationBegin' : onEvent } });
  test.identical( _.props.keys( descriptor ), [ 'terminationBegin' ] );
  test.identical( _.props.keys( descriptor.terminationBegin ), [ 'off', 'enabled', 'first', 'callbackMap' ] );
  test.identical( descriptor.terminationBegin.enabled, true );
  test.identical( descriptor.terminationBegin.first, 0 );
  test.equivalent( descriptor.terminationBegin.callbackMap, { terminationBegin : onEvent } );
  test.true( _.event.eventHasHandler( _.procedure._ehandler, { eventName : 'terminationBegin', eventHandler : onEvent } ) );
  descriptor.terminationBegin.off();
}

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

