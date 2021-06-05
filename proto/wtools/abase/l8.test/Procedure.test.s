( function _Procedure_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );

  require( '../l8_procedure/Include.s' );

}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const fileProvider = __.fileProvider;
const path = fileProvider.path;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = path.tempOpen( path.join( __dirname, '../..' ), 'procedure' );
  self.assetsOriginalPath = path.join( __dirname, '_asset' );

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, '/procedure-' ) )
  path.tempClose( self.suiteTempPath );
}

// --
// test
// --

function procedureIs( test )
{
  test.case = 'instance of Procedure';
  var src = new _.Procedure();
  src.begin();
  var got = _.procedureIs( src );
  test.identical( got, true );
  src.end();
}

//

function trivial( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 2 ); /* zzz : make single procedure */
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    let t = 250;
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );
    _.time.out( t*2 );
    _.procedure.terminationPeriod = t;
    _.procedure.terminationBegin();
  }

}

trivial.timeOut = 30000;
trivial.description =
`
- application does not have to wait for procedures
`

//

function procedureSourcePath( test )
{
  let context = this;
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /sourcePath::callback.*program:11/ ), 1 ); /* `then` is a regular routine ( alias for `thenKeep` ) */
    test.identical( _.strCount( op.output, /sourcePath::timeout.*program:19/ ), 1 ); /* `_.time.out` created with `_.routine.uniteCloning` */
    test.identical( _.strCount( op.output, /sourcePath::program.*program:/ ), 1 ); /* `console.log` is a regular routine */
    test.identical( _.strCount( op.output, 'sourcePath::' ), 3 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
    _.include( 'wFiles' );
    _.include( 'wConsequence' );

    var con = _.Consequence();

    /*  */

    con.then( function callback( arg )
    {
      console.log( 'sourcePath::callback ' + _.Procedure.ActiveProcedure._sourcePath );
      return 'callback';
    })

    console.log( 'sourcePath::program ' + _.Procedure.ActiveProcedure._sourcePath );

    _.time.out( 100, function timeOut1()
    {
      console.log( 'sourcePath::timeout ' + _.Procedure.ActiveProcedure._sourcePath );
      con.take( 'timeout1' );
    });

  }

}

procedureSourcePath.timeOut = 30000;

//

function procedureStack( test )
{
  let context = this;
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;
  let programPath2 = a.program( program2 ).programPath;
  let programPath3 = a.program( program3 ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.case = 'stack from `then` ( regular routine )';

    test.identical( op.exitCode, 0 );
    test.identical( _.strBegins( op.output, /stack::callback.*program:11/ ), true );
    test.identical( _.strCount( op.output, 'stack::' ), 1 );
    return null;
  });

  /* */

  a.appStartNonThrowing({ execPath : programPath2 })
  .then( ( op ) =>
  {
    test.case = 'stack from program itself';

    test.identical( op.exitCode, 0 );
    test.identical( _.strBegins( op.output, /stack::program.*program2/ ), true );
    test.identical( _.strCount( op.output, 'stack::' ), 1 );
    return null;
  });

  /* */

  a.appStartNonThrowing({ execPath : programPath3 })
  .then( ( op ) =>
  {
    test.case = 'stack from `time.out` routine ( created using `_.routine.uniteCloning` )';

    test.identical( op.exitCode, 0 );
    test.identical( _.strBegins( op.output, /stack::timeout.*program3:9/ ), true );
    test.identical( _.strCount( op.output, 'stack::' ), 1 );
    return null;
  });

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
    _.include( 'wFiles' );
    _.include( 'wConsequence' );

    var con = _.Consequence();

    /*  */

    con.then( function callback( arg )
    {
      console.log( 'stack::callback ' + _.Procedure.ActiveProcedure._stack );
      return 'callback';
    })

    con.take( 'callback' );
  }

  //

  function program2()
  {
    let _ = require( toolsPath );
    _.include( 'wFiles' );
    _.include( 'wConsequence' );

    console.log( 'stack::program ' + _.Procedure.ActiveProcedure._stack );

  }

  //

  function program3()
  {
    let _ = require( toolsPath );
    _.include( 'wFiles' );
    _.include( 'wConsequence' );

    /*  */

    _.time.out( 100, function timeOut1()
    {
      console.log( 'stack::timeout ' + _.Procedure.ActiveProcedure._stack );
    });

  }

}

procedureStack.timeOut = 30000;

//

