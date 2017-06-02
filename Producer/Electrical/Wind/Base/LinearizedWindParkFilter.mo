within TransiEnt.Producer.Electrical.Wind.Base;
model LinearizedWindParkFilter

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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real n = 100 "Number of turbines in park";
  parameter SI.Length z_0 = 0.3 "Surface roughness";
  parameter SI.Length h = 120 "Hub heigth";
  parameter SI.Length d = 100 "Distance between turbines";
  parameter SI.Velocity v_mean = 10 "Mean wind velocity";

  parameter Boolean scale_output = false "True, output is approx. n times higher than input";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Real a = (-60*d)/log(h/z_0)/v_mean "approximation coefficient a, see Dany2000 page 28";

  final parameter Real num1=num_1(n, a);
  final parameter Real num2=num_2(n, a);
  final parameter Real num3=num_3(n, a);
  final parameter Real den1=den_1(n, a);
  final parameter Real den2=den_2(n, a);
  final parameter Real den3=den_3(n, a);

  final parameter Real num[:]={num1,num2, num3};
  final parameter Real  den[:]={den1,den2,den3};

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_el_WindTurbine annotation (Placement(transformation(extent={{-126,-20},{-86,20}}), iconTransformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_WindPark annotation (Placement(transformation(extent={{92,-20},{132,20}}), iconTransformation(extent={{90,-20},{130,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Continuous.TransferFunction transferFunction(b=num, a=den,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=P_el_start)                                        annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));

  Modelica.Blocks.Math.Gain deNormalize(k=if scale_output then n else 1)
                                             annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________

    function num_1
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
            [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,0.706617,0.705365,0.702920,0.702590,0.740989,0.863767,0.948212,0.988284,0.997094,0.998954;4.000000,0.492514,0.494478,0.490193,0.480221,0.539858,0.759537,0.920798,0.975825,0.995605,0.998429;16.000000,0.242651,0.242726,0.228864,0.177635,0.338848,0.686925,0.886561,0.969992,0.994071,0.998028;63.000000,0.127053,0.129330,0.140467,0.000740,0.266413,0.667090,0.881189,0.968442,0.992677,0.997929;251.000000,0.066165,0.069000,0.099190,0.030980,0.244284,0.661869,0.879581,0.968047,0.992566,0.997904;1000.000000,0.033390,0.035522,0.058976,6.854278,0.238471,0.660561,0.879182,0.967947,0.992537,0.997898],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end num_1;

    function num_2
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
           [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,0.001854,0.005082,0.015059,0.042210,0.093436,0.106269,0.099288,0.022736,0.000180,0.000243;4.000000,0.001774,0.004816,0.014081,0.044391,0.105472,0.133368,0.099797,0.068316,0.000332,0.000285;16.000000,0.002821,0.009616,0.015904,0.042792,0.099097,0.130897,0.120839,0.066141,0.001916,0.000251;63.000000,0.002449,0.006887,0.020836,0.035801,0.097216,0.130674,0.119510,0.066304,0.010431,0.000242;251.000000,0.001235,0.003474,0.010793,0.006696,0.096733,0.130658,0.119623,0.066346,0.010706,0.000240;1000.000000,0.000669,0.001852,0.005302,0.788781,0.096599,0.130646,0.119640,0.066357,0.010778,0.000239],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end num_2;

    function num_3
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
    [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,0.000000,0.000002,0.000021,0.000168,0.000745,0.000238,0.000010,0.000004,0.000001,0.000001;4.000000,0.000000,0.000001,0.000014,0.000297,0.001603,0.001295,0.000007,0.000012,0.000001,0.000001;16.000000,0.000009,0.000106,0.000184,0.000383,0.001412,0.001204,0.000259,0.000006,0.000001,0.000001;63.000000,0.000021,0.000164,0.001522,0.003529,0.001350,0.001201,0.000223,0.000006,0.000002,0.000001;251.000000,0.000016,0.000135,0.001512,0.011029,0.001337,0.001202,0.000225,0.000006,0.000002,0.000001;1000.000000,0.000012,0.000099,0.001133,0.792418,0.001332,0.001202,0.000225,0.000006,0.000002,0.000001],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end num_3;

    function den_1
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
    [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000;4.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000;16.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000;63.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000;251.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000;1000.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end den_1;

    function den_2
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
    [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,0.001978,0.005379,0.016137,0.045289,0.098559,0.107486,0.099494,0.022646,0.000179,0.000244;4.000000,0.001931,0.005190,0.015500,0.051863,0.119951,0.138692,0.100100,0.068268,0.000330,0.000286;16.000000,0.007133,0.027416,0.027518,0.055882,0.117283,0.137410,0.121816,0.066051,0.001906,0.000250;63.000000,0.013680,0.038860,0.127472,0.135266,0.116379,0.137555,0.120469,0.066208,0.010391,0.000241;251.000000,0.010809,0.032061,0.125336,0.334617,0.116208,0.137641,0.120599,0.066249,0.010664,0.000239;1000.000000,0.007775,0.023106,0.095359,21.560382,0.116144,0.137655,0.120619,0.066260,0.010736,0.000238],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end den_2;

    function den_3
      input Real u1;
      input Real u2;
  protected
      Modelica.Blocks.Types.ExternalCombiTable2D tableID=
          Modelica.Blocks.Types.ExternalCombiTable2D(
             "NoName",
            "NoName",
           [0.000000,-6000.000000,-2156.288198,-774.929799,-278.495330,-100.086032,-35.969055,-12.926608,-4.645582,-1.669536,-0.600000;2.000000,0.000000,0.000002,0.000021,0.000168,0.000743,0.000237,0.000010,0.000004,0.000001,0.000001;4.000000,0.000000,0.000001,0.000014,0.000298,0.001609,0.001293,0.000007,0.000012,0.000001,0.000001;16.000000,0.000010,0.000111,0.000192,0.000385,0.001414,0.001201,0.000258,0.000006,0.000001,0.000001;63.000000,0.000022,0.000172,0.001600,0.003684,0.001350,0.001198,0.000222,0.000006,0.000002,0.000001;251.000000,0.000017,0.000143,0.001594,0.011567,0.001336,0.001198,0.000224,0.000006,0.000002,0.000001;1000.000000,0.000013,0.000107,0.001201,0.830312,0.001332,0.001198,0.000225,0.000006,0.000002,0.000001],
            Modelica.Blocks.Types.Smoothness.LinearSegments) "External table object";
  public
      output Real y;
         external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)      annotation (Library={"ModelicaStandardTables"});
    end den_3;

  parameter Real P_el_start=0 "Initial value of output (derivatives of y are zero up to nx-1-th derivative)";
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_el_WindTurbine, transferFunction.u) annotation (Line(points={{-106,0},{-30,0}}, color={0,0,127}));
  connect(deNormalize.y, P_el_WindPark) annotation (Line(points={{31,0},{68,0},{112,0}}, color={0,0,127}));
  connect(deNormalize.u, transferFunction.y) annotation (Line(points={{8,0},{2,0},{-7,0}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(visible=true,
        lineColor={160,160,164},
        fillColor={255,255,255},
        fillPattern=FillPattern.Backward,
        extent={{-80,-84},{22,4}}),
      Line(visible = true, origin={3.333,-12.667},  points = {{-83.333,34.667},{24.667,34.667},{42.667,-71.333}}, color = {0,0,127}, smooth = Smooth.Bezier),
      Polygon(visible=true,
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80,86},{-88,64},{-72,64},{-80,86}}),
      Line(visible=true,
        points={{-80,74},{-80,-94}},
        color={192,192,192}),
      Polygon(visible=true,
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-84},{68,-76},{68,-92},{90,-84}}),
      Line(visible=true,
        points={{-90,-84},{82,-84}},
        color={192,192,192}),
      Text(
        lineColor={192,192,192},
        extent={{-72,34},{82,72}},
          textString="3rd order")}),                                                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">1<b><span style=\"color: #008000;\">. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Applies a third order linear filter to the input. Can be used to filter the power output of a single turbine such that the output is as smooth at it were in a windpark of n turbines. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See Dany (2000) chapter 2.9 and 3.4.3 for details.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The amplitude spectrum is approximated by a third order transfer function. See matlab scripts in</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">\\\\transientee-sources\\matlab\\pd\\Wind\\WindParkFilter\\</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">for more details how this is done.</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] G. Dany, &ldquo;Kraftwerksreserve in elektrischen Verbundsystemen mit hohem Windenergieanteil,&rdquo; Rheinisch-Westf&auml;lische Technische Hochschule Aachen, 2000.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Wedn Apr 14 2016</span></p>
</html>"));
end LinearizedWindParkFilter;
