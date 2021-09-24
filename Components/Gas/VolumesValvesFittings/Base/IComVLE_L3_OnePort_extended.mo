within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
record IComVLE_L3_OnePort_extended "Extended ICom with inflow/outflow at ports"


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



  extends ClaRa.Basics.Records.IComVLE_L3(final N_inlet=1, final N_outlet=1);

  // The icom provides additional variables (inflow/outflow) at the ports
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in_outflow[N_inlet] "|Inlet||Fluid pointer of inlet ports" annotation (Dialog(tab="Inlet"));
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in_inflow[N_inlet] "|Inlet||Fluid pointer of inlet ports" annotation (Dialog(tab="Inlet"));
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out_outflow[N_outlet] "|Outlet||Fluid pointer of outlet ports" annotation (Dialog(tab="Outlet"));
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out_inflow[N_outlet] "|Outlet||Fluid pointer of outlet ports" annotation (Dialog(tab="Outlet"));

  ClaRa.Basics.Units.MassFraction xi_in_outflow[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition" annotation (Dialog(tab="Inlet"));
  ClaRa.Basics.Units.MassFraction xi_in_inflow[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition" annotation (Dialog(tab="Inlet"));
  ClaRa.Basics.Units.MassFraction xi_out_outflow[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition" annotation (Dialog(tab="Outlet"));
  ClaRa.Basics.Units.MassFraction xi_out_inflow[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition" annotation (Dialog(tab="Outlet"));

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>An extended version of ClaRa.Basics.Records.IComVLE_L3_OnePort which includes inflow/outflow values of specific enthalpy and composition at the ports.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(none)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Copied and changed from ClaRa.Basics.Records.IComVLE_L3_OnePort (version 1.5.1).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Robert Flesch (flesch@xrg-simulation.de), Sep 2020</span></p>
</html>"));
end IComVLE_L3_OnePort_extended;
