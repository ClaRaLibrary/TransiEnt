within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base;
model Buoyancy "Model to add buoyancy if there is a temperature inversion in the tank"
  // Model is bases on the model "Bouyancy in the "Buildings-library (https://github.com/lbl-srg/modelica-buildings.git)"

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

  extends TransiEnt.Basics.Icons.Block;
  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  // _____________________________________________
  //
  //             Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Volume V "Volume of tank";
  parameter Integer N_cv(min=3) = 3 "Number of finite control volumes";
  parameter Modelica.SIunits.Time tau(min=0) "Time constant for buoyancy mixing";
  parameter Modelica.SIunits.Density rho= 998 "Density, used to compute fluid mass";
  parameter Modelica.SIunits.SpecificHeatCapacity c_v= 4.2e3 "Specific heat capacity";

   final parameter Real k(unit="W/K") = V*rho*c_v/tau/N_cv "Proportionality constant, since we use Delta_T instead of dH";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[N_cv] heatPort "Heat input into the volumes" annotation (Placement(transformation(extent={{-112,-6},{-92,14}}), iconTransformation(extent={{-112,-6},{-92,14}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate[N_cv-1] Q_flow "Heat flow rate due to buoyancy from segment i to i+1";

   Modelica.SIunits.TemperatureDifference Delta_T[N_cv-1] "Driving Temperature difference between adjoining control volumes";

equation
  for i in 1:N_cv-1 loop

    // Driving temperature difference is from bottom to top (i.e. from i to i+1)
    Delta_T[i] = -heatPort[i].T+heatPort[i+1].T;

    // No buoyancy effects if temperature difference zero. This formulation is inspired by Modelica Buildings-Library.
    Q_flow[i] = k*noEvent(smooth(1, if Delta_T[i]>0 then Delta_T[i]^2 else 0));

  end for;

  // Heat ports are connected to control volumes. Note that if heatPort.Q_flow < 0 it will act like a source in the control volume!
  heatPort[1].Q_flow = -Q_flow[1];
  for i in 2:N_cv-1 loop
    heatPort[i].Q_flow = -Q_flow[i]+Q_flow[i-1];
  end for;
  heatPort[N_cv].Q_flow = Q_flow[N_cv-1];

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adds Buoyancy to a stratified storage.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Convective energy flow is considered as heat flow of the same amount.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Purely technical component without physical modeling.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>heatPort[N_cv]: Gets the temperatures from the temperature layers and returns the heat flow due to boyancy back</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>The input parameters</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This model should be used to add buoyancy to a one dimensional water storage model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>This model&nbsp;is&nbsp;largely based&nbsp;on&nbsp;the&nbsp;model&nbsp;&quot;Bouyancy&quot;&nbsp;in&nbsp;the&nbsp;Modelica Buildings-library&nbsp;(https://github.com/lbl-srg/modelica-buildings.git)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model revised by Pascal Dubucq (dubucq@tuhh.de) on Wed August 24 2016. Control volumes are now in intuitive order (1 = bottom, N_cv = top volume)</p>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{0,-38},{16,-38},{16,12},{26,12},{0,42},{-26,12},{-16,12},{-16,-38},{0,-38}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={0,-6},
          rotation=360)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics));
end Buoyancy;
