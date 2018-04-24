within TransiEnt.Grid.Heat.HeatGridControl.Base.DHGHeatFlowDivisionCharacteristicLines;
record SampleHeatFlowCharacteristicLines4Units
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends GenericHeatFlowDivisionCharacteristicLines(
          CL_HeatFlow_DHG=[
0,0,0,0,0;
100e6,100e6,0,0,0;
385e6,100e6,285e6,0,0;
545e6,100e6,285e6,160e6,0;
705e6,100e6,285e6,160e6,160e6;
900e6,100e6,285e6,160e6,160e6]);
//Heat flow trimming of four heat producing units Gesamt. Source: HEW 1995

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<pre>Mass flow characteristic lines  in t/h. u[i] = Total mass flow; y[1]=East; y[2]=West; y[3]=Center(Hafen); y[4]=Center(WUW-SPS). 

Merged from two different sources: 
[1]Beecken, Jens ; Ridder, Mathias ; Schaper, Hartwig ; Sch&ouml;ttker, Peter ; Micus, Wolfgang ; Rogalla, Bernd-Uwe ; Feuerriegel, Susanne: Verbundprojekt &bdquo;KWK-Optimierung Band 5&ldquo;, 2007 (Klopsch2007)
[2] Teilprojekt Hannover-Hamburg: &bdquo;Analyse des Regelverhaltens von Fernw&auml;rmenetzen&ldquo; / Pilotprojekt Hannover / Pilotprojekt Hamburg. Hamburg, 2000 (Beecken2000)</pre>
</html>"));
end SampleHeatFlowCharacteristicLines4Units;
