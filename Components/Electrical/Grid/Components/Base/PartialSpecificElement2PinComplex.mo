within TransiEnt.Components.Electrical.Grid.Components.Base;
partial model PartialSpecificElement2PinComplex "Partial modell for two pin Inductor, Capacitor and Resistor, active losses"


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
  //          Imports and Class Hierarchy
  // _____________________________________________

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Length l(min = 0) = 1 "length of element";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  //outer TransiEnt.SimCenter simCenter;

// _____________________________________________
//
//             Variable Declarations
// _____________________________________________
//

public
     SI.ComplexPower S;
     SI.ComplexVoltage U;
     SI.ComplexCurrent I;
     SI.ComplexPower S_lost;
     SI.ComplexVoltage U_drop;
     SI.ActivePower P(start=0);
     SI.ReactivePower Q(start=0);
     SI.ComplexImpedance Z;



// _____________________________________________
//
//           Characteristic equations
// _____________________________________________

equation




   epp_p.f = epp_n.f;

   Connections.branch(epp_p.f,epp_n.f);



      P = S.re;
      Q = S.im;

      S.re = epp_p.P;
      S.im = epp_p.Q;
      U.re = epp_p.v*cos(epp_p.delta); //*(v_level/simCenter.v_n)
      U.im = epp_p.v*sin(epp_p.delta); //*(v_level/simCenter.v_n)

        I = Modelica.ComplexMath.conj(S / U);
        U_drop = I * Z;
        S_lost = U_drop * Modelica.ComplexMath.conj(I);
        epp_n.v =Modelica.ComplexMath.abs(U - U_drop);    //transient_library/TransiEnt/Components/Electrical/PowerTransformation/SimpleTransformerComplex.mo
        epp_n.delta=Modelica.ComplexMath.arg(U - U_drop);
        epp_n.P = -Modelica.ComplexMath.real(S - S_lost);
        epp_n.Q = -Modelica.ComplexMath.imag(S - S_lost);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of 2pin using TransiEnt complex single phase interface</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E Quasi-stationary model with complex value calculation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">All know limitation of quasi-stationary fixed-frequency modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two Complex Power Ports for modeling a two pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">U=Z*I</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">S=U*I*</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Kirchhoff's Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Base Model, do not use in simulation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">validated with literature by validating higher level models</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pattrick Göttsch, Pascal Dubucq (dubucq@tuhh.de) and Rebekka Denninger (rebekka.denninger@tuhh.de) from march 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
</html>"));
end PartialSpecificElement2PinComplex;
