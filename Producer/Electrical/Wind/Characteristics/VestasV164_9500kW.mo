within TransiEnt.Producer.Electrical.Wind.Characteristics;
record VestasV164_9500kW "Vestas model V164 8MW"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  //Record containing the data of the Vestas Windturbine model V164 with 8MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericPowerCurve(
  P_el_n=9.5e6,
    PowerCurve=[
    0,0;
2.7,0;
2.738928384,13.34895314;
3.287776413,38.96272065;
3.836624441,143.2227877;
4.385472469,330.0614694;
4.934320498,566.7094741;
5.483168526,863.6529751;
5.982121279,1171.892033;
6.406231119,1477.631313;
6.780445684,1781.93294;
7.129712611,2099.590931;
7.454031901,2423.396042;
7.753403553,2740.989569;
8.095866579,3067.814171;
8.582219515,3722.517592;
9.075628348,4409.475112;
9.524685826,5086.282389;
9.973743304,5773.182607;
10.72217243,6897.349805;
11.23926892,7596.659183;
11.6951303,8253.944752;
12.01944959,8600.407488;
12.39366416,8921.702333;
12.86766927,9226.74146;
13.4165173,9420.134;
13.96536533,9486.381689;
14.51421336,9497.576969;
15.06306138,9500;
25,9500;
25.01,0],
cut_out=25,
cut_backin=22);

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Record containing the data of the Vestas model V164 8MW</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4.Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Vestas Wind Systems A/S (http://www.homepages.ucl.ac.uk/~uceseug/Fluids2/Wind_Turbines/Turbines/V164-8MW.pdf)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end VestasV164_9500kW;
