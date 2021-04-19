within TransiEnt.Components.Boundaries.Gas;
model RealGasCompositionByWtFractions_stepVariation "Periodic discrete variation of mass fraction of first component in real gas mixture"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Integer xiNumber=1 "xi vector entry that shall be varied [1 medium.nc]";
  parameter SI.Time period = 10000 "Period for discrete step";
  parameter Real stepsize = 0.001 "Discrete stepsize for xi[xiNumber]";

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________
protected
  SI.MassFraction sumXi=sum(xi) "Control sum of set mass fractions";
public
  SI.MassFraction[medium.nc-1] xi_in(start = medium.xi_default) annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Time t_lastchange(start=0);

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
<p><span style=\"font-family: MS Shell Dlg 2;\">If an entry is zero in xi_start, it will stay zero (unless it is the one varied). If an entry is zero, this causes that the sum of all entries is not 1 in all variations but the last one (nc).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real output of mass composition vector xi[medium.nc-1] in [kg/kg]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mass composition vector xi[medium.nc-1]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">xiNumber: Position in xi vector, this mass fraction will be varied.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The last component of the mass composition vector is varied discretely with the defined stepsize. Every period the stepsize is added to the mass fraction of the last component:</span></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-afnzkFyP.png\" alt=\"xi_i=pre(xi_i)+stepsize\"/></p>
<p>If the last component (nc) is varied, the following holds:</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">As the sum of all mass fractions is equal to one, the sum of nc-1 mass fraction can be calculated via</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-xefv8Alm.png\" alt=\"pre(sum(xi_i))=1-pre(xi[nc])\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-7tASYhwY.png\" alt=\"sum(xi_i)=1-xi[nc]\"/> <img src=\"modelica://TransiEnt/Images/equations/equation-RjDWSFvX.png\" alt=\" = 1-pre(xi[nc])-stepsize\"/> <img src=\"modelica://TransiEnt/Images/equations/equation-WBEYwZlB.png\" alt=\"=pre(sum(xi_i)) - stepsize\"/> <b>(1)</b></p>
<p>for i in 1:nc-1.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For i in 1:nc-1 mass fractions, the following condition holds:</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-05QG5YDU.png\" alt=\"xi_i / sum(xi_i) = pre(xi_i) / pre(sum(xi_i)) \"/></p>
<p>Therefore, considering eq. (1) the other mass fractions can be calculated via</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-GMTOIm02.png\" alt=\"xi_i=pre(xi_i)*((pre(sum(xi_i))-stepsize)/pre(sum(xi_i)))\"/></p>
<p><br>for i in 1:nc-1.</p>
<p>If any other component is varied the new mass fractions can be calculated via</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-defjCiCI.png\" alt=\"xi_i=pre(xi_i)*((1-pre(xi_xiNumber)-stepsize)/(1-pre(xi_xiNumber)))\"/>.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
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
end RealGasCompositionByWtFractions_stepVariation;