function activeProcedureSourcePath( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /program:/ ), 5 );
    test.identical( _.strCount( op.output, /sourcePath::timeout.*program:22/ ), 1 );
    test.identical( _.strCount( op.output, /sourcePath::callback1.*program:8/ ), 1 );
    test.identical( _.strCount( op.output, /sourcePath::callback2.*program:13/ ), 1 );
    test.identical( _.strCount( op.output, 'sourcePath::' ), 4 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wFiles' );
    _.include( 'wConsequence' );

    var con = _.Consequence()
    con.then( function callback1( arg )
    {
      console.log( 'sourcePath::callback1 ' + _.Procedure.ActiveProcedure._sourcePath );
      return 'callback1';
    })
    con.then( function callback2( arg )
    {
      console.log( 'sourcePath::callback2 ' + _.Procedure.ActiveProcedure._sourcePath );
      /* _.procedure.terminationBegin();*/
      return 'callback2';
    })

    console.log( 'stack::program ' + _.Procedure.ActiveProcedure._stack );
    console.log( 'sourcePath::program ' + _.Procedure.ActiveProcedure._sourcePath );
    _.time.out( 100, function timeOut1()
    {
      console.log( 'sourcePath::timeout ' + _.Procedure.ActiveProcedure._sourcePath );
      con.take( 'timeout1' );
    });

  }

}

activeProcedureSourcePath.timeOut = 30000;
activeProcedureSourcePath.description =
`
proper procedure is active
active procedure has proper source path
`

//

function quasiProcedure( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'procedure::entry' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::quasi' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 2 );
    test.identical( _.strCount( op.output, 'program:5' ), 1 );
    test.identical( _.strCount( op.output, 'program:' ), 2 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.procedure.begin({ _name : 'quasi', _quasi : true, _waitTimer : false });
    logger.log( _.procedure.exportString() );
    console.log( 'program.end' );
  }

}

quasiProcedure.timeOut = 30000;
quasiProcedure.description =
`
quasi procedure is not waited in the end
`

//

function accounting( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /program.end(.|\n|\r)*timeout1(.|\n|\r)*timeout2/mg ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 5 );

    test.identical( _.strCount( op.output, 'procedure::entry' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::time.begin' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::time.out' ), 2 );
    test.identical( _.strCount( op.output, 'procedure::quasi' ), 1 );

    test.identical( _.strCount( op.output, 'program:' ), 5 );
    test.identical( _.strCount( op.output, 'program:6' ), 1 );
    test.identical( _.strCount( op.output, 'program:11' ), 2 );
    test.identical( _.strCount( op.output, 'program:16' ), 1 );

    test.identical( _.strCount( op.output, 'entry r:null o:Null wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'time.begin r:timeOut1 o:Timer wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'time.out r:timeEnd2 o:Competitor wt:Timer' ), 1 );
    test.identical( _.strCount( op.output, 'time.out r:timeEnd1 o:Timer wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'quasi r:null o:Null wt:false' ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wConsequence' );

    _.time.begin( 50, function timeOut1()
    {
      console.log( 'timeout1' );
    });

    _.time.out( 100, function timeOut1()
    {
      console.log( 'timeout2' );
    });

    _.procedure.begin({ _name : 'quasi', _quasi : true, _waitTimer : false });
    logger.log( _.procedure.exportString() );

    console.log( 'program.end' );

    for( let p in _.Procedure.NamesMap )
    {
      let procedure = _.Procedure.NamesMap[ p ];
      let rou = ( procedure._routine ? procedure._routine.name : procedure._routine );
      let obj = _.entity.strType( procedure._object );
      if( _.timerIs( procedure._object ) )
      obj = 'Timer';
      if( _.competitorIs( procedure._object ) )
      obj = 'Competitor';
      let wt = _.timerIs( procedure._waitTimer ) ? 'Timer' : procedure._waitTimer;
      logger.log( `${procedure.name()} r:${rou} o:${obj} wt:${wt}` );
    }

  }

}

accounting.timeOut = 30000;
accounting.description =
`
- time outs produce one procedure
- source path of procedures are correct
`

//

function terminationEventsExplicitTermination( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 1 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, 'timer' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    let t = 1500;

    let timer = _.time.begin( t, () =>
    {
      console.log( 'timer' );
    });

    console.log( 'v1' );

    _.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    _.procedure.terminationPeriod = 1000;
    _.procedure.terminationBegin();

  }

}

