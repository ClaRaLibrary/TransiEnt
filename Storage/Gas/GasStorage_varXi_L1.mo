within TransiEnt.Storage.Gas;
model GasStorage_varXi_L1 "L1: Model of a simple gas storage volume for variable composition"


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

  extends Base.PartialGasStorage_L1;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else TransiEnt.Basics.Functions.findSetDifference(1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition or variableCompositionEntries[1] <> 0));
  parameter SI.MassFraction xi_gas_start[medium.nc-1]=medium.xi_default "Initial composition in the storage" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.MassFraction xi_end=1 - sum(xi_gas) "Last entry of mass fraction";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
initial equation

  if variableCompositionEntries[1] <> 0 then
    for j in variableCompositionEntries loop
      if j <> medium.nc then
        xi_gas[j] = xi_gas_start[j];
      else
        xi_end = 1 - sum(xi_gas_start);
      end if;
    end for;
  else
    xi_gas = xi_gas_start;
  end if;

equation

  if variableCompositionEntries[1] == 0 then //all components are considered fully variable
    der(m_gas)*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow));
  else
    if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
      for j in variableCompositionEntries[1:end - 1] loop
        der(m_gas)*xi_gas[j]+m_gas*der(xi_gas[j])=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow[j]))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow[j]));
      end for;
      der(m_gas)*xi_end+m_gas*der(xi_end)=gasPortIn.m_flow*(1-sum(noEvent(actualStream(gasPortIn.xi_outflow))))+gasPortOut.m_flow*(1-sum(noEvent(actualStream(gasPortOut.xi_outflow))));
      for j in dependentCompositionEntries[1:end - 1] loop
        xi_gas[j] = (1 - (sum(xi_gas[k] for k in variableCompositionEntries[1:end - 1]) + xi_end))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
      end for;
    else //the last component is calculated from the sum of the remaining
      for j in variableCompositionEntries loop
        der(m_gas)*xi_gas[j]+m_gas*der(xi_gas[j])=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow[j]))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow[j]));
      end for;
      for j in dependentCompositionEntries[1:end - 1] loop
        xi_gas[j] = (1 - sum(xi_gas[k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
      end for;
    end if;
  end if;

  gasPortOut.xi_outflow=xi_gas;
  gasPortIn.xi_outflow=xi_gas;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a model for simple gas storage for real gases with variable composition.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The specific enthalpies are passed through, there is no energy balance. The pressure is constant. The parameter <span style=\"font-family: Courier New;\">variableCompositionEntries</span> can be used in case that not all components are freely variable, e.g. when hydrogen is fed into natural gas. This reduces the number of states.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid if pressure and temperature of the gas are not of interest.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple total and component mass balances are used.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
</html>"));
end GasStorage_varXi_L1;
