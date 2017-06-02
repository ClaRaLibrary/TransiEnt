within TransiEnt.Producer.Gas.Electrolyzer.Systems;
model ElectrolyzerAndCavern "Simple model of an electrolyzer plant and a hydrogen cavern (use with: TransiEnt.Producer.Combined.LargeScaleCHP.H2CofiringCHP)"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

   // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  ////////////// //Cavern parameters ////////////////////////////
  //Fluid finition
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2() "Medium to be used" annotation (Dialog(tab="Cavern", group="Gas Properties"));
  constant ClaRa.Basics.Units.MassFraction X_const[medium.nc - 1]=zeros(medium.nc- 1) "Constant composition: 100% hydrogen" annotation (Dialog(tab="Cavern", group="Gas Properties"));
  parameter Modelica.SIunits.Pressure p_cavern_nom=100e5 "Cavern nominal pressure" annotation (Dialog(tab="Cavern", group="Gas Properties"));
  parameter Modelica.SIunits.Temperature T_cavern=20+273.15 "cavern temperature" annotation (Dialog(tab="Cavern", group="Gas Properties"));

  //Capacity
  parameter Modelica.SIunits.Volume V_cavern=500e3 "Cavern volume" annotation (Dialog(tab="Cavern", group="Size and capacity")); //To Test ModelOptCon, remove this value
  parameter Modelica.SIunits.Volume V_cushion=(1-0.63)*V_cavern annotation (Dialog(tab="Cavern", group="Size and capacity"));
  parameter Modelica.SIunits.Volume V_initial=V_cushion annotation (Dialog(tab="Cavern", group="Size and capacity"));
  Modelica.SIunits.Mass m_cushion "cushion / base gas";

  //Load/unload massflow limits
  parameter Modelica.SIunits.MassFlowRate m_flow_max_in=10.5*(1000/3600) "Maximum mass flow into the cavern";
  parameter Modelica.SIunits.MassFlowRate m_flow_max_out=13.5*(1000/3600) "Maximum mass flow into the cavern";

  //Pressure limits
  //   parameter Modelica.SIunits.Pressure p_min=58e5 "cavern minimum pressure";
  //   parameter Modelica.SIunits.Pressure p_max=175e5 "Cavern maximum pressure";

    /////////////////  //Electrolyzer Parameters ////////////////////////////
    parameter Modelica.SIunits.Power P_nom_ely=400e6 "Nominal power capacity of the electrolyzer" annotation (Dialog(tab="Electrolyzer", group="Size and capacity")); //To Test ModelOptCon, remove this value
    parameter Real eta_ely_nom=0.7 annotation (Dialog(tab="Electrolyzer", group="Size and capacity"));

   //////Pipeline parameter
    parameter Modelica.SIunits.Length L=12e3 annotation (Dialog(tab="Hydrogen pipeline"));

    //Co-firing ratio
   parameter Real k_H2_fraction=simCenter.k_H2_fraction;

 // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

   //Fluid properties
   Modelica.SIunits.Density rho "density of stored gas";
   Modelica.SIunits.SpecificEnergy LHV=120e6; //in J/kg

   //Variables for Hydrogen co-firing
   Modelica.SIunits.HeatFlowRate Q_flow_GuD_H2;

   //Power
   Modelica.SIunits.Power P_in_ely;

   //Energy
   Modelica.SIunits.Energy E_storage;
   Modelica.SIunits.Energy E_initial;
   Modelica.SIunits.Energy E_storage_max;

  //Mass
   Modelica.SIunits.Mass m_initial "Initial mass in cavern";
   Modelica.SIunits.Mass dm_storage "Mass in cavern";
   Modelica.SIunits.Mass m_storage "Mass in cavern";
   Modelica.SIunits.Mass m_out "Mass in cavern";
   Modelica.SIunits.Mass m_in "Mass in cavern";
   Modelica.SIunits.Mass m_max_cavern "Cavern maximum mass capacity";
   //Mass flows
   Modelica.SIunits.MassFlowRate m_flow_in "Mass flow into cavern";
   Modelica.SIunits.MassFlowRate m_flow_out "Mass flow out of cavern";
   Modelica.SIunits.MassFlowRate m_flow_nom_ely "Nominal mass flow electrolyzer";
   Modelica.SIunits.MassFlowRate m_flow_ely "Mass flow electrolyzer (limited)";

   //Volume flow
   Modelica.SIunits.VolumeFlowRate V_flow_ely "Volume flow electrolizer";
   Modelica.SIunits.VolumeFlowRate V_flow_nom_ely "Volume flow electrolizer";

   Real Level;
  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

    TILMedia.VLEFluid_pT vleFluidH2(
    p=p_cavern_nom,
    T=T_cavern,
    xi=X_const,
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true) "Model of used medium (hydrogen)"
    annotation (Placement(transformation(extent={{-10,8},{10,-12}})));

    //Cost Collectors
  Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts_PtG_Ely(
    redeclare model CostRecordGeneral = Components.Statistics.ConfigurationData.StorageCostSpecs.Hydrogen,
    der_E_n=P_nom_ely,
    C_OM_fix=L*simCenter.Cinv_H2_pipe,
    P_el=P_in_ely) annotation (Placement(transformation(extent={{64,-100},{84,-80}})));

  // _____________________________________________
  //
  //               Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanOutput h2Available annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-104}),                                                                                                 iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={94,82})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_ely annotation (Placement(transformation(extent={{-72,100},{-52,120}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-62,110})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_fuel_GuD annotation (Placement(transformation(extent={{30,104},{70,144}}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={54,112})));

  // _____________________________________________
  //
  //               Equations
  // _____________________________________________

