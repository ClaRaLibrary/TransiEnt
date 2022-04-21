within TransiEnt.Storage.Gas.Base;
partial model PartialGasStorage_L1



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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Storage.Gas.Base.PartialGasStorage(includeHeatTransfer=false);

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Pressure p_gas_const=20e5 "Constant pressure in the storage" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=0) if includeHeatTransfer annotation (Placement(transformation(extent={{8,-10},{28,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Real xi_in[medium.nc] "composition at inlet";
  Real xi_out[medium.nc] "composition at outlet";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
 // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  p_gas = p_gas_const;
  der(m_gas)=gasPortIn.m_flow+gasPortOut.m_flow;

  gasPortIn.p=p_gas_const;
  gasPortOut.p=p_gas_const;

  gasPortOut.h_outflow=inStream(gasPortIn.h_outflow);
  gasPortIn.h_outflow=inStream(gasPortOut.h_outflow);

  xi_in=cat(1,noEvent(actualStream(gasPortIn.xi_outflow)),{1-sum(noEvent(actualStream(gasPortIn.xi_outflow)))});
  xi_out=cat(1,noEvent(actualStream(gasPortOut.xi_outflow)),{1-sum(noEvent(actualStream(gasPortOut.xi_outflow)))});

  H_flow_in_NCV=gasPortIn.m_flow*sum(NCV*xi_in);
  H_flow_out_NCV=gasPortOut.m_flow*sum(NCV*xi_out);
  H_gas_NCV=m_gas*sum(NCV*cat(1,xi_gas,{1-sum(xi_gas)}));

  H_flow_in_GCV=gasPortIn.m_flow*sum(GCV*xi_in);
  H_flow_out_GCV=gasPortOut.m_flow*sum(GCV*xi_out);
  H_gas_GCV=m_gas*sum(GCV*cat(1,xi_gas,{1-sum(xi_gas)}));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts_Storage.costsCollector, modelStatistics.costsCollector);
  if includeHeatTransfer then
  connect(heat, fixedHeatFlow.port) annotation (Line(points={{40,0},{28,0}}, color={191,0,0}));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,12},{30,-48}},
          lineColor={0,0,0},
          textString="L1")}),                                    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a partial model for simple gas storage for real gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The specific enthalpies are passed through, there is no energy balance. The pressure is constant.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid if pressure and temperature of the gas are not of interest.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple total mass balance is used.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
</html>"));
end PartialGasStorage_L1;
