within TransiEnt.Components.Statistics.PowerMarketModeling.MeritOrderModeling;
model MeritOrderModel_f_RE_Conventionals_Demand "Simplified electricity spot market with inputs: renewable energy generation and demand"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Model;

  //Demand
//  parameter Real  Demand=300 "MWh"annotation (Dialog(group="Demand"));

  //Offers (MW)
//  parameter Real renewablesOffer=100 "MWh" annotation (Dialog(group="Offers"));
  parameter Real nuclearOffer=0 "MWh"   annotation (Dialog(group="Offers"));
  parameter Real LigniteOffer=0 "MWh"   annotation (Dialog(group="Offers"));
//  parameter Real hardCoalOffer=100 "MWh"   annotation (Dialog(group="Offers"));
//  parameter Real gasOffer=100 "MWh"   annotation (Dialog(group="Offers"));
 // parameter Real oilOffer=0 "MWh"   annotation (Dialog(group="Offers"));

  //Offer-Price (EUR/MWh)
  parameter Real offerPriceRenewables=0 "EUR/MWh" annotation (Dialog(group="Offered Prices"));
//  parameter Real offerPriceNuclear=10 "EUR/MWh" annotation (Dialog(group="Offered Prices"));
//  parameter Real offerPriceLignite=14 "EUR/MWh" annotation (Dialog(group="Offered Prices"));
  parameter Real offerPriceHardCoal=28 "EUR/MWh" annotation (Dialog(group="Offered Prices"));
  parameter Real offerPriceGas=49 "EUR/MWh" annotation (Dialog(group="Offered Prices"));
//  parameter Real offerPriceOil=80 "EUR/MWh" annotation (Dialog(group="Offered Prices"));

  //OfferCurveVariables
  //parameter Real OfferCurve;
  //parameter Real Offer;

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy PowerPrice;

 // Real oilCondition;
  Real gasCondition;
  Real hardCoalCondition;
  Real ligniteCondition;
  Real nuclearCondition;
  Real renewablesCondition;

  //Interfaces

  Basics.Interfaces.Electrical.ElectricPowerIn renewablesOffer annotation (Placement(transformation(extent={{-140,52},{-100,92}}), iconTransformation(extent={{-140,52},{-100,92}})));

  Basics.Interfaces.Electrical.ElectricPowerIn Demand annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-122}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={2,-120})));
  Basics.Interfaces.Electrical.ElectricPowerIn hardCoalOffer annotation (Placement(transformation(extent={{-140,-58},{-100,-18}}), iconTransformation(extent={{-140,-2},{-100,38}})));
  Basics.Interfaces.Electrical.ElectricPowerIn gasOffer annotation (Placement(transformation(extent={{-140,-86},{-100,-46}}), iconTransformation(extent={{-140,-68},{-100,-28}})));
equation

// oilCondition=renewablesOffer+nuclearOffer+LigniteOffer+hardCoalOffer+gasOffer;
 gasCondition=renewablesOffer+nuclearOffer+LigniteOffer+hardCoalOffer;
 hardCoalCondition=renewablesOffer+nuclearOffer+LigniteOffer;
 ligniteCondition=renewablesOffer+nuclearOffer;
 nuclearCondition=renewablesOffer;
 renewablesCondition=0;

// if Demand>=oilCondition then
// PowerPrice=offerPriceOil;

// else
   if Demand>=gasCondition then
 PowerPrice=offerPriceGas;

 elseif Demand>=hardCoalCondition then
 PowerPrice=offerPriceHardCoal;

//  elseif Demand>=ligniteCondition then
//  PowerPrice=offerPriceLignite;
//
//  elseif Demand>=nuclearCondition then
//  PowerPrice=offerPriceNuclear;

 elseif Demand>=renewablesCondition then
 PowerPrice=offerPriceRenewables;

 else
 PowerPrice=-1; //for error identification
 end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(extent={{-70,70},{68,-72}}, lineColor={255,0,0}),
        Line(
          points={{-60,60},{-60,-60},{60,-60}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-40},{-20,-40},{-20,-20},{20,-20},{20,-10},{48,-10},{48,12},
              {60,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-56,64},{-4,30}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="EUR/MWh"),
        Text(
          extent={{24,-42},{62,-60}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="MW")}),Documentation(info="<html>
<p>Simple merit order model sketch.</p>
<p>Suggested testing procedure:</p>
<p>1. Fix the Demand (for instance : 300 MWh)</p>
<p>2. Vary the offered Renewable Energy amoung (e.g. 0 MWh, 100 MWh, 200 MWh) and see the changes in the resulting power price. As expected, the powerprice decreases with increasing RE-offer and increases with decreasing RE-offer. This is due to the fact that the Marginal costs of the RE are assumed to be zero and a variation in the RE-offer displaces the Offer-Curve according to the merit order.</p>
<p><br><br>Suggested testing procedure 2:</p>
<p>- Vary the demand between 0 and 700 and see how the price increases with increasing demand and vice versa. </p>
<p><br>Assumptions: inelastic demand, stepwise-offers (all plants of one type have the same marginal costs).</p>
<p><br>Notes: the marginal costs and the offered energy amounts were randomly chosen, these still have to be corrected to reflect the reality.</p>
<p><br>This is a passive model since it only calculates a power price. For active components which define set points based in the merit order see <a href=\"modelica://TransiEnt.Producer.Electrical.Controllers.AGC_MeritOrder\">TransiEnt.Producer.Electrical.Controllers.AGC_MeritOrder</a> and simliar components</p>
</html>"), Diagram(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MeritOrderModel_f_RE_Conventionals_Demand;
