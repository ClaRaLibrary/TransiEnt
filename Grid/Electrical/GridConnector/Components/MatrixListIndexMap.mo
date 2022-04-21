within TransiEnt.Grid.Electrical.GridConnector.Components;
function MatrixListIndexMap "Mapping of connection lines between nodes defined by matrix into a loopable connection list"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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





  input Integer matrix[:,:];
  output Integer list[sum(matrix),2];
protected
  Integer matrixDim=size(matrix, 1);
  Integer listDim=sum(matrix);
  Integer count;
algorithm
  count := 0;
  for i in 1:matrixDim loop
    for j in 1:matrixDim loop
      if matrix[i, j] > 0 then
        for k in 1:matrix[i, j] loop
          count := count + 1;
          list[count, 1] := i;
          list[count, 2] := j;
          //           list[count,3]:=k;
        end for;
      end if;
    end for;
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function is used to map&nbsp;connection&nbsp;lines&nbsp;between&nbsp;nodes&nbsp;of a grid defined&nbsp;in a&nbsp;matrix&nbsp;into&nbsp;a&nbsp;loopable&nbsp;connection&nbsp;list</p>
<p>Application example: electrical transmission lines between superstructures in <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.ElectricalGrid.TransmissionGrid_ConnectionMatrix\">TransmissionGrid_ConnectionMatrix</a>:</p>
<p><br><span style=\"font-family: Courier New; color: #0000ff;\">parameter&nbsp;</span></span><span style=\"color: #ff0000;\">Integer&nbsp;connectMatrix[nRegions,nRegions]=[0,1,2,1;&nbsp;3,0,2,1;&nbsp;1,3,0,1;&nbsp;2,0,2,0]&nbsp;<span style=\"font-family: Courier New; color: #006400;\">&quot;Definition&nbsp;of&nbsp;connections&nbsp;between&nbsp;regions.&nbsp;Multiple&nbsp;transmission&nbsp;line between&nbsp;regions&nbsp;are&nbsp;possible&quot;</span></span><span style=\"color: #ff0000;\">;</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">final&nbsp;parameter&nbsp;</span></span><span style=\"color: #ff0000;\">Integer&nbsp;nTL&nbsp;=<span style=\"font-family: Courier New; color: #ff0000;\">&nbsp;sum</span>(connectMatrix)&nbsp;<span style=\"font-family: Courier New; color: #006400;\">&quot;number&nbsp;of&nbsp;transmission&nbsp;lines&quot;</span></span><span style=\"color: #ff0000;\">;</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">final&nbsp;parameter&nbsp;</span></span><span style=\"color: #ff0000;\">Integer&nbsp;connectListElectric[nTL,2]=<span style=\"font-family: Courier New; color: #ff0000;\">&nbsp;Functions.MatrixListIndexMap</span>(connectMatrix);</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">equation&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">for&nbsp;</span>i<span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;in&nbsp;</span>1:nTL<span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;loop</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #ff0000;\">connect</span>(epp[connectListElectric[i,&nbsp;1]],&nbsp;transmissionLine[i].epp_n)&nbsp;<span style=\"font-family: Courier New; color: #0000ff;\">annotation&nbsp;</span>(Line(</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;points={{-100,0},{-80,0},{-80,16},{-10,16}},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;color={28,108,200},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thickness=0.5));</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #ff0000;\">connect</span>(epp[connectListElectric[i,&nbsp;2]],&nbsp;transmissionLine[i].epp_p)&nbsp;<span style=\"font-family: Courier New; color: #0000ff;\">annotation&nbsp;</span>(Line(</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;points={{-100,0},{86,0},{86,16},{10,16}},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;color={28,108,200},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thickness=0.5));</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">end&nbsp;for</span>;</p>
<p><br><b></p><p><br><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">input&nbsp;</span><span style=\"color: #ff0000;\">&nbsp;Integer</span>&nbsp;matrix[:,:];</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">output&nbsp;</span><span style=\"color: #ff0000;\">Integer</span>&nbsp;list[<span style=\"font-family: Courier New; color: #ff0000;\">sum</span>(matrix),2];</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Ale&scaron; Voj&aacute;ček (vojacek@xrg-simulation.de), 06.09.2021</p>
</html>"));
end MatrixListIndexMap;
