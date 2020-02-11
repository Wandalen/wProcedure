( function _Procedure_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  var _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l8/Procedure.s' );

}

var _global = _global_;
var _ = _global_.wTools;
let fileProvider = _testerGlobal_.wTools.fileProvider;
let path = fileProvider.path;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = path.pathDirTempOpen( path.join( __dirname, '../..'  ), 'procedure' );
  self.assetsOriginalSuitePath = path.join( __dirname, '_asset' );

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, '/procedure-' ) )
  path.pathDirTempClose( self.suiteTempPath );
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
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
    let _ = require( toolsPath );
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

function activeProcedureSourcePath( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /sourcePath::program.*program.js:31/ ), 1 );
    test.identical( _.strCount( op.output, /sourcePath::timeout.*program.js:21/ ), 1 );
    test.identical( _.strCount( op.output, /sourcePath::callback1.*program.js:8/ ), 1 );
    test.identical( _.strCount( op.output, /sourcePath::callback2.*program.js:13/ ), 1 );
    test.identical( _.strCount( op.output, 'sourcePath::' ), 4 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'procedure::entry' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::quasi' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 2 );
    test.identical( _.strCount( op.output, 'program.js:5' ), 1 );
    test.identical( _.strCount( op.output, 'program.js:12' ), 1 );
    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.procedure.begin({ _name : 'quasi', _quasi : true, _waitTimer : false });
    logger.log( _.procedure.exportInfo() );
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /program.end(.|\n|\r)*timeout1(.|\n|\r)*timeout2/mg ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 5 );

    test.identical( _.strCount( op.output, 'procedure::entry' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::time.begin' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::time.out' ), 2 );
    test.identical( _.strCount( op.output, 'procedure::quasi' ), 1 );

    test.identical( _.strCount( op.output, 'program.js:39' ), 1 );
    test.identical( _.strCount( op.output, 'program.js:6' ), 1 );
    test.identical( _.strCount( op.output, 'program.js:11' ), 2 );
    test.identical( _.strCount( op.output, 'program.js:16' ), 1 );

    test.identical( _.strCount( op.output, 'entry r:null o:String wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'time.begin r:timeOut1 o:Timer wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'time.out r:timeGot o:Competitor wt:Timer' ), 1 );
    test.identical( _.strCount( op.output, 'time.out r:timeEnd o:Timer wt:false' ), 1 );
    test.identical( _.strCount( op.output, 'quasi r:null o:Null wt:false' ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
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
    logger.log( _.procedure.exportInfo() );

    console.log( 'program.end' );

    for( let p in _.Procedure.NamesMap )
    {
      let procedure = _.Procedure.NamesMap[ p ];
      let rou = ( procedure._routine ? procedure._routine.name : procedure._routine );
      let obj = _.strType( procedure._object );
      if( _.timerIs( procedure._object ) )
      obj = 'Timer';
      if( _.competitorIs( procedure._object ) )
      obj = 'Competitor';
      let wt = _.timerIs( procedure._waitTimer ) ? 'Timer' : procedure._waitTimer;
      debugger;
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
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
    let _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    let t = 1500;

    let timer = _.time.begin( t*1, () =>
    {
      console.log( 'timer' );
    });

    console.log( 'v1' );

    _.Procedure.On( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.Procedure.On( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    _.Procedure.TerminationPeriod = 1000;
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
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
    let _ = require( toolsPath );
    _.include( 'wConsequence' );
    _.include( 'wProcedure' );
    _.include( 'wAppBasic' );

    let t = 100;

    let timer = _.time.begin( t*1, () =>
    {
      console.log( 'timer' );
    });

    console.log( 'v1' );

    _.Procedure.On( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.Procedure.On( 'terminationEnd', () =>
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
  let programPath = a.program( program );

  /* */

  a.jsNonThrowing({ execPath : programPath })
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
    let _ = require( toolsPath );
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

    _.Procedure.On( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
      con.take( 'terminationBegin1' )
    });

    _.Procedure.On( 'terminationEnd', () =>
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

    _.Procedure.TerminationBegin();
  }

}

terminationEventsTerminationWithConsequence.timeOut = 60000;
terminationEventsTerminationWithConsequence.description =
`
- callback of event terminationBegin get called once
- callback of event terminationEnd get called once
- callback of consequence get resource
`

// --
// declare
// --

var Self =
{

  name : 'Tools.base.Procedure',
  silencing : 1,
  routineTimeOut : 30000,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    timeAccuracy : 1,
    suiteTempPath : null,
    assetsOriginalSuitePath : null,
    execJsPath : null,
  },

  tests :
  {
    procedureIs, // Dmytro : the second part of routine in module wTools

    trivial,
    activeProcedureSourcePath,
    quasiProcedure,
    accounting,

    terminationEventsExplicitTermination,
    terminationEventsImplicitTermination,
    terminationEventsTerminationWithConsequence,

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
