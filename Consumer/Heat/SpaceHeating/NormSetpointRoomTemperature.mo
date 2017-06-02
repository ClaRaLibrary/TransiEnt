within TransiEnt.Consumer.Heat.SpaceHeating;
model NormSetpointRoomTemperature
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

  extends Modelica.Blocks.Sources.Constant(final k=T);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Base.RoomType_EN12831 roomType =  Base.RoomType_EN12831.appartment annotation(choicesAllMatching=true);

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.Temperature T = getTemperature(roomType);

  function getTemperature
    input Base.RoomType_EN12831 roomType;
    output SI.Temperature T;
  algorithm
    if roomType==Base.RoomType_EN12831.shoppingMall or roomType==Base.RoomType_EN12831.museum then
      T:= 273.15 + 16;
    elseif roomType==Base.RoomType_EN12831.church then
      T:= 273.15 + 15;
    elseif roomType==Base.RoomType_EN12831.bathroom then
      T:= 273.15 + 24;
    else
      T:= 273.15 + 20;
    end if;
  end getTemperature;

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
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
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end NormSetpointRoomTemperature;
