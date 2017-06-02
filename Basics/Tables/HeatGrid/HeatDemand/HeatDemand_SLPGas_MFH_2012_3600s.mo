within TransiEnt.Basics.Tables.HeatGrid.HeatDemand;
model HeatDemand_SLPGas_MFH_2012_3600s "SLP Gas for heating and hot-Water energy demand for multi-family houses scaled to 1 J"
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
extends GenericDataTable(
relativepath="gas/HMF_Gas_1J_2012_3600s.txt",
datasource=DataPrivacy.isPublic,
constantfactor = Q_demand);

parameter SI.Energy Q_demand = 1 "Heating and hot Water demand of the multi-family houses";
  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>Extends Tools.GenericDataTable, defining MSL CombiTimeTable with data paths and interfaces. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>calculated&nbsp;by gas load&nbsp;BDEW/WKU/GEODE,&nbsp;normed&nbsp;with&nbsp;annual&nbsp;heat&nbsp;consumption&nbsp;Hamburg</p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Calculated standard load profile for multy-family houses in Hamburg.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>RealOutput y[noutCombiTimeTable]</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>This is a calculated standard load profile calculated by VDI 4655.</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(calculated profile, if possible, compare to measured profile)</p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>BDEW/WKU/GEODE Leitfaden, VDI 4655</p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end HeatDemand_SLPGas_MFH_2012_3600s;
