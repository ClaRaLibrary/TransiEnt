within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss;
model Ergun "Empirical Correlation according to Ergun"


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


  import SI = ClaRa.Basics.Units;
  import TILMedia.GasObjectFunctions.density_phxi;
  import Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;


  extends TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.PressureLossBasePackedBed;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  final parameter ClaRa.Basics.Units.Area permeability = 2*iCom.porosity*iCom.d_h^2/150;


  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

 if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
   v_FM[i] = (150*eta_FM[i]*(1-iCom.porosity)^2*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]))/(iCom.d_SM^2*iCom.porosity^3))^(-1) *dp_pb_V[i];
   v_FM[i] = (1.75*rho_FM[i]*(1-iCom.porosity)*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]))/(iCom.d_SM*iCom.porosity^3))^(-0.5)*ClaRa.Basics.Functions.ThermoRoot(dp_pb_I[i],Delta_p_smooth);
    end for;
    dp_pb_V[1] = 0;
    dp_pb_I[1] = 0;
    dp_pb_V[iCom.N_cv + 1] = 0;
    dp_pb_I[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      v_FM[i] = (150*eta_FM[i]*(1-iCom.porosity)^2*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]))/(iCom.d_SM^2*iCom.porosity^3))^(-1)*dp_pb_V[i];
 v_FM[i] = (1.75*rho_FM[i]*(1-iCom.porosity)*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]))/(iCom.d_SM*iCom.porosity^3))^(-0.5)*ClaRa.Basics.Functions.ThermoRoot(dp_pb_I[i],Delta_p_smooth);
    end for;
    dp_pb_V[1] = 0;
    dp_pb_I[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
       v_FM[i] = (150*eta_FM[i]*(1-iCom.porosity)^2*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv+1]))/(iCom.d_SM^2*iCom.porosity^3))^(-1)*dp_pb_V[i];
 v_FM[i] = (1.75*rho_FM[i]*(1-iCom.porosity)*geo.Delta_x_FM[i]*(sum(geo.Delta_x_FM)/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv+1]))/(iCom.d_SM*iCom.porosity^3))^(-0.5)*ClaRa.Basics.Functions.ThermoRoot(dp_pb_I[i],Delta_p_smooth);
    end for;
    dp_pb_V[iCom.N_cv + 1] = 0;
    dp_pb_I[iCom.N_cv + 1] = 0;

  else

    //frictionAtInlet and frictionAtOutlet
  for i in 1:iCom.N_cv+1 loop
 v_FM[i] = (150*eta_FM[i]*(1-iCom.porosity)^2*geo.Delta_x_FM[i]/(iCom.d_SM^2*iCom.porosity^3))^(-1)*dp_pb_V[i];
 v_FM[i] = (1.75*rho_FM[i]*(1-iCom.porosity)*geo.Delta_x_FM[i]/(iCom.d_SM*iCom.porosity^3))^(-0.5)*ClaRa.Basics.Functions.ThermoRoot(dp_pb_I[i],Delta_p_smooth);
 end for;

  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Empirical packed bed pressure loss correlation according to Ergun. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: Courier New;\">S.&nbsp;Ergun,&nbsp;Fluid&nbsp;Flow&nbsp;Through&nbsp;Packed&nbsp;Columns,&nbsp;Chemical&nbsp;Engineering&nbsp;Progress&nbsp;(1952)&nbsp;89&ndash;94</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de), March 2021</p>
</html>"));
end Ergun;
