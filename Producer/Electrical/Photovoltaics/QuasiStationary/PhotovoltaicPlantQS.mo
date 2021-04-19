within TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary;
model PhotovoltaicPlantQS "Simple efficiency-based PV model"

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
  extends TransiEnt.Basics.Icons.SolarElectricalModel;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Area A_module=1 "PV Module surface";
  parameter SI.Efficiency eta=0.2 "Total efficiency from radiation to power output";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  TransiEnt.Basics.Adapters.EPP_to_QS p_To_EPP annotation (Placement(transformation(extent={{66,-9},{48,9}})));
  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=
        simCenter.ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-46,-18},{-30,18}})));
  TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.PhotovoltaicModuleQS constantEfficiencyPVModule annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{88,-12},{110,12}}), iconTransformation(extent={{88,-10},{110,12}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(GlobalSolarRadiation.y, constantEfficiencyPVModule.u) annotation (Line(
      points={{-29.2,0},{-14.4,0}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(constantEfficiencyPVModule.currentP, p_To_EPP.voltageP) annotation (Line(points={{6,0},{27,0},{48,0}}, color={85,170,255}));
  connect(p_To_EPP.epp, epp) annotation (Line(points={{66,0},{99,0},{99,0}}, color={0,127,0}));
        annotation (Icon(graphics,
                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-80,0},{-46,0}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple efficiency-based PV model.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">quasi-stationary model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.Check.TestPhotovoltaicPlantQS&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PhotovoltaicPlantQS;
