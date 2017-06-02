within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
model VolumeRealGas_L4_constXi "A 1D tube-shaped control volume considering one-phase and two-phase heat transfer in a straight pipe with static momentum balance and simple energy balance."

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

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import ClaRa.Basics.Functions.Stepsmoother;
  outer TransiEnt.SimCenter simCenter;

//____Media Data_____________________________________________________________________________________
public
 parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.gasModel1 "|Fundamental Definitions|Medium in the component";

//____Physical Effects_____________________________________________________________________________________

public
  inner parameter Boolean frictionAtInlet=false "|Fundamental Definitions|True if pressure loss between first cell and inlet shall be considered"
                                                                                            annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtOutlet=false "|Fundamental Definitions|True if pressure loss between last cell and outlet shall be considered"
                                                                                            annotation (choices(checkBox=true));
//   inner parameter FlowModelStructure FlowModel=FlowModelStructure.inlet_innerPipe_outlet "|Fundamental Definitions|Structure of flow model"
//                                                        annotation(choicesAllMatching);

  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "|Fundamental Definitions|Pressure loss model at the tubes side"
    annotation(choicesAllMatching);

  replaceable model HeatTransfer =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "|Fundamental Definitions|Heat transfer mode at the tubes side"
   annotation(choicesAllMatching);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv "|Geometry|Pipe geometry"
   annotation(choicesAllMatching);

//____Nominal Values_________________________________________________________________________________
public
 parameter SI.Pressure p_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "|Nominal Values|Nominal pressure";
 parameter SI.SpecificEnthalpy h_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "|Nominal Values|Nominal specific enthalpy for single tube";
 inner parameter SI.MassFlowRate m_flow_nom=100 "|Nominal Values|Nominal mass flow w.r.t. all parallel tubes";
 inner parameter SI.PressureDifference Delta_p_nom=1e4 "|Nominal Values|Nominal pressure loss w.r.t. all parallel tubes";
 inner parameter SI.MassFraction xi_nom[medium.nc-1]=medium.xi_default "|Nominal Values|Nominal composition";
 final parameter SI.Density rho_nom[geo.N_cv]=TILMedia.VLEFluidFunctions.density_phxi(
      vleFluidType=medium,
      p=p_nom,
      h=h_nom,
      xi=xi_nom) "|Nominal Values|Nominal density";

//____Initialisation_____________________________________________________________________________________
  parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.steadyState "|Initialisation||type of initialisation "
                                                annotation(choicesAllMatching);
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialisation||true, if homotopy method is used during initialisation";
  parameter SI.SpecificEnthalpy h_start[geo.N_cv]=ones(geo.N_cv)*800e3 "|Initialisation||Initial specific enthalpy for single tube";
  parameter SI.Pressure p_start[geo.N_cv]=ones(geo.N_cv)*1e5 "|Initialisation||Initial pressure";
  //parameter SI.MassFlowRate m_flow_start[geo.N_cv+1]=ones(geo.N_cv+1)*100 "|Initialisation||Initial mass flow rate";

protected
  parameter SI.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";

//## V A R I A B L E   P A R T#######################################################################################

//____Energy / Enthalpy_________________________________________________________________________________________
protected
  SI.SpecificEnthalpy h[geo.N_cv](start=h_start, stateSelect=StateSelect.prefer) "Cell enthalpy";

//____Pressure__________________________________________________________________________________________________
 SI.Pressure p[geo.N_cv](start=p_start_internal) "Cell pressure";
 SI.PressureDifference Delta_p_fric[geo.N_cv + 1] "Pressure difference due to friction";
 SI.PressureDifference Delta_p_grav[geo.N_cv + 1] "pressure drop due to gravity";

//____Mass and Density__________________________________________________________________________________________
  SI.Mass mass[geo.N_cv] "Mass of fluid in cells";
  SI.Mass mass_FM[geo.N_cv + 1]=cat(
      1,
      {mass[1]/2},
      {(mass[i] + mass[i - 1])/2 for i in 2:geo.N_cv},
      {mass[geo.N_cv]/2}) "Mass of fluid in flow cells";
  Real drhodt[geo.N_cv];//(unit="kg/(m3s)")
  //SI.MassFraction steamQuality[geo.N_cv] "Steam fraction";
  //SI.MassFraction steamQuality_inlet "Steam fraction";
  //SI.MassFraction steamQuality_outlet "Steam fraction";

