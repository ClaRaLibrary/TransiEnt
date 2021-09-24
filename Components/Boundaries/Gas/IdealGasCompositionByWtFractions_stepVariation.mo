within TransiEnt.Components.Boundaries.Gas;
model IdealGasCompositionByWtFractions_stepVariation "Periodic step variation of mass fraction of last component in ideal gas mixture"


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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.TableIcon;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Constants and Parameters
  // _____________________________________________
  parameter TILMedia.GasTypes.BaseGas medium=simCenter.gasModel2 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Integer xiNumber=1 "xi vector entry that shall be varied [1 medium.nc]";
  parameter SI.Time period = 10000 "Period for discrete step";
  parameter SI.MassFraction stepsize = 0.001 "Discrete stepsize for xi[nc]";

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________
protected
  SI.MassFraction sumXi=sum(xi) "Control sum of set mass fractions";
public
  SI.MassFraction[medium.nc-1] xi_in(start = medium.xi_default)
                                                      annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Time t_lastchange(start=0)
                               annotation (Dialog(group="Initialization", showStartAttribute=true));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  TransiEnt.Basics.Interfaces.General.MassFractionOut xi[medium.nc-1] "Composition of gas to be set"
    annotation (Placement(transformation(extent={{100,0},{120,20}}),
        iconTransformation(extent={{80,-20},{120,20}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Reinitialize vectors when stepsize is period is over
  when t_lastchange>period then
    //Reinit time counter to zero
    reinit(t_lastchange,0);
    //Rescale mass fractions
    if xiNumber == 1 then
      reinit(xi_in[xiNumber], (pre(xi_in[xiNumber])+stepsize));
      reinit(xi_in[xiNumber+1:medium.nc-1], pre(xi_in[xiNumber+1:medium.nc-1])./(1-pre(xi_in[xiNumber])) .*(1-pre(xi_in[xiNumber])-stepsize));
    elseif xiNumber == medium.nc-1 then
      reinit(xi_in[xiNumber], (pre(xi_in[xiNumber])+stepsize));
      reinit(xi_in[1:xiNumber-1], pre(xi_in[1:xiNumber-1])./(1-pre(xi_in[xiNumber])) .*(1-pre(xi_in[xiNumber])-stepsize));
    elseif xiNumber == medium.nc then
      reinit(xi_in, (pre(xi_in)./sum(pre(xi_in)) .*(sum(pre(xi_in))-stepsize)));
    else
      reinit(xi_in[xiNumber], (pre(xi_in[xiNumber])+stepsize));
      reinit(xi_in[1:xiNumber-1], pre(xi_in[1:xiNumber-1])./(1-pre(xi_in[xiNumber])) .*(1-pre(xi_in[xiNumber])-stepsize));
      reinit(xi_in[xiNumber+1:medium.nc-1], pre(xi_in[xiNumber+1:medium.nc-1])./(1-pre(xi_in[xiNumber])) .*(1-pre(xi_in[xiNumber])-stepsize));
    end if;
  end when;

  //Set slope of time counter
  der(t_lastchange)=1;

  //Set slope of mass fraction vector entries
  for i in 1:medium.nc-1 loop
    der(xi_in[i]) = 0;
  end for;

  //Write values to output
  xi = xi_in;

annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Discrete variation of the mass fraction of one component of the real gas mixture. Example output for variation of xi[nc]:</span></p>
<p><img src=\"modelica://TransiEnt/Images/RealGasCompositionByWtFractions_stepVariation.png\"/></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real output of mass composition vector xi[medium.nc-1] in [kg/kg]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mass composition vector xi[medium.nc-1]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">xiNumber: Position in xi vector, this mass fraction will be varied.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The last component of the mass composition vector is varied discretely with the defined stepsize. Every period the stepsize is added to the mass fraction of the last component:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-NP0SBhXP.png\"/></span></p>
<p>If the last component (nc) is varied, the following holds:</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">As the sum of all mass fractions is equal to one, the sum of nc-1 mass fraction can be calculated via</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-xefv8Alm.png\"/></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-7tASYhwY.png\"/> <img src=\"modelica://TransiEnt/Images/equations/equation-RjDWSFvX.png\"/> <img src=\"modelica://TransiEnt/Images/equations/equation-WBEYwZlB.png\"/> <b>(1)</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">for i in 1:nc-1.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For i in 1:nc-1 mass fractions, the following condition holds:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-05QG5YDU.png\"/></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Therefore, considering eq. (1) the other mass fractions can be calculated via</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-GMTOIm02.png\"/></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">for i in 1:nc-1.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">If any other component is varied the new mass fractions can be calculated via</span></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-ABdtekyD.png\" alt=\"xi_i=pre(xi_i)*((1-xi_xiNumber-stepsize)/(1-xi_xiNumber))\"/><span style=\"font-family: MS Shell Dlg 2;\">.</span></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in check model &quot;TransiEnt.Components.Boundaries.Gas.Check.CheckStepVariationModels&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Lisa Andresen (andresen@tuhh.de), Jan 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), Dec 2016</span></p>
</html>"),                                                        Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                       graphics),
                                   Diagram(graphics));
end IdealGasCompositionByWtFractions_stepVariation;
