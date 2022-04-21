within TransiEnt.Components.Gas.GasCleaning.Check;
model TestPressureSwingAdsorptionReactor_L1


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




  extends TransiEnt.Basics.Icons.Checkmodel;

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var vle_sg;

  TransiEnt.Components.Gas.GasCleaning.PressureSwingAdsorptionReactor_L1 pSA annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(
    medium=vle_sg,
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true) annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_H2(
    medium=vle_sg,
    variable_p=true,
    p_const=100000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={26,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_WasteGas(medium=vle_sg, variable_p=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={6,24})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=-1,
    duration=1000,
    startTime=1000)
                  annotation (Placement(transformation(extent={{-68,44},{-48,64}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1000,
    startTime=3000,
    height=50,
    offset=273.15) annotation (Placement(transformation(extent={{-68,14},{-48,34}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.20,0.70,0,0.02,0; 5000,0.20,0.70,0,0.02,0; 6000,0.10,0.50,0.20,0.10,0.05; 12000,0.10,0.50,0.20,0.10,0.05])                                                                     annotation (Placement(transformation(extent={{-68,-16},{-48,4}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    offset=30e5,
    duration=1000,
    startTime=7000,
    height=-20e5)  annotation (Placement(transformation(extent={{66,-4},{46,16}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=1000,
    startTime=9000,
    height=-4e5,
    offset=5e5)    annotation (Placement(transformation(extent={{46,34},{26,54}})));

  Modelica.Units.SI.MassFlowRate m_flow_CH4_in=pSA.gasPortIn.m_flow*inStream(pSA.gasPortIn.xi_outflow[1]);
  Modelica.Units.SI.MassFlowRate m_flow_CH4_out=-(pSA.gasPortOut_hydrogen.m_flow*pSA.gasPortOut_hydrogen.xi_outflow[1] + pSA.gasPortOut_offGas.m_flow*pSA.gasPortOut_offGas.xi_outflow[1]);
  Modelica.Units.SI.MassFlowRate m_flow_CO2_in=pSA.gasPortIn.m_flow*inStream(pSA.gasPortIn.xi_outflow[2]);
  Modelica.Units.SI.MassFlowRate m_flow_CO2_out=-(pSA.gasPortOut_hydrogen.m_flow*pSA.gasPortOut_hydrogen.xi_outflow[2] + pSA.gasPortOut_offGas.m_flow*pSA.gasPortOut_offGas.xi_outflow[2]);
  Modelica.Units.SI.MassFlowRate m_flow_H2O_in=pSA.gasPortIn.m_flow*inStream(pSA.gasPortIn.xi_outflow[3]);
  Modelica.Units.SI.MassFlowRate m_flow_H2O_out=-(pSA.gasPortOut_hydrogen.m_flow*pSA.gasPortOut_hydrogen.xi_outflow[3] + pSA.gasPortOut_offGas.m_flow*pSA.gasPortOut_offGas.xi_outflow[3]);
  Modelica.Units.SI.MassFlowRate m_flow_H2_in=pSA.gasPortIn.m_flow*inStream(pSA.gasPortIn.xi_outflow[4]);
  Modelica.Units.SI.MassFlowRate m_flow_H2_out=-(pSA.gasPortOut_hydrogen.m_flow*pSA.gasPortOut_hydrogen.xi_outflow[4] + pSA.gasPortOut_offGas.m_flow*pSA.gasPortOut_offGas.xi_outflow[4]);
  Modelica.Units.SI.MassFlowRate m_flow_CO_in=pSA.gasPortIn.m_flow*inStream(pSA.gasPortIn.xi_outflow[5]);
  Modelica.Units.SI.MassFlowRate m_flow_CO_out=-(pSA.gasPortOut_hydrogen.m_flow*pSA.gasPortOut_hydrogen.xi_outflow[5] + pSA.gasPortOut_offGas.m_flow*pSA.gasPortOut_offGas.xi_outflow[5]);
  Modelica.Units.SI.MassFlowRate m_flow_N2_in=pSA.gasPortIn.m_flow*(1 - sum(inStream(pSA.gasPortIn.xi_outflow)));
  Modelica.Units.SI.MassFlowRate m_flow_N2_out=-(pSA.gasPortOut_hydrogen.m_flow*(1 - sum(pSA.gasPortOut_hydrogen.xi_outflow)) + pSA.gasPortOut_offGas.m_flow*(1 - sum(pSA.gasPortOut_offGas.xi_outflow)));

equation
  connect(combiTimeTable.y, source.xi) annotation (Line(points={{-47,-6},{-47,-6},{-38,-6}}, color={0,0,127}));
  connect(ramp2.y, sink_H2.p) annotation (Line(points={{45,6},{38,6}}, color={0,0,127}));
  connect(ramp3.y, sink_WasteGas.p) annotation (Line(points={{25,44},{22,44},{0,44},{0,36}}, color={0,0,127}));
  connect(ramp.y, source.m_flow) annotation (Line(points={{-47,54},{-42,54},{-42,6},{-38,6}}, color={0,0,127}));
  connect(ramp1.y, source.T) annotation (Line(points={{-47,24},{-44,24},{-44,0},{-38,0}}, color={0,0,127}));
  connect(sink_WasteGas.gasPort, pSA.gasPortOut_offGas) annotation (Line(
      points={{6,14},{6,7},{6,7}},
      color={255,255,0},
      thickness=1.5));
  connect(pSA.gasPortOut_hydrogen, sink_H2.gasPort) annotation (Line(
      points={{10,0},{13,0},{16,0}},
      color={255,255,0},
      thickness=1.5));
  connect(source.gasPort, pSA.gasPortIn) annotation (Line(
      points={{-16,0},{-13,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,100}}),  graphics={Text(
          extent={{-52,96},{52,80}},
          lineColor={0,140,72},
          textString="1000-2000 s mass flow from 1 to 2 kg/s
3000-4000 s temperature from 0 to 50 C
5000-6000 s composition changes
7000-8000 s pressure at H2 output from 30 to 10 bar
9000-10000 s pressure at WasteGas output from 5 to 1 bar"),
                                 Text(
          extent={{-30,74},{30,60}},
          lineColor={0,140,72},
          textString="check  component mass flows are equal
check mass flows
check pressure loss in right direction")}),
    experiment(StopTime=12000, __Dymola_NumberOfIntervals=600),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-20},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the PressureSwingAdsorptionReactor_L1 model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
end TestPressureSwingAdsorptionReactor_L1;
