within TransiEnt.Basics.Tables.ElectricGrid;
model ResidualLoadExample "Residual load of volatile renewable powers (measured 2015) with fixed powers for Hamburg 2050"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.TableIcon;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Boolean posResidualLoad = false "Set to true get only positive residual load power as output" annotation(Dialog(enable=not negResidualLoad));
  parameter Boolean negResidualLoad = false "Set to true get only negative residual load power as output" annotation(Dialog(enable=not posResidualLoad));

  parameter Modelica.SIunits.Power P_R=67.9e6 "Must-run primary and secondary reserve power";
  parameter Real share_BM_base=0.218 "Share of biomass base load plants of total installed biomass capacity";
  parameter Real availability_BM_base=0.967 "Availability factor of biomass base load plants (FLH=availability*8760 h/a)";
  parameter Real share_BM_chp=0.443 "Share of biomass chp plants of total installed biomass capacity";
  parameter Real scaleFactor=1 "Output is multiplied with scaleFactor";
  parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness "Smoothness of table interpolation";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 RunOffWater(
    relativepath="electricity/RunOfWaterPlant_normalized_1J_2012.txt",
    change_of_sign=true,
    startTime=0,
    smoothness=smoothness,
    constantfactor=3600*5010*86e6) annotation (Placement(transformation(extent={{-78,-22},{-58,-2}})));
  Modelica.Blocks.Math.MultiSum multiSum(                                  nu=7, k=fill(1, 7))
                                                             annotation (Placement(transformation(extent={{-12,-12},{0,0}})));
  Modelica.Blocks.Math.Add add(k1=+1) annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Gain gain(k=scaleFactor)
                                       annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader OnshoreTable(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Onshore_900s,
    P_el_n=2582e6) annotation (Placement(transformation(
        extent={{10,9.5},{-10,-9.5}},
        rotation=180,
        origin={-68,38.5})));

  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader OffshoreTable(
    change_of_sign=true,
    P_el_n=639e6,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Offshore_900s) annotation (Placement(transformation(
        extent={{9,9},{-9,-9}},
        rotation=180,
        origin={-69,61})));
public
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader PVTable(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2015_Gesamt_900s,
    P_el_n=1378e6) annotation (Placement(transformation(
        extent={{-10,-9},{10,9}},
        rotation=0,
        origin={-68,13})));

  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 DemandTable(startTime=0, smoothness=smoothness) annotation (Placement(transformation(extent={{-78,78},{-58,98}})));
  Modelica.Blocks.Sources.Constant reservePower(k=-P_R) annotation (Placement(transformation(extent={{-78,-94},{-58,-74}})));
  Modelica.Blocks.Sources.RealExpression P_el_BM_base(y=-227e6*share_BM_base*availability_BM_base)                   annotation (Placement(transformation(extent={{-80,-46},{-56,-28}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 CHPTable(
    change_of_sign=true,
    startTime=0,
    smoothness=smoothness,
    relativepath="electricity/CHPPowerCurve_SLPGasHMF_capacityFactor_2012_3600s.txt",
    constantfactor=share_BM_chp*227e6) annotation (Placement(transformation(extent={{-80,-64},{-60,-44}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  if posResidualLoad then
    P_el = max(0, gain.y);
  elseif negResidualLoad then
    P_el = max(0,-gain.y);
  else
    P_el = gain.y;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(add.u2, multiSum.y) annotation (Line(points={{10,-6},{1.02,-6}},               color={0,0,127}));
  connect(add.y, gain.u) annotation (Line(points={{33,0},{32,0},{44,0}},          color={0,0,127}));
  connect(OffshoreTable.y1, multiSum.u[1]) annotation (Line(points={{-59.1,61},{-34.55,61},{-34.55,-2.4},{-12,-2.4}}, color={0,0,127}));
  connect(OnshoreTable.y1, multiSum.u[2]) annotation (Line(points={{-57,38.5},{-34.5,38.5},{-34.5,-3.6},{-12,-3.6}}, color={0,0,127}));
  connect(PVTable.y1, multiSum.u[3]) annotation (Line(points={{-57,13},{-34.5,13},{-34.5,-4.8},{-12,-4.8}}, color={0,0,127}));
  connect(RunOffWater.y1, multiSum.u[4]) annotation (Line(points={{-57,-12},{-34,-12},{-34,-6},{-12,-6}},       color={0,0,127}));
  connect(DemandTable.y1, add.u1) annotation (Line(points={{-57,88},{-57,84},{-14,84},{-14,6},{10,6}}, color={0,0,127}));
  connect(P_el_BM_base.y, multiSum.u[5]) annotation (Line(points={{-54.8,-37},{-32,-37},{-32,-7.2},{-12,-7.2}}, color={0,0,127}));
  connect(CHPTable.y1, multiSum.u[6]) annotation (Line(points={{-59,-54},{-44,-54},{-28,-54},{-28,-8.4},{-12,-8.4}}, color={0,0,127}));
  connect(reservePower.y, multiSum.u[7]) annotation (Line(points={{-57,-84},{-40,-84},{-24,-84},{-24,-9.6},{-12,-9.6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-102,-48},{-84,-60}},
          lineColor={28,108,200},
          textString="set to cover
60 percent of
heat demand")}),                                                                                    Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Example for the residual load of volatile renewable Powers with fixed powers for Hamburg in 2050.</p>
<p>Renewable Powers measured in 2015</p>
<p>Electricity Demand for Hamburg measured in 2012</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: electric power in W</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end ResidualLoadExample;
