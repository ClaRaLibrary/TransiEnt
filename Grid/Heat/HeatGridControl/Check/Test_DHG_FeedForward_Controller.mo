within TransiEnt.Grid.Heat.HeatGridControl.Check;
model Test_DHG_FeedForward_Controller "Testing of DHNControl and DHNPowerScheluder with power plants"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-116,-3},{-96,17}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-190,100},{-170,120}})));
  inner TransiEnt.ModelStatistics modelStatistics    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));

  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(a=100e6),
    Damping_Weekend=0.95,
    offsetOn=false,
    weekendOn=false) annotation (Placement(transformation(extent={{-70,35},{-56,49}})));
  TransiEnt.Grid.Heat.HeatGridControl.Controllers.DHG_FeedForward_Controller dHG_FeedForward_Controller annotation (Placement(transformation(extent={{-58,-4},{-28,16}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

     function plotResult

     algorithm
    TransiEnt.Basics.Functions.plotResult("Test_DHG_FeedForward_Controller.m");
       createPlot(
         id=1,
         position={0,0,1443,860},
         y={"dHG_FeedForward_Controller.Q_flow_i[1]","dHG_FeedForward_Controller.Q_flow_i[2]","dHG_FeedForward_Controller.Q_flow_i[3]","dHG_FeedForward_Controller.Q_flow_i[4]"},
         range={0.0,32000000.0,-100000000.0,700000000.0},
         grid=true,
         filename="Test_DHG_FeedForward_Controller.mat",
         colors={{28,108,200},{238,46,47},{0,140,72},{217,67,180}});
       createPlot(
         id=1,
         position={0,0,1443,283},
         y={"dHG_FeedForward_Controller.h_supply.T","dHG_FeedForward_Controller.h_return.T"},
         range={0.0,32000000.0,40.0,140.0},
         grid=true,
         subPlot=3,
         colors={{28,108,200},{238,46,47}});
       createPlot(
         id=1,
         position={0,0,1443,284},
         y={"dHG_FeedForward_Controller.m_flow_i[1]","dHG_FeedForward_Controller.m_flow_i[2]","dHG_FeedForward_Controller.m_flow_i[3]","dHG_FeedForward_Controller.m_flow_i[4]"},
         range={0.0,32000000.0,-500.0,2000.0},
         grid=true,
         subPlot=2,
         colors={{28,108,200},{238,46,47},{0,140,72},{217,67,180}});
     end plotResult;

equation

  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1, heatingLoadCharline.T_amb) annotation (Line(points={{-95,7},{-84,7},{-84,42.7},{-70.7,42.7}}, color={0,0,127}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.value, dHG_FeedForward_Controller.T_ambient) annotation (Line(points={{-97.2,7},{-76,7},{-76,6},{-53,6}}, color={0,0,127}));
  connect(heatingLoadCharline.Q_flow, dHG_FeedForward_Controller.Q_dot_DH_Targ) annotation (Line(
      points={{-55.3,42},{-48,42},{-48,17},{-42,17}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{240,120}})),
    experiment(StopTime=3.1536e+007, __Dymola_NumberOfIntervals=500000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-200,-100},{240,120}}, preserveAspectRatio=false),
                    graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for DHG_FeedForward_Controller</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Test_DHG_FeedForward_Controller;