equation
  eta_ely_nom=(m_flow_nom_ely*LHV)/P_nom_ely; //calculates the electrolyzer's nominal mass flow
  m_flow_ely=eta_ely_nom*(P_in_ely/LHV); //calculates the electrolyzer's actual mass flow
  V_flow_ely=m_flow_ely/rho;
  V_flow_nom_ely=m_flow_nom_ely/rho;

 m_max_cavern=V_cavern*rho;
 rho=vleFluidH2.d;
 m_cushion=V_cushion*rho;
 //m_initial=m_cushion;
 m_initial=V_initial*rho;

 der(dm_storage)=m_flow_in-m_flow_out;
 m_storage=m_initial+dm_storage;
 der(m_out)=m_flow_out;
 der(m_in)=m_flow_in;

 Q_flow_GuD_H2=k_H2_fraction*Q_flow_fuel_GuD;

 ///////////////////////////////////////////////

 //Limiting ely Power input : m_flow_ely

  if P_set_ely >= P_nom_ely then
    P_in_ely=P_nom_ely;
  else
    P_in_ely=P_set_ely;
  end if;

 //Load cavern: m_flow_in definition

 if m_storage<=m_max_cavern then
    m_flow_in=m_flow_ely; ///load normally
 elseif m_flow_ely>=Q_flow_GuD_H2/LHV then
    m_flow_in=m_flow_out;
 else
   m_flow_in=m_flow_ely;
 end if;

