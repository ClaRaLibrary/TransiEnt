within TransiEnt.Producer.Electrical.Conventional;
model BrownCoal "Preconfigured brown coal plant"

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

  extends TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant(
                                                                                isSecondaryControlActive=true,
    P_el_n=
          simCenter.generationPark.P_el_n_BCG,
    P_min_star=simCenter.generationPark.P_min_star_BCG,
    P_grad_max_star=simCenter.generationPark.P_grad_max_star_BCG,
    H =  simCenter.generationPark.H_gen_ST,
    eta_total=simCenter.generationPark.eta_el_n_BCG,
    final typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional,
    P_el_grad_max_SB=simCenter.generationPark.P_grad_max_star_BCG,
    final typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BrownCoal,
    t_startup=3600,
    isPrimaryControlActive=true,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal,
    PartloadEfficiency(EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.SteamturbinePlant()));

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-44,-82},{16,-22}},
          textString="NLTI"),
        Ellipse(
          extent={{-96,12},{-56,-26}},
          lineColor={162,97,59},
          fillColor={127,75,12},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-90,22},{-64,0}},
          lineColor={162,97,59},
          fillColor={127,75,12},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-70,12},{-56,0}},
          lineColor={162,97,59},
          fillColor={127,75,12},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Turbine model with startup time and setpoint limits. </span></p>
<p>Preconfigured brown coal plant.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Level of Detail depends on the used component models</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is a composition of a turbine model, an inertia model, a generator model with excitation system model and a primary controller.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See base class TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant for more information  </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for electric power in [W] (setpoint for electric power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for electric power in [W] (secondary balancing setpoint)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port (choice of power port)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Only one model of the base class needs to be checked</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end BrownCoal;
