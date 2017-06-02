within TransiEnt.Basics.Adapters;
model MSLFluidPort_To_FluidPortMSL "Adapter between FluidPort in Modelica Standard Library and FluidPortMSL in TransiEnt Library, LA"

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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Medium.ExtraProperty C[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC) "Boundary trace substances";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
                   annotation (choicesAllMatching=true);
  Interfaces.Thermal.FluidPortMSL tFPMSL(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,-10},{108,10}}),
        iconTransformation(extent={{88,-10},{108,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a fPMSL( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}}),
        iconTransformation(extent={{-112,-10},{-92,10}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  tFPMSL.m_flow=-fPMSL.m_flow;
  tFPMSL.h_outflow=inStream(fPMSL.h_outflow);
  fPMSL.h_outflow=inStream(tFPMSL.h_outflow);
  tFPMSL.p=fPMSL.p;
  tFPMSL.Xi_outflow=inStream(fPMSL.Xi_outflow);
  fPMSL.Xi_outflow=inStream(tFPMSL.Xi_outflow);
// fPMSL.C_outflow = C;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
      Polygon(
        origin={20,0},
        lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{
            40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}),
      Polygon(
        fillColor={102,102,102},
        fillPattern=FillPattern.Solid,
        points={{-100,20},{-60,20},{-30,70},{-10,70},{-10,-70},{-30,-70},{-60,-20},
              {-100,-20}})}),       Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adapts MSL Fluid Port to TILMedia fluid port</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(set to state 0)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de)</p>
</html>"));
end MSLFluidPort_To_FluidPortMSL;
