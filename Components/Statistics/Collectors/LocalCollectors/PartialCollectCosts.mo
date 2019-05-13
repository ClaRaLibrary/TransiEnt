within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
partial model PartialCollectCosts "Partial cost collector"

  //________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

 import SI = Modelica.SIunits;

 // _____________________________________________
 //
 //        Constants and Hidden Parameters
 // _____________________________________________

 //constant Real k_J_to_MWh=1/3.6e9 "Factor to change energy unit from J to MWh";
 final parameter SI.Time timeYear = simCenter.lengthOfAYear "Time of one year";

 // _____________________________________________
 //
 //              Visible Parameters
 // _____________________________________________

  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated" annotation(Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.Time_year observationPeriod=simCenter.Duration "Observation period" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real interestRate = simCenter.InterestRate "Interest rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real priceChangeRateInv=simCenter.priceChangeRateInv "Price change rate of the invest cost" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real priceChangeRateDemand=simCenter.priceChangeRateDemand "Price change rate of the demand-related cost" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real priceChangeRateOM=simCenter.priceChangeRateOM "Price change rate of the operation-related cost" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real priceChangeRateOther=simCenter.priceChangeRateOther "Price change rate of other cost" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real priceChangeRateRevenue=simCenter.priceChangeRateRevenue "Price change rate of the revenue" annotation (Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.Time_year lifeTime=costRecordGeneral.lifeTime "Life time of the component" annotation (Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cspec_inv_der_E=costRecordGeneral.Cspec_inv_der_E "Specific invest cost per nominal power" annotation (Dialog(group="Invest Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_inv_E=costRecordGeneral.Cspec_inv_E "Specific invest cost per nominal energy capacity" annotation (Dialog(group="Invest Cost"));
  parameter Real size1=costRecordGeneral.size1 "Size 1 of the component" annotation (Dialog(group="Invest Cost"));
  parameter Real size2=costRecordGeneral.size2 "Size 2 of the component" annotation (Dialog(group="Invest Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnit C_inv_size=costRecordGeneral.C_inv_size "Invest cost depending on the size" annotation (Dialog(group="Invest Cost"));
  parameter Real factor_OM=costRecordGeneral.factor_OM "Percentage of the invest cost that represents the annual O&M cost" annotation (Dialog(group="O&M Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_OM_W_el=costRecordGeneral.Cspec_OM_W_el "Specific O&M cost per electric energy" annotation (Dialog(group="O&M Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_OM_Q=costRecordGeneral.Cspec_OM_Q "Specific O&M cost per heating energy" annotation (Dialog(group="O&M Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_OM_H=costRecordGeneral.Cspec_OM_H "Specific O&M cost per gas energy" annotation (Dialog(group="O&M Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_OM_other=costRecordGeneral.Cspec_OM_other "Specific O&M cost per other resource, e.g. water" annotation (Dialog(group="O&M Cost"));
  parameter TransiEnt.Basics.Units.MonetaryUnit C_other_fix=costRecordGeneral.C_other_fix "Fix other cost" annotation (Dialog(group="Other Cost"));

 // _____________________________________________
 //
 //              Variable Declarations
 // _____________________________________________

  //protected
  Real annuityFactor "Annuity factor";
  Real dynamicPriceFactorDemand "Price dynamic cash value factor for the demand-related cost";
  Real dynamicPriceFactorOM "Price dynamic cash value factor for the operation-related cost";
  Real dynamicPriceFactorOther "Price dynamic cash value factor for other cost";
  Real dynamicPriceFactorRevenue "Price dynamic cash value factor for the revenue";
  TransiEnt.Basics.Units.MonetaryUnit C_inv(displayUnit="EUR") "Investment costs";
  TransiEnt.Basics.Units.MonetaryUnit C_rep(displayUnit="EUR") "Replacement costs";
  TransiEnt.Basics.Units.MonetaryUnit C_res(displayUnit="EUR") "Residual value";
  TransiEnt.Basics.Units.MonetaryUnit dynamic_C_inv(displayUnit="EUR") "Annuity of the investment costs";
  //TransiEnt.Basics.Units.MonetaryUnit C_OM(displayUnit="EUR") "O&M costs";
  TransiEnt.Basics.Units.MonetaryUnit dynamic_C_OM(displayUnit="EUR") "Annuity of the operation-related costs";
  TransiEnt.Basics.Units.MonetaryUnit dynamic_C_demand(displayUnit="EUR") "Annuity of the demand-related costs";
  //TransiEnt.Basics.Units.MonetaryUnit C_other(displayUnit="EUR") "Other costs";
  TransiEnt.Basics.Units.MonetaryUnit dynamic_C_other(displayUnit="EUR") "Annuity of other costs";
  TransiEnt.Basics.Units.MonetaryUnit dynamic_C_revenue(displayUnit="EUR") "Annuity of the revenue";
  TransiEnt.Basics.Units.MonetaryUnit C(displayUnit="EUR") "Costs";

 // _____________________________________________
 //
 //                 Outer Models
 // _____________________________________________

 outer TransiEnt.SimCenter simCenter;

 replaceable model CostRecordGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost Spec record" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

 // _____________________________________________
 //
 //                Interfaces
 // _____________________________________________

 // _____________________________________________
 //
 //           Instances of other Classes
 // _____________________________________________

 CostRecordGeneral costRecordGeneral;

public
  TransiEnt.Basics.Interfaces.General.CostsCollector costsCollector annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

equation
 // _____________________________________________
 //
 //           Characteristic Equations
 // _____________________________________________

 //Annuity factor calculation
  annuityFactor = TransiEnt.Components.Statistics.Functions.annuityFactor(interestRate=interestRate, observationPeriod=observationPeriod);

 //Price dynamic cash value factor calculations
  dynamicPriceFactorDemand = TransiEnt.Components.Statistics.Functions.dynamicPriceFactor(
    interestRate=interestRate,
    priceChangeRate=priceChangeRateDemand,
    observationPeriod=observationPeriod);
  dynamicPriceFactorOM = TransiEnt.Components.Statistics.Functions.dynamicPriceFactor(
    interestRate=interestRate,
    priceChangeRate=priceChangeRateOM,
    observationPeriod=observationPeriod);
  dynamicPriceFactorOther = TransiEnt.Components.Statistics.Functions.dynamicPriceFactor(
    interestRate=interestRate,
    priceChangeRate=priceChangeRateOther,
    observationPeriod=observationPeriod);
  dynamicPriceFactorRevenue = TransiEnt.Components.Statistics.Functions.dynamicPriceFactor(
    interestRate=interestRate,
    priceChangeRate=priceChangeRateRevenue,
    observationPeriod=observationPeriod);

 //Replacement costs and residual value calculation
  (C_rep,C_res) = TransiEnt.Components.Statistics.Functions.repCostResVal(
    C_inv=C_inv,
    interestRate=interestRate,
    priceChangeRate=priceChangeRateInv,
    observationPeriod=observationPeriod,
    lifeTime=lifeTime);

 //Calculation of investment costs
 dynamic_C_inv=if calculateCost then (C_inv+C_rep-C_res)*annuityFactor/timeYear*time else 0;

 //Calculation of total costs
 C=dynamic_C_inv+dynamic_C_OM+dynamic_C_demand+dynamic_C_other+dynamic_C_revenue; //dynamic_C_revenue<=0

 //Assigning Costs to local costsCollector
 costsCollector.Costs = C;
 costsCollector.InvestCosts = dynamic_C_inv;
 costsCollector.DemandCosts = dynamic_C_demand;
 costsCollector.OMCosts = dynamic_C_OM;
 costsCollector.OtherCosts = dynamic_C_other;
 costsCollector.Revenues = dynamic_C_revenue;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                              graphics={
       Rectangle(
         extent={{-100,100},{100,-100}},
         lineColor={95,95,95},
         fillColor={255,255,255},
         fillPattern=FillPattern.Solid),                                    Text(
         extent={{-100,98},{100,132}},
         lineColor={62,62,62},
         fillColor={0,134,134},
         fillPattern=FillPattern.Solid,
         textString="%name"),            Polygon(
         points={{-10,70},{-10,-8},{-46,-8},{4,-76},{46,-8},{12,-8},{12,70},{8,70},{-10,70}},
         lineColor={0,0,0},
         fillColor={0,0,0},
         fillPattern=FillPattern.Solid), Polygon(
         points={{-14,68},{-14,-10},{-50,-10},{0,-78},{42,-10},{8,-10},{8,68},{4,68},{-14,68}},
         lineColor={0,0,0},
         fillColor={255,128,0},
         fillPattern=FillPattern.Solid)}),
                                Diagram(graphics,
                                        coordinateSystem(preserveAspectRatio=
           false, extent={{-100,-100},{100,100}})),
         defaultComponentName="collectCosts",
           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>partial model for a cost collector</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) Equations from Verein Deutscher Ingenieure e.V.: VDI 2067-1: Wirtschaftlichkeit gebaeudetechnischer Anlagen. Grundlagen und Kostenberechnung. Berlin, September 2012</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode (c.bode@tuhh.de) on 13.02.2017</span></p>
</html>"));
end PartialCollectCosts;
