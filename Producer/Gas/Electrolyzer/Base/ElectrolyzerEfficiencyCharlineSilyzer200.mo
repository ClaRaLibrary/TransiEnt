within TransiEnt.Producer.Gas.Electrolyzer.Base;
model ElectrolyzerEfficiencyCharlineSilyzer200 "Efficiency charline for Silyzer 200"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  //charline approximated from data from Siemens for P_el_n = 3.75e6 W and eta_nom = 0.636; k_olp = 1.6;

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline(eta_n_cl=0.62903);

  /*parameter SI.Efficiency eta_start(
    min=0,
    max=1)=0.75 "Start value for eta";

initial equation 
  eta=eta_start;*/

equation
  // Calculating the efficency
  //eta_cl = 0.06655*(P_el/P_el_n)^2 - 0.2741*(P_el/P_el_n) + 0.8709 - 0.03432/max(P_el/P_el_n,1e-5); //division by zero
  //eta_cl*(P_el/P_el_n) = 0.06655*(P_el/P_el_n)^3 - 0.2741*(P_el/P_el_n)^2 + 0.8709*(P_el/P_el_n) - 0.03432;
  if noEvent(P_el/P_el_n<0.04) then
    eta_cl=0; //to avoid negative values for eta_cl
  else
    eta_cl*(P_el/P_el_n) = 0.06655*(P_el/P_el_n)^3 - 0.2741*(P_el/P_el_n)^2 + 0.8709*(P_el/P_el_n) - 0.03432;
  end if;

  // Calculating the output efficency
  eta = (eta_n/eta_n_cl - eta_scale * P_el/P_el_n) * eta_cl;

  annotation (
  defaultConnectionStructurallyInconsistent=true,Icon(graphics={Line(
          points={{-90,-40},{-82,0},{-70,42},{-38,48},{-6,24},{40,10},{94,4}},
          color={255,0,0},
          smooth=Smooth.Bezier)}),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a model for the efficiency curve of a Silyzer 200 electrolyzer. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The curve can be modified by setting the nominal efficiency eta_n and a linear factor eta_cl. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>[1] Schoenberger, D. (2016). P2G durch Elektrolyse – eine flexible Speicherloesung ... will challenge the energy industry. Zuerich: Siemens AG. </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in March 2017<br> </p>
</html>"));
end ElectrolyzerEfficiencyCharlineSilyzer200;
