within TransiEnt.Basics.Blocks.Check;
model TestRealVectorExpression "Model for testing the RealVectorExpressions model"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends Icons.Checkmodel;
  Sources.RealVectorExpression sameAsTestdata(nout=2, y_set=Testdata.y) annotation (Placement(transformation(extent={{-26,-22},{-6,-2}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    Testdata(table=[0,0,0.0; 3600,1,0.0; 5400,0,0.0; 7200,1,0.0; 9000,1,0.0; 12600,0,0.0; 12600,1,0.0; 16200,1,0.0; 16200,0,0.0; 18000,0,0.0; 18000,1.2,0.0; 22320,1.2,0.0; 22320,-0.1,0.0; 26000,-0.1,0.0])
                                                                                                    annotation (Placement(transformation(extent={{-28,30},{8,66}})));
  annotation (experiment(StopTime=10000), __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for real vector expressions</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestRealVectorExpression;