terminationEventsExplicitTermination.timeOut = 60000;
terminationEventsExplicitTermination.description =
`
- callback of event terminationBegin get called once
- callback of event terminationEnd get called once
`

//

function terminationEventsImplicitTermination( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, 'timer' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*timer(.|\n|\r)*terminationBegin1(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );
    _.include( 'wProcess' );

    let t = 100;

    let timer = _.time.begin( t, () =>
    {
      console.log( 'timer' );
    });

    console.log( 'v1' );

    _.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

  }

}

terminationEventsImplicitTermination.timeOut = 60000;
terminationEventsImplicitTermination.description =
`
- callback of event terminationBegin get called once
- callback of event terminationEnd get called once
`

//

function terminationEventsTerminationWithConsequence( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 2 );
    test.identical( _.strCount( op.output, 'timer' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    test.identical( _.strCount( op.output, 'got terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*got terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    var con = new _.Consequence();

    var result = null;
    con.thenGive( ( r ) =>
    {
      result = r;
      console.log( 'got', r )
    })

    console.log( 'v1' );

    _.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
      con.take( 'terminationBegin1' )
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    _.time.out( 500, () =>
    {
      console.log( 'timer' );
      if( !result )
      throw _.err( 'terminationBegin not executed automaticaly' );
      return null;
    })

    _.procedure.terminationBegin();
  }

}

terminationEventsTerminationWithConsequence.timeOut = 60000;
terminationEventsTerminationWithConsequence.description =
`
- callback of event terminationBegin get called once
- callback of event terminationEnd get called once
- callback of consequence get resource
`

//

function terminationBeginWithTwoNamespaces( test )
{
  let context = this;
  let a = test.assetFor( false );
  let programPath1 = a.program( program1 ).programPath;
  let programPath2 = a.program( program2 ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath1 })
  .then( ( op ) =>
  {
    test.case = 'termination of procedures from first global namespace';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
    test.identical( _.strCount( op.output, 'Global name : real' ), 1 );
    test.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
    test.identical( _.strCount( op.output, 'Global name : testing' ), 1 );
    test.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
    test.identical( _.strCount( op.output, 'Wrong namespace for _.' ), 0 );
    test.identical( _.strCount( op.output, 'timer1' ), 1 );
    test.identical( _.strCount( op.output, 'timer2' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 1 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    return null;
  });

  a.appStartNonThrowing({ execPath : programPath2 })
  .then( ( op ) =>
  {
    test.case = 'termination of procedures from second global namespace';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
    test.identical( _.strCount( op.output, 'Global name : real' ), 1 );
    test.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
    test.identical( _.strCount( op.output, 'Global name : testing' ), 1 );
    test.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
    test.identical( _.strCount( op.output, 'Wrong namespace for _.' ), 0 );
    test.identical( _.strCount( op.output, 'timer1' ), 1 );
    test.identical( _.strCount( op.output, 'timer2' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 1 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    return null;
  });

  /* */

  return a.ready;

  /* */

  function program1()
  {
    const _ = require( toolsPath );

    let keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `Global name : ${ _realGlobal_._globals_[ keys[ 0 ] ].__GLOBAL_NAME__ }` );

    _.include( 'wTesting' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `Global name : ${ _realGlobal_._globals_[ keys[ 1 ] ].__GLOBAL_NAME__ }` );

    console.log( `Instances are identical : ${ keys[ 0 ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

    if( _ !== _realGlobal_._globals_[ 'real' ].wTools )
    throw _.err( 'Wrong namespace for _.' )

    let t = _realGlobal_._globals_[ 'testing' ].wTools;

    /* */

    let timeOut = 1500;

    let timer = _.time.begin( timeOut, () =>
    {
      console.log( 'timer1' );
    });

    let timerT = t.time.begin( timeOut, () =>
    {
      console.log( 'timer2' );
    });

    console.log( 'v1' );

    /* */

    _.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    /* */

    _.procedure.terminationPeriod = 1000;
    _.procedure.terminationBegin();
  }

  /* */

  function program2()
  {
    const _ = require( toolsPath );

    let keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `Global name : ${ _realGlobal_._globals_[ keys[ 0 ] ].__GLOBAL_NAME__ }` );

    _.include( 'wTesting' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `Global name : ${ _realGlobal_._globals_[ keys[ 1 ] ].__GLOBAL_NAME__ }` );

    console.log( `Instances are identical : ${ keys[ 0 ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

    if( _ !== _realGlobal_._globals_[ 'real' ].wTools )
    throw _.err( 'Wrong namespace for _.' )

    let t = _realGlobal_._globals_[ 'testing' ].wTools;

    /* */

    let timeOut = 1500;

    let timer = _.time.begin( timeOut, () =>
    {
      console.log( 'timer1' );
    });

    let timerT = t.time.begin( timeOut, () =>
    {
      console.log( 'timer2' );
    });

    /* */

    console.log( 'v1' );

    t.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    t.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    /* */

    t.procedure.terminationPeriod = 1000;
    t.procedure.terminationBegin();
  }

}

terminationBeginWithTwoNamespaces.timeOut = 60000;
terminationBeginWithTwoNamespaces.description =
`
- terminationBegin terminate global namespaces in _ProcedureGlobals_
- each global namespace terminate own procedures
`

//

function nativeWatchingSetTimeout( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'error' ), 0 );
    test.identical( _.strCount( op.output, 'Error' ), 0 );

    test.identical( _.strCount( op.output, 'a count : 1' ), 1 );
    test.identical( _.strCount( op.output, /a0 : procedure::entry#1.*program:/ ), 1 );

    test.identical( _.strCount( op.output, 'b count : 2' ), 1 );
    test.identical( _.strCount( op.output, /b0 : procedure::entry#1.*program:/ ), 1 );
    test.identical( _.strCount( op.output, /b1 : procedure::#2.*program:8:5/ ), 1 );

    test.identical( _.strCount( op.output, 'c count : 1' ), 1 );
    test.identical( _.strCount( op.output, /c0 : procedure::entry#1.*program:/ ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.Procedure.NativeWatchingEnable();

    log( 'a' );
    setTimeout( () =>
    {
      log( 'c' );
    }, 1000 );
    log( 'b' );

    function log( msg )
    {
      console.log( `${msg || ''} count : ${_.Procedure.InstancesArray.length}` );
      for( let i = 0 ; i < _.Procedure.InstancesArray.length ; i++ )
      {
        let procedure = _.Procedure.InstancesArray[ i ];
        console.log( `  ${msg}${i} : ${procedure._longName}` );
      }
    }
  }

}

nativeWatchingSetTimeout.description =
`
- setTimeout makes a procedure
- timeout of setTimeout removes the made procedure
`

//

function nativeWatchingСlearTimeout( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'error' ), 0 );
    test.identical( _.strCount( op.output, 'Error' ), 0 );

    test.identical( _.strCount( op.output, 'a count : 1' ), 1 );
    test.identical( _.strCount( op.output, /a0 : procedure::entry#1/ ), 1 );

    test.identical( _.strCount( op.output, 'b count : 3' ), 1 );
    test.identical( _.strCount( op.output, /b0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /b1 : procedure::#2.*program:8:18/ ), 1 );
    test.identical( _.strCount( op.output, /b2 : procedure::#3.*program:12:18/ ), 1 );

    test.identical( _.strCount( op.output, 'd count : 1' ), 1 );
    test.identical( _.strCount( op.output, /d0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /d0 : procedure::entry#1/ ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wProcedure' );
    _.Procedure.NativeWatchingEnable();

    log( 'a' );
    let timer1 = setTimeout( () =>
    {
      log( 'c' );
    }, 1000 );
    let timer2 = setTimeout( () =>
    {
      clearTimeout();
      clearTimeout( timer1 );
      log( 'd' );
    }, 500 );
    log( 'b' );

    function log( msg )
    {
      console.log( `${msg || ''} count : ${_.Procedure.InstancesArray.length}` );
      for( let i = 0 ; i < _.Procedure.InstancesArray.length ; i++ )
      {
        let procedure = _.Procedure.InstancesArray[ i ];
        console.log( `  ${msg}${i} : ${procedure._longName}` );
      }
    }
  }

}

nativeWatchingСlearTimeout.description =
`
- clearTimeout removes procedure made by setTimeout
`

//

function nativeWatchingSetInterval( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'error' ), 0 );
    test.identical( _.strCount( op.output, 'Error' ), 0 );

    test.identical( _.strCount( op.output, 'a count : 1' ), 1 );
    test.identical( _.strCount( op.output, /a0 : procedure::entry#1/ ), 1 );

    test.identical( _.strCount( op.output, 'b count : 3' ), 1 );
    test.identical( _.strCount( op.output, /b0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /b1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /b2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, '0c count : 3' ), 1 );
    test.identical( _.strCount( op.output, /0c0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /0c1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /0c2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, '1c count : 3' ), 1 );
    test.identical( _.strCount( op.output, /1c0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /1c1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /1c2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, 'd count : 1' ), 1 );
    test.identical( _.strCount( op.output, /d0 : procedure::entry#1/ ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    let counter = 0;
    _.include( 'wProcedure' );
    _.Procedure.NativeWatchingEnable();

    log( 'a' );
    let timer1 = setInterval( () =>
    {
      log( `${counter}c` );
      counter += 1;
    }, 800 );
    let timer2 = setTimeout( () =>
    {
      clearInterval( timer1 );
      log( 'd' );
    }, 2000 );
    log( 'b' );

    function log( msg )
    {
      console.log( `${msg || ''} count : ${_.Procedure.InstancesArray.length}` );
      for( let i = 0 ; i < _.Procedure.InstancesArray.length ; i++ )
      {
        let procedure = _.Procedure.InstancesArray[ i ];
        console.log( `  ${msg}${i} : ${procedure._longName}` );
      }
    }
  }

}

nativeWatchingSetInterval.description =
`
- setInterval makes a procedure
- timeout of setInterval does not removes the made procedure
- clearInterval the made procedure
`

//

/* xxx qqq : implement for browser */
function nativeWatchingRequestAnimationFrame( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program ).programPath;

  test.true( true );

  if( !_global_.requestAnimationFrame )
  return;

  /* */

  a.appStartNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'error' ), 0 );
    test.identical( _.strCount( op.output, 'Error' ), 0 );

    test.identical( _.strCount( op.output, 'a count : 1' ), 1 );
    test.identical( _.strCount( op.output, /a0 : procedure::entry#1/ ), 1 );

    test.identical( _.strCount( op.output, 'b count : 3' ), 1 );
    test.identical( _.strCount( op.output, /b0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /b1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /b2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, '0c count : 3' ), 1 );
    test.identical( _.strCount( op.output, /0c0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /0c1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /0c2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, '1c count : 3' ), 1 );
    test.identical( _.strCount( op.output, /1c0 : procedure::entry#1/ ), 1 );
    test.identical( _.strCount( op.output, /1c1 : procedure::#2.*program:9/ ), 1 );
    test.identical( _.strCount( op.output, /1c2 : procedure::#3.*program:14/ ), 1 );

    test.identical( _.strCount( op.output, 'd count : 1' ), 1 );
    test.identical( _.strCount( op.output, /d0 : procedure::entry#1/ ), 1 );

    return null;

  });

  /* */

  return a.ready;

  function program()
  {
    const _ = require( toolsPath );
    let counter = 0;
    _.include( 'wProcedure' );
    _.Procedure.NativeWatchingEnable();

    log( 'a' );
    let timer1 = requestAnimationFrame( () =>
    {
      log( `${counter}c` );
      counter += 1;
    }, 800 );
    let timer2 = setTimeout( () =>
    {
      cancelAnimationFrame( timer1 );
      log( 'd' );
    }, 2000 );
    log( 'b' );

    function log( msg )
    {
      console.log( `${msg || ''} count : ${_.Procedure.InstancesArray.length}` );
      for( let i = 0 ; i < _.Procedure.InstancesArray.length ; i++ )
      {
        let procedure = _.Procedure.InstancesArray[ i ];
        console.log( `  ${msg}${i} : ${procedure._longName}` );
      }
    }
  }

}

nativeWatchingRequestAnimationFrame.description =
`
- requestAnimationFrame makes a procedure
- timeout of requestAnimationFrame does not removes the made procedure
- cancelAnimationFrame the made procedure
`

//

function Stack( test )
{

  test.case = 'without arguments';
  var got = stackGet();
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  /* */

  test.open( 'stack - null' );

  test.case = 'without delta';
  var got = stackGet( null );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - undefined';
  var got = stackGet( null, undefined );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 0';
  var got = stackGet( null, 0 );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( null, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( null, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - null' );

  /* */

  test.open( 'stack - undefined' );

  test.case = 'without delta';
  var got = stackGet( undefined );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - undefined';
  var got = stackGet( undefined, undefined );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 0';
  var got = stackGet( undefined, 0 );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( undefined, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( undefined, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - undefined' );

  /* */

  test.open( 'stack - true' );

  test.case = 'without delta';
  var got = stackGet( true );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - undefined';
  var got = stackGet( true, undefined );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 0';
  var got = stackGet( true, 0 );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( true, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( true, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - true' );

  /* */

  test.open( 'stack - false' );

  test.case = 'without delta';
  var got = stackGet( false );
  test.identical( got, '' );

  test.case = 'delta - false';
  var got = stackGet( false, undefined );
  test.identical( got, '' );

  test.case = 'delta - 0';
  var got = stackGet( false, 0 );
  test.identical( got, '' );

  test.case = 'delta - 1';
  var got = stackGet( false, 1 );
  test.identical( got, '' );

  test.case = 'delta - 2';
  var got = stackGet( false, 2 );
  test.identical( got, '' );

  test.close( 'stack - false' );

  /* */

  test.open( 'stack - 0' );

  test.case = 'without delta';
  var got = stackGet( 0 );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 0';
  var got = stackGet( 0, undefined );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 0';
  var got = stackGet( 0, 0 );
  test.true( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( 0, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 0, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - 0' );

  /* */

  test.open( 'stack - 1' );

  test.case = 'without delta';
  var got = stackGet( 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( 1, undefined );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( 1, 0 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.true( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 1';
  var got = stackGet( 1, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 1, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.false( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - 1' );

  /* */

  test.open( 'stack - 2' );

  test.case = 'without delta';
  var got = stackGet( 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 2, undefined );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 2, 0 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.true( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 2, 1 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.false( _.strHas( got, 'at stackGet2 ' ) );
  test.true( _.strHas( got, 'at stackGet ' ) );

  test.case = 'delta - 2';
  var got = stackGet( 2, 2 );
  test.false( _.strHas( got, 'at stackGet4 ' ) );
  test.false( _.strHas( got, 'at stackGet3 ' ) );
  test.false( _.strHas( got, 'at stackGet2 ' ) );
  test.false( _.strHas( got, 'at stackGet ' ) );

  test.close( 'stack - 2' );

  /* */

  test.open( 'stack - string' );

  test.case = 'without delta';
  var got = stackGet( 'some\nat@\nb\nc\nd' );
  test.identical( got, 'some\nat@\nb\nc\nd' );

  test.case = 'delta - undefined';
  var got = stackGet( 'some\nat@\nb\nc\nd', undefined );
  test.identical( got, 'some\nat@\nb\nc\nd' );

  test.case = 'delta - 0';
  var got = stackGet( 'some\nat@\nb\nc\nd', 0 );
  test.identical( got, 'some\nat@\nb\nc\nd' );

  test.case = 'delta - 1';
  var got = stackGet( 'some\nat@\nb\nc\nd', 1 );
  test.identical( got, 'some\nat@\nb\nc\nd' );

  test.case = 'delta - 2';
  var got = stackGet( 'some\nat@\nb\nc\nd', 2 );
  test.identical( got, 'some\nat@\nb\nc\nd' );

  test.close( 'stack - string' );

  /* - */

  if( Config.debug )
  {
    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () => _.Procedure.Stack( null, [ 1, 2 ], 'extra' ) );

    test.case = 'wrong type of stack';
    test.shouldThrowErrorSync( () => _.Procedure.Stack( [ 'at @' ] ) );

    test.case = 'wrong type of delta';
    test.shouldThrowErrorSync( () => _.Procedure.Stack( null, [] ) );
  }

  /* */

  function stackGet()
  {
    return stackGet2.apply( this, arguments );
  }

  function stackGet2()
  {
    return stackGet3.apply( this, arguments );
  }

  function stackGet3()
  {
    return stackGet4.apply( this, arguments );
  }

  function stackGet4()
  {
    return _.Procedure.Stack( ... arguments );
  }
}


// --
// declare
// --

const Proto =
{

  name : 'Tools.Procedure',
  silencing : 1,
  routineTimeOut : 60000,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    timeAccuracy : 1,
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {

    procedureIs,

    trivial,
    procedureSourcePath,
    procedureStack,
    activeProcedureSourcePath,
    quasiProcedure,
    accounting,

    terminationEventsExplicitTermination,
    terminationEventsImplicitTermination,
    terminationEventsTerminationWithConsequence,
    terminationBeginWithTwoNamespaces,

    nativeWatchingSetTimeout,
    nativeWatchingСlearTimeout,
    nativeWatchingSetInterval,
    nativeWatchingRequestAnimationFrame,

    Stack,

  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