//____Flows and Velocities______________________________________________________________________________________
  SI.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  SI.MassFlowRate m_flow[geo.N_cv + 1](nominal=ones(geo.N_cv + 1)*m_flow_nom, start=ones(geo.N_cv + 1)*m_flow_nom);
  SI.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  SI.Velocity w_inlet "flow velocity at inlet";
  SI.Velocity w_outlet "flow velocity at outlet";

//____Connectors________________________________________________________________________________________________
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat[geo.N_cv]
    annotation (Placement(transformation(extent={{-10,30},
            {10,50}}),          iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={0,40})));

//___Instantiation of Replaceable Models___________________________________________________________________________
public
  PressureLoss pressureLoss "Pressure loss model"  annotation(Placement(transformation(extent={{-40,0},
            {-20,20}})));
  HeatTransfer heatTransfer(A_heat=geo.A_heat_CF[:,1]) "heat transfer model"
                            annotation(Placement(transformation(extent={{-80,0},
            {-60,20}})));
protected
  inner TILMedia.VLEFluid_ph gasOut(
    p=gasPortOut.p,
    vleFluidType=medium,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-30},{90,-10}}, rotation=0)));

protected
  inner TILMedia.VLEFluid_ph gasBulk[geo.N_cv](
    p=p,
    h=h,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    each xi=actualStream(gasPortIn.xi_outflow),
    each deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-40},{10,-20}}, rotation=0)));

  inner TILMedia.VLEFluid_ph gasIn(
    p=gasPortIn.p,
    vleFluidType=medium,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner ClaRa.Basics.Records.IComVLE_L3_OnePort iCom(
    mediumModel=medium,
    N_cv=geo.N_cv,
    volume=geo.volume,
    p_in={gasPortIn.p},
    T_in={gasIn.T},
    xi_in={gasIn.xi},
    m_flow_in={gasPortIn.m_flow},
    h_in={gasIn.h},
    p_out={gasPortOut.p},
    T_out={gasOut.T},
    xi_out={gasOut.xi},
    m_flow_out={gasPortOut.m_flow},
    h_out={gasOut.h},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom[1],
    xi_nom=xi_nom,
    T=gasBulk.T,
    p=p,
    h=h,
    xi=gasBulk.xi,
    fluidPointer_in={gasIn.vleFluidPointer},
    fluidPointer_out={gasOut.vleFluidPointer},
    fluidPointer=gasBulk.vleFluidPointer) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));
protected
  inner Geometry geo annotation (Placement(transformation(extent={{0,0},{20,20}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
//initialisation

initial equation
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h)=zeros(geo.N_cv);
    der(p)=zeros(geo.N_cv);
  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=zeros(geo.N_cv);
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=zeros(geo.N_cv);
  end if;

equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

//-------------------------------------------
//flow velocities at inlet and outlet
  w_inlet=gasPortIn.m_flow/(geo.A_cross_FM[1]*gasIn.d);
  w_outlet=-gasPortOut.m_flow/(geo.A_cross_FM[geo.N_cv + 1]*gasOut.d);
  //steamQuality_inlet=gasIn.q;
  //steamQuality_outlet=gasOut.q;

//flow velocities in cells
  for i in 1:geo.N_cv loop
     w[i]=(m_flow[i] + m_flow[i + 1])/(2*gasBulk[i].d*geo.A_cross[i]);
     //steamQuality[i]=gasBulk[i].q;
  end for;

//-------------------------------------------
//data exchange with friction model
  m_flow[1]=gasPortIn.m_flow;
  m_flow[geo.N_cv+1]=-gasPortOut.m_flow;
  m_flow=pressureLoss.m_flow;

//-------------------------------------------
//data exchange with heat transfer model
  heatTransfer.m_flow=m_flow;

//-------------------------------------------
//pressure drop due to friction, gravity

    Delta_p_fric = pressureLoss.Delta_p;
  if geo.N_cv==1 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[2] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = gasBulk[1].d*g_n*(geo.z_out - geo.z[1]);
    end if;
  elseif geo.N_cv==2 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = gasBulk[2].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[3] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_grav[3] = gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[2].d*geo.Delta_x[2] + gasBulk[1].d*geo.Delta_x[1]/2)/(geo.Delta_x[1]/2+geo.Delta_x[2])*g_n*(geo.z_out - geo.z[1]);
      Delta_p_grav[3] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_grav[3] = gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
    end if;
  else
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] = (gasBulk[i].d*geo.Delta_x[i] + gasBulk[i - 1].d*geo.Delta_x[i - 1])/(geo.Delta_x[i - 1]+geo.Delta_x[i])*g_n*(geo.z[i] - geo.z[i-1]);
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] = gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
    else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
    end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] = gasBulk[geo.N_cv].d*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv] = (gasBulk[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1] + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1] + geo.Delta_x[geo.N_cv])*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv-1]);
    else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] = (gasBulk[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1]/2 + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1]/2+geo.Delta_x[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv-1]);
    end if;
  end if;