//Unload cavern: m_flow_out definition
 if m_storage>=m_cushion then //if there is just enough hydrogen available
   Q_flow_GuD_H2=m_flow_out*LHV; //unload
   h2Available=true;
 elseif m_flow_in>Q_flow_GuD_H2/LHV then //send only as much mass flow out as required by CCGT-CHP
   Q_flow_GuD_H2=m_flow_out*LHV;
   h2Available=true;
 else
   m_flow_out=m_flow_in; //if less is produced, then send only that difference
   h2Available=false;
 end if;

  //EnergyCalculation
  E_initial=m_cushion*LHV;
  E_storage=m_storage*LHV;
  E_storage_max=m_max_cavern*LHV;

  Level=E_storage/E_storage_max;
  // _____________________________________________
  //
  //               Connect statements
  // _____________________________________________
  connect(modelStatistics.costsCollector, collectCosts_PtG_Ely.costsCollector);

  // _____________________________________________
  //
  //               Annotations
  // _____________________________________________

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={   Ellipse(
          extent={{-54,74},{54,-92}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-66,90},{-36,68}},
          lineColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Line(points={{-36,80},{-16,80},{-16,80},{-16,62}}, color={0,0,255}),
        Line(points={{74,82},{12,82},{12,82},{12,64}}, color={255,128,0}),
        Text(
          extent={{-60,86},{-42,72}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135},
          textString="Ely"),
        Text(
          extent={{56,90},{74,76}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135},
          textString="Ely"),
        Rectangle(
          extent={{46,94},{76,72}},
          lineColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Text(
          extent={{50,90},{74,76}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135},
          textString="GuD fuel mixer")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">This simple model simulates the behaviour of a hydrogen cavern. It should be used together with the component <a href=\"TransiEnt.Producer.Combined.LargeScaleCHP.H2CofiringCHP\">TransiEnt.Producer.Combined.LargeScaleCHP.H2CofiringCHP</a>.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The default parameters are based on the sample cavern of one of the NOW studies [1].</span></p>
<p><br><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Loading: </span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">This component takes into consideration the amount of power being sent to the electrolyzer to calculate the produced amount of hydrogen.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The cavern ist loaded as long as there is enough unused capacitiy in the cavern.</span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">Unloading:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">Hydrogen is unloaded from the cavern if there is enough hydrogen in the cavern (more than the cushion-gas) and if there is hydrogen demand.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The amount of hydrogen to be unloaded depends on the co-firing ration as defined in <span style=\"color: #0000ff;\">SimCenter.k_H2_fraction</span>.</li>
</ul>
<p><br><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Due to its simplifcation level, this model should not be used for detailed dimanesioning of underground hydrogen caverns.</span></p>
<p><span style=\"font-family: Arial,sans-serif;\">Its usage is rather recommended for large system models.</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">4. Interfaces</span></b></p>
<p>Inputs:</p>
<ul>
<li><span style=\"font-family: Arial,sans-serif;\">P_ely_set</span></li>
<li><span style=\"font-family: Arial,sans-serif;\">Q_flow_fuel_GuD</span></li>
</ul>
<p><br><span style=\"font-family: Arial,sans-serif;\">Outputs:</span></p>
<ul>
<li><span style=\"font-family: Arial,sans-serif;\">h2Available (boolean)</span></li>
</ul>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">(no elements)</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">(no equations)</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Electrolyzer Parameters:</span></p>
<ul>
<li><span style=\"font-family: Arial,sans-serif;\">P_nom_ely:</span></li>
<li><span style=\"font-family: Arial,sans-serif;\">eta_nom_ely:</span></li>
</ul>
<p><br>Cavern Parameters:</p>
<ul>
<li>medium: gas stored in the cavern (used for calculating the density)</li>
<li>V_cavern: cavern geometric volume (converted into mass via calculated density)</li>
<li>V_cushion: cushion gas volume <span style=\"font-family: MS Shell Dlg 2;\">(converted into mass via calculated density)</span></li>
<li>k_H2_fraction: co-firing ratio (Q_flow_fuel_H2/Q_flow_fuel_CH4)</li>
</ul>
<p><br><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See Check-Model XXXX.XXX.XXXX</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Stolzenburg, Klaus ; Hamelmann, Roland ; Wietschel, Martin ; Genoese, Fabio ; Michaelis, Julia ; Lehmann, Jochen ; Miege, Andreas ; Krause, Stephan ; Sponholz, Christian ; u.&nbsp;a.: <i>Integration von Wind-Wasserstoff-Systemen in das Energiesystem Abschlussbericht</i>, 2014</span></p>
<p><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Ricardo Peniche, 2016</span></p>
<p><br><br><br><br><br><br><br>Sources: </p>
</html>"));
end ElectrolyzerAndCavern;
