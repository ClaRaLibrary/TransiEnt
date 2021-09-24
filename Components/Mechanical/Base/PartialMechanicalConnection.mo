within TransiEnt.Components.Mechanical.Base;
partial model PartialMechanicalConnection "Abstract mechanical connection model used between turbine and generator (could be an Inertia element or a clutch..)"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  //                  Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.ActivePower P_n=1e6 "Nominal power";
  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics";
  parameter SI.Inertia J(min=0, start=1) "Moment of inertia";
  parameter StateSelect stateSelect=StateSelect.default "Priority to use phi and w as states"
    annotation (HideResult=true, Dialog(tab="Advanced"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectKineticEnergy collectKineticEnergy annotation (Placement(transformation(extent={{-19,-100},{1,-80}})));

  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp_a "Left flange of shaft" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp_b "Right flange of shaft" annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0), iconTransformation(extent={{90,-10},{110,10}})));

  SI.AngularVelocity omega(stateSelect=stateSelect);
  SI.Angle phi(stateSelect=stateSelect) "Absolute rotation angle of component"
    annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.KineticEnergy E_kin;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer ModelStatistics modelStatistics;
  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                  Equations
  // _____________________________________________

equation

  phi = mpp_a.phi;
  phi = mpp_b.phi;
  omega = der(phi);

  collectKineticEnergy.kineticEnergyCollector.E_kin=E_kin;
  connect(modelStatistics.kineticEnergyCollector[nSubgrid],collectKineticEnergy.kineticEnergyCollector);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,10},{-50,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{50,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-50,44},{50,-46}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-36,-30},{-10,10},{-2,-4},{34,26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-38,38},{-38,-34},{44,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-144,-99},{156,-139}},
          lineColor={0,134,134},
          textString="%name")}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Interface for mechanical shafts using TransiEnt mechanical interfaces</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model contains moment of inertia statistics. It sends the moment of inertia specified by parameter J to the statistics component if it is connected, i.e. if isRunning=true</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>mpp_a: mechanical power port</p>
<p>mpp_b: mechanical power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PartialMechanicalConnection;
