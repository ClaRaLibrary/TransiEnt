within TransiEnt.Components.Electrical.Machines.Base;
partial model PartialQuasiStationaryGeneratorComplex "Abstract class for quasistationary generators for ComplexPowerPort"

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



  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGenerator(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp);

  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________




  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________



  parameter Modelica.SIunits.ActivePower P_el_n = 180e3 "Nominal active power" annotation(Dialog(group="General"));
  parameter Modelica.SIunits.ApparentPower S_n = 225e3 "Nominal apparent power" annotation(Dialog(group="General"));
  parameter Boolean IsSlack=false "true for Slack bus" annotation(Dialog(group="Type of Bus"));
   parameter SI.Angle angle_slacklsm=0 "Set voltage angle at port or polar wheel angle at slack machine" annotation(Dialog(enable=IsSlack,group="Type of Bus"));
   parameter Boolean OwnFrequency=false "true for own frequency, only possible when IsSlack=false" annotation(Dialog(enable=not IsSlack,group="Type of Bus"));
   parameter Real D_cage=0 "Cage Damping" annotation(Dialog(enable=OwnFrequency,group="Physical constraints"));
  final parameter Modelica.SIunits.PowerFactor cosphi_n = P_el_n/S_n;
  final parameter Modelica.SIunits.ReactivePower Q_n= sqrt(S_n^2-P_el_n^2);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________


  //TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-120,-20},{-90,10}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________


  SI.ReactivePower Q_is( start=Q_n) = -epp.Q annotation (Dialog(group="Initialization", showStartAttribute=true));

    Modelica.SIunits.Power P_mech=-mpp.tau*der(mpp.phi);

    SI.Frequency f_complex(start=simCenter.f_n,fixed=IsSlack);

    SI.Angle delta_lsm(start=0.17453292519943295) annotation (Dialog(group="Initialization", showStartAttribute=true));
    SI.Angle theta(start=0.17453292519943295) annotation (Dialog(group="Initialization", showStartAttribute=true));

initial equation

  if OwnFrequency==true then
    der(f_complex)=0;
    omega=Modelica.SIunits.Conversions.from_Hz(simCenter.f_n);
  end if;

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  //important part of the model: Slack or PU Bus version
  if IsSlack==true then
    //set epp.delta to fixed value
    if simCenter.use_reference_polar_wheel then

     theta=angle_slacklsm;
    else

      delta_lsm=angle_slacklsm;

    end if;

    //Slack Bus is root in connection tree fro epp.f
  Connections.root(epp.f);

  else
    //PU Bus is potential root in connection tree fro epp.f
    Connections.potentialRoot(epp.f);

  end if;

  if OwnFrequency==true then
     der(theta)=Modelica.SIunits.Conversions.from_Hz(f_complex-epp.f);

    else
    epp.f=f_complex;
  end if;



  epp.delta=delta_lsm;

  f_complex = Modelica.SIunits.Conversions.to_Hz(der(mpp.phi));

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of an electric machine using TransiEnt electrical interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L2E (defined in the CodingConventions) - differential equation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Mechanical power port mpp</p>
<p>Modelica RealInput: E_input</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q is the reactive power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_mech is the mechanical power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_complex is a frequency</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">delta_lsm is an angle</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in June 2018</span></p>
</html>"));
end PartialQuasiStationaryGeneratorComplex;
