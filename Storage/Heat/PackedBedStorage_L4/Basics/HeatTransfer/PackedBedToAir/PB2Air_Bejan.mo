within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir;
model PB2Air_Bejan "PB2Air - Bejan Correlation"



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

   import SI = ClaRa.Basics.Units;

  extends TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.HeatTransferBasePB2Air;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Length lx_set = if inlet then geo.max_height[1]/2 else geo.max_height[iCom.N_cv]/2 "Penetration length set by user (must be adopted to lx_check manually!)";

  final parameter Real x_rel = min(0.25,lx_set/geo.length) "Penetration length of heat flux in relation to storage length (should be lower than 0.25)" annotation (Dialog(group="Heat Transfer"));

  final parameter Integer N_cv_eff = integer(ceil(x_rel*iCom.N_cv)) "Number of effected cells";
  final parameter Integer N_cv_den = integer(N_cv_eff*(N_cv_eff+1)/2) "denumerator for partition function";

  final parameter Real weight[iCom.N_cv] = if inlet then
cat(  1,
      {(N_cv_eff+1-i)/(N_cv_den) for i in 1:N_cv_eff},
      {0 for i in N_cv_eff+1:iCom.N_cv})
 else
cat(  1,
      {0 for i in 1:iCom.N_cv-N_cv_eff},
      {(i-(iCom.N_cv-N_cv_eff))/(N_cv_den) for i in iCom.N_cv-N_cv_eff+1:iCom.N_cv}) "Weights for each cell";
     //outlet

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

    outer TILMedia.Gas_ph fluid[iCom.N_cv];

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real beta "Thermal expansion coefficient";

  Real alpha_m "thermal diffusion coefficient according to Nield page 223";

  Real Ra "Rayleigh number according to Nield page 334 with Delta T and H from page 367";

  SI.Length lx_check "Penetration length (see Reference for more detail)";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  T_mean = iCom.T;

  if inlet then

    beta = 1/T_mean[1];

    alpha_m = iCom.lambda_eff_ax[1]/(fluid[1].d*fluid[1].cp);

      Ra = Modelica.Constants.g_n*beta*iCom.permeability*geo.max_height[1]*abs(T_mean[1] - heat[1].T)/((fluid[1].transp.eta/fluid[1].d)*alpha_m);

      alpha = 0.319*iCom.lambda_eff_ax[1]*sqrt(Ra)/geo.max_height[1];

      lx_check = noEvent(min(geo.length/4,0.158*geo.max_height[1]*sqrt(Ra)));

  else
    //outlet

    beta = 1/T_mean[iCom.N_cv];

    alpha_m = iCom.lambda_eff_ax[iCom.N_cv]/(fluid[iCom.N_cv].d*fluid[iCom.N_cv].cp);

      Ra = Modelica.Constants.g_n*beta*iCom.permeability*geo.max_height[iCom.N_cv]*abs(T_mean[iCom.N_cv] - heat[iCom.N_cv].T)/((fluid[iCom.N_cv].transp.eta/fluid[iCom.N_cv].d)*alpha_m);

      alpha = 0.319*iCom.lambda_eff_ax[iCom.N_cv]*sqrt(Ra)/geo.max_height[iCom.N_cv];

      lx_check = noEvent(min(geo.length/4,0.158*geo.max_height[iCom.N_cv]*sqrt(Ra)));

  end if;

  if inlet then

    for i in 1:iCom.N_cv loop
      heat[i].Q_flow = weight[i]*alpha*geo.A_cross_bed[1]*(heat[1].T - T_mean[1]);
    end for;

  else
    //outlet

    for i in 1:iCom.N_cv loop
      heat[i].Q_flow = weight[i]*alpha*geo.A_cross_bed[iCom.N_cv]*(heat[iCom.N_cv].T - T_mean[iCom.N_cv]);
    end for;

  end if;

  annotation (Icon(graphics), Diagram(graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Heat Transfer Correlation for packed bed to adjacent air volume according to Bejan et al. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The correlation is derived for a lateral fluid penetration due to natural convection into a porous structure from the side. </p>
<p>A weighting function is introduced in order to distribute the transferred heat to the different finite volumes inside the packed bed. </p>
<p>It need the penetration length as parameter, which thus has to be iteratively corrected.</p>
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
<p>D.A.&nbsp;Nield,&nbsp;A.&nbsp;Bejan,&nbsp;Convection&nbsp;in&nbsp;porous&nbsp;media,&nbsp;4th&nbsp;ed.,&nbsp;Springer,&nbsp;New&nbsp;York,&nbsp;2013., page 366</p>
<p>A. Bejan. &ldquo;Lateral Intrusion of Natural Convection into a Horizontal Porous Structure.&rdquo; In: Journal of Heat Transfer 103 (1981), pages 237&ndash;241.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end PB2Air_Bejan;
