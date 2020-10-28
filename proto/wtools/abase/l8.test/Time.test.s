( function _Time_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

  require( '../l8_procedure/Include.s' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// basic
// --

function _begin( test )
{
  let context = this;

  var onTime = () => 0;
  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._begin( Infinity );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._begin( Infinity, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time._begin( Infinity, onTime );
    timer.time();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time._begin( Infinity, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var timer = _.time._begin( Infinity, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time._begin( Infinity, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._begin( 0 );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._begin( 0, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time._begin( 0, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time._begin( 0, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var timer = _.time._begin( 0, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time._begin( 0, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._begin( 0, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var timer = _.time._begin( context.t1/2 );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var timer = _.time._begin( context.t1 * 20 );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time._begin( context.t1/2, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._begin( context.t1 * 20, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var timer = _.time._begin( context.t1 * 20, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time';
    var timer = _.time._begin( context.t1/2, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time, execute method cancel';
    var timer = _.time._begin( context.t1/2, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout < check time';
    var timer = _.time._begin( context.t1/2, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout > check time';
    var timer = _.time._begin( context.t1 * 20, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._begin( context.t1/2, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'executes method time twice, should throw error';
    var timer = _.time._begin( Infinity, onTime, onCancel );
    timer.time();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });

    /* aaa2 : user should not call methods of timer | Dmytro : now the other concept is used, public methods can be used */

    /* aaa2 : test should ensure that there is no transitions from final states -2 either +2 to any another state. ask | Dmytro : timer not change state from state 2 to -2. State -2 changes to 2 if user call callback timer.time() */
  });

  ready.then( () =>
  {
    test.case = 'executes method cancel twice, should throw error';
    var timer = _.time._begin( Infinity, onTime, onCancel );
    timer.cancel();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time._begin( Infinity, onTime, onCancel );
    timer.time();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time._begin( Infinity, onTime, onCancel );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function _beginWithProcedure( test )
{
  test.case = 'Procedure as callback, should throw error';
  var nProceduresBegin = _.Procedure.Counter;
  var timer = _.time._begin( 10, () => 1, () => -1 );
  var nProceduresAfter = _.Procedure.Counter;
  test.identical( nProceduresBegin, nProceduresAfter );
}

//

function _beginTimerInsideOfCallback( test )
{
  let context = this;

  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.then( () =>
  {
    test.case = 'single unlinked timer';
    var result = [];
    var onTime = () =>
    {
      result.push( 1 );
      _.time._begin( context.t1, () => result.push( 2 ) );
      return 1;
    };
    var timer = _.time._begin( context.t1, onTime );

    return _.time.out( context.t1 * 100, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 1 );
      test.identical( result, [ 1, 2 ] );

      return null;
    });
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'a interval timer from simple timer';
    var result = [];
    var timer = _.time._begin( context.t1, onTime );
    function onTime()
    {
      if( result.length < 3 )
      {
        result.push( 1 );
        timer = _.time._begin( context.t1, onTime );
        return 1;
      }
      result.push( -1 );
      return -1;
    }

    return _.time.out( context.t1 * 100, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, -1 );
      test.identical( result, [ 1, 1, 1, -1 ] );

      return null;
    });
  });

  return ready;
}

//

function _finally( test )
{
  let context = this;

  var onTime = () => 0;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._finally( Infinity, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._finally( Infinity, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time._finally( Infinity, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var timer = _.time._finally( Infinity, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._finally( 0, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._finally( 0, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time._finally( 0, onTime );
    timer.time();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var timer = _.time._finally( 0, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._finally( 0, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var timer = _.time._finally( context.t1/2, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var timer = _.time._finally( context.t1 * 10, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, undefined );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time._finally( context.t1/2, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._finally( context.t1 * 10, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method cancel';
    var timer = _.time._finally( context.t1 * 10, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._finally( context.t1 * 10, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var timer = _.time._finally( context.t1 * 10, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._finally( 0, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'executes method time twice, should throw error';
    var timer = _.time._finally( Infinity, onTime );
    timer.time();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method cancel twice, should throw error';
    var timer = _.time._finally( Infinity, onTime );
    timer.cancel();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time._finally( Infinity, onTime );
    timer.time();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time._finally( Infinity, onTime );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function _finallyWithProcedure( test )
{
  test.case = 'Procedure as callback, should throw error';
  var nProceduresBegin = _.Procedure.Counter;
  var timer = _.time._finally( 10, () => 1 );
  var nProceduresAfter = _.Procedure.Counter;
  test.identical( nProceduresBegin, nProceduresAfter );
}

//

function _periodic( test )
{
  let context = this;

  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var timer = _.time._periodic( 0, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, -2 );
      test.identical( timer.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var timer = _.time._periodic( 0, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, -2 );
      test.identical( timer.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var timer = _.time._periodic( 0, onTime, onCancel );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });
  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var timer = _.time._periodic( context.t1/2, onTime );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.is( timer.state === -2 );
      test.identical( timer.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var timer = _.time._periodic( context.t1/2, onTime );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, undefined );
      test.identical( timer.state, -2 );
      test.identical( timer.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var timer = _.time._periodic( context.t1/2, onTime, onCancel );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.is( timer.state === -2 );
      test.identical( timer.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  /* - */

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'executes method cancel twice, should throw error';
    var timer = _.time._periodic( 1000, () => 1, () => -1 );
    timer.cancel();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time inside of method cancel, should throw error';
    var timer = _.time._periodic( 1000, () => 1, onCancel );
    function onCancel()
    {
      timer.time();
      return -1;
    };

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

_periodic.timeOut = 10000;

//

function _periodicWithProcedure( test )
{
  test.case = 'Procedure as callback, should throw error';
  var nProceduresBegin = _.Procedure.Counter;
  var timer = _.time._periodic( 10, () => 1, () => -1 );
  var nProceduresAfter = _.Procedure.Counter;
  test.identical( nProceduresBegin, nProceduresAfter );
  _.time.cancel( timer );
  var nProceduresAfter = _.Procedure.Counter;
  test.identical( nProceduresBegin, nProceduresAfter );
}

//

function _cancel( test )
{
  let context = this;

  test.open( 'timer - _begin' );

  test.case = 'delay - Infinity';
  var timer = _.time._begin( Infinity );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onTime';
  var onTime = () => 0;
  var timer = _.time._begin( Infinity, onTime );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onCancel';
  var onCancel = () => -1;
  var timer = _.time._begin( Infinity, undefined, onCancel );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.case = 'delay - Infinity, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._begin( Infinity, onTime, onCancel );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _begin' );

  /* - */

  test.open( 'timer - _finally' );

  test.case = 'delay - Infinity';
  var timer = _.time._finally( Infinity, undefined );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onTime';
  var onTime = () => 0;
  var timer = _.time._finally( Infinity, onTime );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onTime );
  test.identical( got.state, -2 );
  test.identical( got.result, 0 );

  test.close( 'timer - _finally' );

  /* - */

  test.open( 'timer - _periodic' );

  test.case = 'delay - 0, onTime';
  var onTime = () => 0;
  var timer = _.time._periodic( context.t2, onTime ) ;
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - 0, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._periodic( context.t2, onTime, onCancel ) ;
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _periodic' );
}

//

function _cancelWithProcedure( test )
{
  test.case = 'Procedure as callback, should throw error';
  var timer = _.time._begin( 10, () => 1, () => -1 );
  var nProceduresBegin = _.Procedure.Counter;
  var got = _.time._cancel( timer );
  var nProceduresAfter = _.Procedure.Counter;
  test.identical( nProceduresBegin, nProceduresAfter );
}

//

function begin( test )
{
  let context = this;

  var onTime = () => 0;
  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time.begin( Infinity, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time.begin( Infinity, onTime );
    timer.time();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time.begin( Infinity, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var timer = _.time.begin( Infinity, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time.begin( Infinity, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time.begin( 0, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time.begin( 0, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time.begin( 0, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var timer = _.time.begin( 0, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time.begin( 0, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time.begin( 0, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time.begin( context.t1/2, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time.begin( context.t1 * 10, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var timer = _.time.begin( context.t1 * 10, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time';
    var timer = _.time.begin( context.t1/2, undefined, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time, execute method cancel';
    var timer = _.time.begin( context.t1/2, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout < check time';
    var timer = _.time.begin( context.t1/2, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout > check time';
    var timer = _.time.begin( context.t1 * 10, onTime, onCancel );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time.begin( context.t1/2, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.begin() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.begin( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.begin( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onCancel';
    return _.time.out( 0, () => _.time.begin( 0, () => 1, [] ) )
    .finally( ( err, arg ) =>
    {
      debugger;
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time twice, should throw error';
    var timer = _.time.begin( Infinity, onTime, onCancel );
    timer.time();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  // ready.then( () =>
  // {
  //   test.case = 'executes method cancel twice, should throw error';
  //   var timer = _.time.begin( Infinity, onTime, onCancel );
  //   timer.cancel();
  //   debugger;
  //   /* xxx qqq for Dmytro : bad test. ask */
  //   return _.time.out( context.t1, () =>
  //   {
  //     debugger;
  //     return timer.cancel()
  //   })
  //   .finally( ( err, arg ) =>
  //   {
  //     debugger;
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });
  //
  // ready.then( () =>
  // {
  //   test.case = 'executes method time and then method cancel, should throw error';
  //   var timer = _.time.begin( Infinity, onTime, onCancel );
  //   timer.time();
  //
  //   return _.time.out( context.t1, () =>
  //   {
  //     timer.cancel()
  //   })
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time.begin( Infinity, onTime, onCancel );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function beginWithProcedure( test )
{
  let context = this;

  var onTime = () => 0;
  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( Infinity, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( Infinity, procedure, onTime );
    timer.time();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( Infinity, procedure, undefined, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( Infinity, procedure, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( Infinity, procedure, onTime, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, onTime );
    timer.time()
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, undefined, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, onTime, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( 0, procedure, onTime );
    return _.time.out( context.t1 * 10, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1/2, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1 * 10, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1 * 10, procedure, onTime );
    timer.time()
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1/2, procedure, undefined, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1/2, procedure, undefined, onCancel );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout < check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1/2, procedure, onTime, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout > check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1 * 10, procedure, onTime, onCancel );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.begin( context.t1/2, procedure, onTime );
    return _.time.out( context.t1 * 10, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.begin() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.begin( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.begin( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onCancel';
    return _.time.out( 0, () => _.time.begin( 0, () => 1, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time twice, should throw error';
    var timer = _.time.begin( Infinity, onTime, onCancel );
    timer.time();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  // qqq for Dmytro
  // ready.then( () =>
  // {
  //   test.case = 'executes method cancel twice, should throw error';
  //   var timer = _.time.begin( Infinity, onTime, onCancel );
  //   timer.cancel();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });
  //
  // ready.then( () =>
  // {
  //   test.case = 'executes method time and then method cancel, should throw error';
  //   var timer = _.time.begin( Infinity, onTime, onCancel );
  //   timer.time();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time.begin( Infinity, onTime, onCancel );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function beginTimerInsideOfCallback( test )
{
  let context = this;

  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.then( () =>
  {
    test.case = 'single unlinked timer';
    var result = [];
    var onTime = () =>
    {
      result.push( 1 );
      _.time.begin( context.t1, () => result.push( 2 ) );
      return 1;
    };
    var timer = _.time.begin( context.t1, onTime );

    return _.time.out( context.t1 * 100, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 1 );
      test.identical( result, [ 1, 2 ] );

      return null;
    });
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'a interval timer from simple timer';
    var result = [];
    var timer = _.time.begin( context.t1, onTime );
    function onTime()
    {
      if( result.length < 3 )
      {
        result.push( 1 );
        timer = _.time.begin( context.t1, onTime );
        return 1;
      }
      result.push( -1 );
      return -1;
    }

    return _.time.out( context.t1 * 100, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, -1 );
      test.identical( result, [ 1, 1, 1, -1 ] );

      return null;
    });
  });

  return ready;
}

//

function finally_( test )
{
  let context = this;

  var onTime = () => 0;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time.finally( Infinity, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time.finally( Infinity, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time.finally( Infinity, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var timer = _.time.finally( Infinity, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time.finally( 0, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time.finally( 0, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var timer = _.time.finally( 0, onTime );
    timer.time();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var timer = _.time.finally( 0, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time.finally( 0, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var timer = _.time.finally( context.t1/2, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var timer = _.time.finally( context.t1 * 10, undefined );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, null );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time.finally( context.t1/2, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time.finally( context.t1 * 10, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method cancel';
    var timer = _.time.finally( context.t1 * 10, onTime );
    timer.cancel();
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, -2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time.finally( context.t1 * 10, onTime );
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 0 );
      test.identical( timer.result, undefined );
      _.time.cancel( timer );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var timer = _.time.finally( context.t1 * 10, onTime );
    timer.time()
    return _.time.out( context.t1, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time.finally( 0, onTime );
    return _.time.out( context.t1 * 10, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onTime );
      test.identical( timer.state, 2 );
      test.identical( timer.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.finally() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.finally( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.finally( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  // qqq for Dmytro
  // ready.then( () =>
  // {
  //   test.case = 'executes method cancel twice, should throw error';
  //   var timer = _.time.finally( Infinity, onTime );
  //   timer.cancel();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });
  //
  // ready.then( () =>
  // {
  //   test.case = 'executes method time and then method cancel, should throw error';
  //   var timer = _.time.finally( Infinity, onTime );
  //   timer.time();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });
  //
  // ready.then( () =>
  // {
  //   test.case = 'executes method time and then method cancel, should throw error';
  //   var timer = _.time.finally( Infinity, onTime );
  //   timer.time();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time.finally( Infinity, onTime );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function finallyWithProcedure( test )
{
  let context = this;

  var onTime = () => 0;
  var ready = new _.Consequence().take( null );

  /* - */

  debugger;
  ready.finally( () =>
  {
    test.open( 'delay - Infinity' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( Infinity, procedure, undefined );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, null );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( Infinity, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( Infinity, procedure, onTime );
    timer.time()
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( Infinity, procedure, onTime );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  ready.finally( () =>
  {
    test.close( 'delay - Infinity' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure, undefined );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure, onTime );
    timer.time();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure,  onTime );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure, onTime );
    return _.time.out( context.t1 * 10, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1/2, procedure, undefined );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, null );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1 * 10, procedure, undefined );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, null );
      test.identical( got.onCancel, null );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1/2, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1 * 10, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method cancel';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1 * 10, procedure, onTime );
    timer.cancel();
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1 * 10, procedure, onTime );
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( !procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      _.time.cancel( timer );
      test.is( procedure.isFinited() );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute method time';
    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( context.t1 * 10, procedure, onTime );
    timer.time()
    return _.time.out( context.t1, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.finally( 0, procedure, onTime );
    return _.time.out( context.t1 * 10, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );

      return null;
    });
  });

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.finally() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.finally( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.finally( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time twice, should throw error';
    var timer = _.time.finally( Infinity, onTime );
    timer.time();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  // qqq for Dmytro
  // ready.then( () =>
  // {
  //   test.case = 'executes method cancel twice, should throw error';
  //   var timer = _.time.finally( Infinity, onTime );
  //   timer.cancel();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });
  //
  // ready.then( () =>
  // {
  //   test.case = 'executes method time and then method cancel, should throw error';
  //   var timer = _.time.finally( Infinity, onTime );
  //   timer.time();
  //
  //   return _.time.out( context.t1, () => timer.cancel() )
  //   .finally( ( err, arg ) =>
  //   {
  //     if( arg )
  //     {
  //       test.is( false );
  //     }
  //     else
  //     {
  //       _.errAttend( err );
  //       test.is( true );
  //     }
  //     return null;
  //   });
  // });

  ready.then( () =>
  {
    test.case = 'executes method time and then method cancel, should throw error';
    var timer = _.time.finally( Infinity, onTime );
    timer.cancel();

    return _.time.out( context.t1, () => timer.time() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function periodic( test )
{
  let context = this;

  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var timer = _.time.periodic( 0, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, -2 );
      test.identical( timer.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var timer = _.time.periodic( 0, onTime );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, -2 );
      test.identical( timer.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var timer = _.time.periodic( 0, onTime, onCancel );
    return _.time.out( context.t1 * 20, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.identical( timer.state, -2 );
      test.identical( timer.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });
  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var timer = _.time.periodic( context.t1/2, onTime );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.is( timer.state === -2 );
      test.identical( timer.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var timer = _.time.periodic( context.t1/2, onTime );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, null );
      test.identical( timer.state, -2 );
      test.identical( timer.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var timer = _.time.periodic( context.t1/2, onTime, onCancel );
    return _.time.out( context.t1 * 40, () =>
    {
      test.identical( timer.onTime, onTime );
      test.identical( timer.onCancel, onCancel );
      test.is( timer.state === -2 );
      test.identical( timer.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  /* - */

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.periodic() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.periodic( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.periodic( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onCancel';
    return _.time.out( 0, () => _.time.periodic( 0, () => 1, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method cancel twice, should throw error';
    var timer = _.time.periodic( context.t1 * 100, () => 1, () => -1 );
    timer.cancel();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time inside of method cancel, should throw error';
    var timer = _.time.periodic( context.t1 * 100, () => 1, onCancel );
    function onCancel()
    {
      timer.time();
      return -1;
    };

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function periodicWithProcedure( test )
{
  let context = this;

  var onCancel = () => -1;
  var ready = new _.Consequence().take( null );

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( 0, procedure, onTime );
    return _.time.out( context.t1 * 20, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, -2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( 0, procedure, onTime );
    return _.time.out( context.t1 * 20, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, -2 );
      test.identical( got.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return undefined;
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( 0, procedure, onTime, onCancel );
    return _.time.out( context.t1 * 20, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  ready.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( context.t1/2, procedure, onTime );
    return _.time.out( context.t1 * 40, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.is( got.state === -2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
      return _.dont;
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( context.t1/2, procedure, onTime );
    return _.time.out( context.t1 * 40, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, null );
      test.identical( got.state, -2 );
      test.identical( got.result, _.dont );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = () =>
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
        return true;
      }
    };

    var procedure = _.Procedure( 5 );
    var timer = _.time.periodic( context.t1/2, procedure, onTime, onCancel );
    return _.time.out( context.t1 * 40, () => timer )
    .then( ( got ) =>
    {
      test.identical( got.procedure, procedure );
      test.is( procedure.isFinited() );
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.is( got.state === -2 );
      test.identical( got.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      return null;
    });
  })

  /* - */

  ready.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* - */

  ready.then( () =>
  {
    test.case = 'without arguments';
    return _.time.out( 0, () => _.time.periodic() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'not enough arguments';
    return _.time.out( 0, () => _.time.periodic( 0 ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onTime';
    return _.time.out( 0, () => _.time.periodic( 0, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'wrong type of onCancel';
    return _.time.out( 0, () => _.time.periodic( 0, () => 1, [] ) )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method cancel twice, should throw error';
    var timer = _.time.periodic( 1000, () => 1, () => -1 );
    timer.cancel();

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'executes method time inside of method cancel, should throw error';
    var timer = _.time.periodic( 1000, () => 1, onCancel );
    function onCancel()
    {
      timer.time();
      return -1;
    };

    return _.time.out( context.t1, () => timer.cancel() )
    .finally( ( err, arg ) =>
    {
      if( arg )
      {
        test.is( false );
      }
      else
      {
        _.errAttend( err );
        test.is( true );
      }
      return null;
    });
  });

  /* */

  return ready;
}

//

function cancel( test )
{
  let context = this;

  test.open( 'timer - _begin' );

  test.case = 'delay - Infinity';
  var timer = _.time._begin( Infinity );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onTime';
  var onTime = () => 0;
  var timer = _.time._begin( Infinity, onTime );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onCancel';
  var onCancel = () => -1;
  var timer = _.time._begin( Infinity, undefined, onCancel );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.case = 'delay - Infinity, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._begin( Infinity, onTime, onCancel );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _begin' );

  /* - */

  test.open( 'timer - _finally' );

  test.case = 'delay - Infinity';
  var timer = _.time._finally( Infinity, undefined );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - Infinity, onTime';
  var onTime = () => 0;
  var timer = _.time._finally( Infinity, onTime );
  var got = _.time.cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onTime );
  test.identical( got.state, -2 );
  test.identical( got.result, 0 );

  test.close( 'timer - _finally' );

  /* - */

  test.open( 'timer - _periodic' );

  test.case = 'delay - 0, onTime';
  var onTime = () => 0;
  var timer = _.time._periodic( context.t2, onTime ) ;
  var got = _.time.cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - 0, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._periodic( context.t2, onTime, onCancel ) ;
  var got = _.time.cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _periodic' );
}

// --
// declare
// --

let Self =
{

  name : 'Tools.procedure.Time',
  silencing : 1,
  enabled : 1,

  context : /* aaa xxx : minimize number of time parameters. too many of such */ /* Dmytro : minimized, the step is power of 10 */
  {
    timeAccuracy : 1,
    t1 : 10,
    t2 : 1000,
  },

  tests :
  {

    // basic

    _begin,
    _beginWithProcedure,
    _beginTimerInsideOfCallback,
    _finally,
    _finallyWithProcedure,
    _periodic,
    _periodicWithProcedure,
    _cancel,
    _cancelWithProcedure,
    begin,
    beginWithProcedure,
    beginTimerInsideOfCallback,
    finally : finally_,
    finallyWithProcedure,
    periodic,
    periodicWithProcedure,
    cancel,

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

