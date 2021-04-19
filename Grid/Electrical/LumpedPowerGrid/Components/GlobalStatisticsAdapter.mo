within TransiEnt.Grid.Electrical.LumpedPowerGrid.Components;
model GlobalStatisticsAdapter "Passes through local statistics to specific connectors in global statistics"
  import TransiEnt;
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
  extends TransiEnt.Basics.Icons.OuterElement;

  outer ModelStatistics modelStatistics;
  outer SimCenter simCenter;
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectKineticEnergy collectKineticEnergy annotation (Placement(transformation(extent={{-42,0},{-22,20}})));

  TransiEnt.Basics.Interfaces.General.KinteticEnergyIn E_kin "Kinetic energy stored in rotating masses of synchronous generators" annotation (
      Placement(transformation(extent={{-66,-2},{-46,18}}),  iconTransformation(
          extent={{98,-48},{78,-28}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_load "Charging/discharging power" annotation (
      Placement(transformation(extent={{-66,-42},{-46,-22}}),iconTransformation(
          extent={{98,-48},{78,-28}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower annotation (Placement(transformation(extent={{-42,-42},{-22,-22}})));
equation

  collectKineticEnergy.kineticEnergyCollector.E_kin=E_kin;
  connect(modelStatistics.kineticEnergyCollector[simCenter.iSurroundingGrid],collectKineticEnergy.kineticEnergyCollector);

  collectElectricPower.powerCollector.P = P_load;
  connect(modelStatistics.surroundingGridLoad,collectElectricPower.powerCollector);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{38,-22},{68,-52}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{14,-2},{88,-70}}, lineColor={0,0,0}),
        Line(
          points={{38,-22},{-14,32}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-82,94},{-14,32}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
                Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end GlobalStatisticsAdapter;