//-------------------------------------------
//Enthalpy flows
  for i in 2:geo.N_cv loop
    H_flow[i] = if useHomotopy then homotopy(semiLinear(
      m_flow[i],
      h[i - 1],
      h[i]), h[i - 1]*m_flow_nom) else semiLinear(
      m_flow[i],
      h[i - 1],
      h[i]);
  end for;
  H_flow[1] = if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    h[1]), inStream(gasPortIn.h_outflow)*m_flow_nom) else semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    h[1]);
  H_flow[geo.N_cv + 1] = if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    inStream(gasPortOut.h_outflow)), h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    inStream(gasPortOut.h_outflow));

//-------------------------------------------
//Fluid mass in cells
  mass =if useHomotopy then homotopy(geo.volume .* gasBulk.d, geo.volume .* rho_nom) else geo.volume .* gasBulk.d;

//-------------------------------------------
// definition of the cells' states:
  for i in 1:geo.N_cv loop

  der(h[i])= (H_flow[i]- H_flow[i+1]
              + heat[i].Q_flow
              + der(p[i])*geo.volume[i]
              - h[i]*geo.volume[i]*drhodt[i])/mass[i];

  drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";
    gasBulk[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*gasBulk[i].drhodh_pxi) "Calculate pressure from enthalpy and density derivative";

  end for;

//-------------------------------------------
// Static momentum balance:
// notice that for a static momentum balance we need to apply the same balance as homotopy start equation. Otherwise the equations become trivial.
// For now we leave the homotopy inside for future development
for i in 2:geo.N_cv loop
    0 =if useHomotopy then homotopy(p[i-1] - p[i] - Delta_p_fric[i] -Delta_p_grav[i],p[i-1] - p[i] - Delta_p_fric[i] -Delta_p_grav[i]) else p[i-1] - p[i]- Delta_p_fric[i] -Delta_p_grav[i];
end for;
  gasPortIn.h_outflow = h[1];
  gasPortOut.h_outflow = h[geo.N_cv];

//enable / disable pressure losses due to friction for flows  inlet --> first cell / last cell --> outlet
if not frictionAtInlet and not frictionAtOutlet then //no friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
    gasPortIn.p =gasBulk[1].p + Delta_p_grav[1];
    gasPortOut.p =gasBulk[geo.N_cv].p - Delta_p_grav[geo.N_cv + 1];

elseif frictionAtInlet and not frictionAtOutlet then //friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
  0 =if useHomotopy then homotopy(gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
    gasPortOut.p =gasBulk[geo.N_cv].p - Delta_p_grav[geo.N_cv + 1];

elseif  not frictionAtInlet and frictionAtOutlet then//"no friction pressure loss inlet->first cell / friction pressure loss last cell->outlet"
  0 =if useHomotopy then homotopy(p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];
    gasPortIn.p =gasBulk[1].p + Delta_p_grav[1];

else //friction pressure loss inlet->first cell / friction pressure loss last cell->outlet
  0 =if useHomotopy then homotopy(gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
  0 =if useHomotopy then homotopy(p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];

end if;

//-------------------------------------------
//xi
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);

  annotation (defaultComponentName="volume",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},
            {140,50}}),
                   graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
          Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a model for a discretized volume for real gas flows with constant compositions. It is a modified version of the model ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 from ClaRa version 1.0.1 and it got updated to version 1.2.1 except for the initType. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Only valid if changes in density and the two-phase region of the fluid can be neglected.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end VolumeRealGas_L4_constXi;
