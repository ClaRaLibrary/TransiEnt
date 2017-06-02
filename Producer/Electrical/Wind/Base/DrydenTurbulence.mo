within TransiEnt.Producer.Electrical.Wind.Base;
block DrydenTurbulence "Block for statistical turbulence data based on Modelica"
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
  import SI = Modelica.SIunits;
  import Modelica.Constants.pi;

  parameter SI.Time t = 0.4 "=V/L in dryden turbulence model";

  parameter SI.Velocity sigma = 0.1 *   30 * 0.5144
    "Turbulence intensity (try 0.1 * wind_speed)";

  Modelica.Blocks.Continuous.TransferFunction Hw(b=sigma*sqrt(1/pi/t)*{sqrt(3)*
        1/t,1}, a={1/t^2,2*1/t,1},
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Transfer function of vertical turbulence speed according to MIL-F-8785C"
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Modelica.Blocks.Noise.BandLimitedWhiteNoise whiteNoise(samplePeriod=
       0.005)
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Modelica.Blocks.Interfaces.RealOutput delta_v_turb annotation (Placement(transformation(extent={{94,-10},{114,10}})));
equation
  connect(whiteNoise.y,Hw. u) annotation (Line(
      points={{-15,0},{12,0}},
      color={0,0,127}));
  connect(Hw.y, delta_v_turb) annotation (Line(points={{35,0},{104,0}}, color={0,0,127}));
  annotation (Icon(graphics={
        Line(visible = enableNoise,
           points={{-76,-31},{-62,-31},{-62,-15},{-54,-15},{-54,-63},{-46,-63},{-46,-41},{-38,-41},{-38,43},{-30,43},{-30,11},{-30,11},{-30,-49},{-20,-49},{-20,-31},{-10,-31},{-10,-59},{0,-59},{0,23},{6,23},{6,37},{12,37},{12,-19},{22,-19},{22,-7},{28,-7},{28,-37},{38,-37},{38,35},{48,35},{48,1},{56,1},{56,-65},{66,-65}}),
        Polygon(
          points={{94,-26},{72,-18},{72,-34},{94,-26}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-26},{72,-26}},
                                      color={192,192,192}),
        Polygon(
          points={{-76,78},{-84,56},{-68,56},{-76,78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,56},{-76,-52}}, color={215,215,215})}));
end DrydenTurbulence;
