within TransiEnt.Producer.Electrical.Others;
model PumpedStoragePlant "Pumped storage plant model without consideration of capacity limits but with six operating states"


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
    P_el_n=simCenter.generationPark.P_el_n_PS,
    P_grad_max_star=simCenter.generationPark.P_grad_max_star_PS,
    P_min_star=simCenter.generationPark.P_min_star_PS,
    H=simCenter.generationPark.H_gen_HT,
    isSecondaryControlActive=true,
    isPrimaryControlActive=false,
    redeclare TransiEnt.Components.Turbogroups.Hydroturbine Turbine(P_n=P_el_n, P_turb_init=P_init_set),
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PumpedStorage,
    final typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Others);
  extends TransiEnt.Basics.Icons.Hydroturbine;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
    <p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
    <p><span style=\"font-family: MS Shell Dlg 2;\">Turbine model with startup time and setpoint limits. </span></p>
<p>Pumped storage plant model without consideration of capacity limits but with six operating states.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
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
<p>Tested in the check models &quot;TransiEnt.Producer.Electrical.Others.Check.TestPumpedStoragePlant_Gradients&quot; and &quot;TransiEnt.Producer.Electrical.Others.Check.TestPumpedStoragePlant&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PumpedStoragePlant;
