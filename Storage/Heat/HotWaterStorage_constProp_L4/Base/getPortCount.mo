within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base;
function getPortCount "Returns vector with number of ports per control volume depending on location of fluid connectors"
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

  import TransiEnt.Basics.Functions.getNumberOfOccurences;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Integer N;
  input Integer i_prodIn[:];
  input Integer i_prodOut[:];
  input Integer i_gridIn[:];
  input Integer i_gridOut[:];
  output Integer portCount[N];

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Integer n;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
  for i in 1:N loop
    if i>1 and i<N then
    portCount[i]:=2 "Volumes in between start at 2";
    else
      portCount[i]:=1 "Volumes at ends of tank start at 1";
    end if;
    n:=getNumberOfOccurences(i, i_prodIn);
    if n<>0 then
      portCount[i]:=portCount[i]+n;
    end if;
    n:=getNumberOfOccurences(i, i_prodOut);
    if n<>0 then
      portCount[i]:=portCount[i]+n;
    end if;
    n:=getNumberOfOccurences(i, i_gridIn);
    if n<>0 then
      portCount[i]:=portCount[i]+n;
    end if;
    n:=getNumberOfOccurences(i, i_gridOut);
    if n<>0 then
      portCount[i]:=portCount[i]+n;
    end if;
  end for;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Returns&nbsp;vector&nbsp;with&nbsp;number&nbsp;of&nbsp;ports&nbsp;per&nbsp;control&nbsp;volume&nbsp;depending&nbsp;on&nbsp;location&nbsp;of&nbsp;fluid&nbsp;connectors.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model modified (extended so that it works for vectors i_xxx as well) by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end getPortCount;
