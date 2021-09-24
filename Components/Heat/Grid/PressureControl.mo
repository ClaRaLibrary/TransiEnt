within TransiEnt.Components.Heat.Grid;
model PressureControl "ClaRa pump regulated by pressure in heat grid"
  extends TransiEnt.Basics.Icons.Model;


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
  extends TransiEnt.Basics.Icons.Pump;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Pressure dp_target=simCenter.p_nom[2]-simCenter.p_nom[1] "Target pressure drop for consumers";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=Medium) "fluidport supply on consumer side" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=Medium) "fluidport return on consumer side" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump_L1_simple(
    medium=Medium,
    eta_mech=1,
    showData=false) annotation (Placement(transformation(extent={{22,10},{42,-10}})));

  ClaRa.Components.Sensors.SensorVLE_L1_p returnPressureSensor(medium=Medium) annotation (Placement(transformation(extent={{104,-92},{84,-72}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p supplyPressureSensor1(medium=Medium) annotation (Placement(transformation(extent={{104,-50},{84,-70}})));
  Modelica.Blocks.Math.Add3 add(
    k1=+1,
    k2=+1,
    k3=-1) annotation (Placement(transformation(extent={{66,-59},{42,-83}})));
  Modelica.Blocks.Sources.Constant const(k=dp_target)       annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={81,-71})));
  Modelica.Blocks.Continuous.PI PI(T=1,
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    x_start=1000,
    y_start=1000)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-40})));
equation
  connect(waterPortIn, returnPressureSensor.port) annotation (Line(
      points={{-100,0},{-42,0},{-42,-94},{94,-94},{94,-92}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(waterPortOut, supplyPressureSensor1.port) annotation (Line(
      points={{100,0},{94,0},{94,-50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(returnPressureSensor.p, add.u1)
                                       annotation (Line(
      points={{83,-82},{84,-82},{84,-80.6},{68.4,-80.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(supplyPressureSensor1.p, add.u3)
                                        annotation (Line(
      points={{83,-60},{84,-60},{84,-61.4},{68.4,-61.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u2, const.y) annotation (Line(
      points={{68.4,-71},{75.5,-71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.u, add.y) annotation (Line(
      points={{32,-52},{32,-71},{40.8,-71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.y, pump_L1_simple.P_drive) annotation (Line(
      points={{32,-29},{32,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump_L1_simple.outlet, supplyPressureSensor1.port) annotation (Line(
      points={{42,0},{94,0},{94,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(waterPortIn, waterPortIn) annotation (Line(
      points={{-100,0},{-100,0}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(pump_L1_simple.inlet, waterPortIn) annotation (Line(
      points={{22,0},{-100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(waterPortOut, waterPortOut) annotation (Line(
      points={{100,0},{100,6},{100,6},{100,0}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pump regulated by fixed target pressure difference in hydraulic grid. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fPReturnConsumer, fPSupplyConsumer - fluid ports</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Arne Koeppen (arne.koeppen@tuhh.de) June 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Lisa Andresen (andresen@tuhh.de) October 2014</span></p>
</html>"));
end PressureControl;
