within TransiEnt.Producer.Combined.SmallScaleCHP;
model CHP_ice "Model of a small CHP with configureable internal combustion engine"



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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartialCHP(p_init=simCenter.p_nom[1]);

  // _____________________________________________
  //
  //            Constants and Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.PressureDifference dp_total=waterPortIn.p - waterPortOut.p "Total pressure loss";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_out_is=Q_flow_out "Heat flow rate Output" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,104})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

equation
  assert(gasPortIn.m_flow >= 0, "Your CHP is a gas source.");
  assert(supplyTemperatureSensor.T > 0 and returnTemperatureSensor.T > 0,"Temperatures in CHP too low. Please check your mass flow rate");

  //Control
  controlBus.dp =-dp_total;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(motorblock.waterPortIn, waterPortIn) annotation (Line(
      points={{0.2,-16},{0,-16},{0,-90},{100,-90}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(motorblock.waterPortOut, waterPortOut) annotation (Line(
      points={{33.8,-16},{34,-16},{34,-50},{100,-50}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (defaultComponentName="CHP",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),           Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),  graphics),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a configureable CHP with internal combustion engine.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>controlBus</p>
<p>gasPortIn: inlet for ideal gas</p>
<p>gasPortOut: outlet for ideal gas</p>
<p>waterPortOut: FluidPortOut</p>
<p>waterPortIn: FluidPortIn</p>
<p>Q_flow_out_is: output for heat flow rate in [W]</p>
<p>epp: type of power port can be chosen</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Producer.Combined.SmallScaleCHP.Check.Test_CHP_ice&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Edited by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Apr 2015</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Edited by Anne Senkel (anne.senkel@tuhh.de), Feb 2019</span></p>
</html>"));
end CHP_ice;
