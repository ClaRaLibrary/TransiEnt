within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base;
function getPortSubIndex "Returns index of control volumes fluid port for input fluid connectors"
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

  import TransiEnt.Basics.Functions.findAll;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Integer N;
  input Integer i_prodIn[:];
  input Integer i_prodOut[:];
  input Integer i_gridIn[:];
  input Integer i_gridOut[:];

  output Integer portSubIdx[4,max({size(i_prodIn,1),size(i_prodOut,1),size(i_gridIn,1),size(i_gridOut,1)})];

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Integer portCount[N];
  Integer n[:];

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

    // prodIn
    n:=findAll(i, i_prodIn);
    if n[1]<>0 then
      for j in n loop
        portCount[i]:=portCount[i]+1;
        portSubIdx[1,j]:=portCount[i];
      end for;
    end if;

    // prodOut
    n:=findAll(i, i_prodOut);
    if n[1]<>0 then
      for j in n loop
        portCount[i]:=portCount[i]+1;
        portSubIdx[2,j]:=portCount[i];
      end for;
    end if;

    // gridIn
    n:=findAll(i, i_gridIn);
    if n[1]<>0 then
      for j in n loop
        portCount[i]:=portCount[i]+1;
        portSubIdx[3,j]:=portCount[i];
      end for;
    end if;

    // gridOut
    n:=findAll(i, i_gridOut);
    if n[1]<>0 then
      for j in n loop
        portCount[i]:=portCount[i]+1;
        portSubIdx[4,j]:=portCount[i];
      end for;
    end if;
  end for;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Returns index of control volumes fluid port for input fluid connectors.</p>
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
end getPortSubIndex;
