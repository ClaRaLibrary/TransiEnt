within TransiEnt.Components.Gas.VolumesValvesFittings;
model ValveDesiredDp "Simple valve with desired pressure difference"

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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Valve;


  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium used in the valve" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TransiEnt.Basics.Interfaces.General.PressureDifferenceIn dp_desired "Desired pressure difference" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-100,65})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    xi=noEvent(actualStream(gasPortIn.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=noEvent(actualStream(gasPortOut.h_outflow)),
    xi=noEvent(actualStream(gasPortOut.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{70,-12},{90,8}})));

public
  Summary summary(gasPortIn(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortIn.xi_outflow)),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=noEvent(actualStream(gasPortIn.h_outflow)),
      rho=gasIn.d), gasPortOut(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortOut.xi_outflow)),
      x=gasOut.x,
      m_flow=gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=noEvent(actualStream(gasPortOut.h_outflow)),
      rho=gasOut.d)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));


equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  gasPortOut.p=gasPortIn.p-dp_desired;

//_______________Mass balance (no storage)__________________________
  gasPortIn.m_flow+gasPortOut.m_flow=0;

//_________________Energy balance___________________________________
// Isenthalpic state transformation (no storage and no loss of energy)
  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);
  gasPortOut.h_outflow=inStream(gasPortIn.h_outflow);

//______________ No chemical reaction taking place:_________________
  gasPortIn.xi_outflow=inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow=inStream(gasPortIn.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (defaultComponentName="valve_p",
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1),
                     graphics={                                      Text(
          extent={{-100,70},{10,24}},
          lineColor={28,108,200},
          textString="dp")}),
    Diagram(graphics,
            coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1)),
                     Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a simple valve for real gases which ensures a given pressure difference. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model works like an ideally controlled valve to ensure a given pressure difference. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases and if the inertia and time delays of the valve are negligible.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the real gas </p>
<p>gasPortOut: Outlet of the real gas </p>
<p>dp_desired: Inlet for the desired pressure difference </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) on Tue Apr 05 2016</p>
</html>"));
end ValveDesiredDp;
