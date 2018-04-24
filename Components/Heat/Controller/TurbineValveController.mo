within TransiEnt.Components.Heat.Controller;
model TurbineValveController "Turbine valve control depending on plant control strategy (see VDI/VDE 3508, p. 22 for more details)"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  import TransiEnt.Basics.Types.ClaRaPlantControlStrategy;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Basics.Types.ClaRaPlantControlStrategy controlStrategy=ClaRaPlantControlStrategy.MSP "Control strategy for power plant";
   parameter Real m_T_set_slp_start = 0.3 "Relative mass flow at which modified pressure operation begins";
   parameter Real m_T_set_slp_end = 0.9 "Relative mass flow at which modified pressure operation ends";
   parameter Real y_T_slp = 0.9 "Constant turbine valve apparture in modified pressure operation";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________4

   Modelica.Blocks.Interfaces.RealInput P_T_set "Setpoint of turbine"  annotation (Placement(
        transformation(extent={{-102,-8},{-82,12}}, rotation=0), iconTransformation(extent={{-102,-8},{-82,12}})));

 Modelica.Blocks.Interfaces.RealOutput y_T_set "Turbine valve opening setpoint" annotation (Placement(transformation(extent={{98,24},{118,44}}, rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1D MSP_ValveAperture(table=[0.0,0.0; m_T_set_slp_start,y_T_slp; m_T_set_slp_end,y_T_slp; 1,1], final columns={2}) annotation (Placement(transformation(extent={{-6,-8},{14,12}})));

  Modelica.Blocks.Tables.CombiTable1D NSP_ValveAperture(table=[0.0,0.0; m_T_set_slp_start,1;1,1], final columns={2})
                                                                                                    annotation (Placement(transformation(extent={{-10,38},{10,58}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   // Fixed pressure operation
   if controlStrategy == ClaRaPlantControlStrategy.FP then

    y_T_set=P_T_set;

  // Natural sliding pressure operation (y_T_set constant)
  elseif controlStrategy== ClaRaPlantControlStrategy.NSP then

    y_T_set=NSP_ValveAperture.y[1];

  // Modified sliding pressure operation (y_T_set constant)
  elseif controlStrategy == ClaRaPlantControlStrategy.MSP then

    y_T_set=MSP_ValveAperture.y[1];

  else
    terminate("Fatal: Control strategy unknown!");y_T_set=0;   // terminate with error, equations are needed for model to check

  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_T_set, NSP_ValveAperture.u[1]) annotation (Line(points={{-92,2},{-84,2},{-84,2},{-74,2},{-74,48},{-12,48}}, color={0,0,127}));
  connect(P_T_set, MSP_ValveAperture.u[1]) annotation (Line(points={{-92,2},{-50,2},{-8,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TurbineValveController;
