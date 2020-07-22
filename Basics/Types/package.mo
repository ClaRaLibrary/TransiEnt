within TransiEnt.Basics;
package Types "containing type definitions"
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
  extends TransiEnt.Basics.Icons.Package;

  // Constant Strings defined as environtment variables in startup script (loadTransiEnt.mos)
  constant String WORKINGDIR = "workingdir";
  constant String PUBLIC_DATA = "public-data";
  constant String PRIVATE_DATA = "private-data";
  constant String STARTUP_SCRIPT = "startupscript";











  constant Integer nTypeOfResource=6;
  constant Integer nTypeOfPrimaryEnergyCarrier=14;
  constant Integer nTypeOfPrimaryEnergyCarrierHeat=10;

  constant Integer on_ready=1;
  constant Integer off_ready=2;
  constant Integer on_blocked=3;
  constant Integer off_blocked=4;

 constant Integer off = 0;
 constant Integer on1 = 1;
 constant Integer on2 = 2;

  constant Integer N1=1;
  constant Integer N2=2;
  constant Integer N10=10;
  constant Integer N20=20;
  constant Integer N50=50;
  constant Integer N100=100;
  constant Integer N1000=1000;



  constant Integer HotWaterProfile_onePerson=1;
  constant Integer HotWaterProfile_threePerson=2;
  constant Integer HotWaterProfile_threePersonBath=3;

annotation (Icon(graphics={Polygon(
        origin={-12.167,-9},
        fillColor={128,128,128},
        fillPattern=FillPattern.Solid,
        points={{12.167,65},{14.167,93},{36.167,89},{24.167,20},{4.167,-30},{
            14.167,-30},{24.167,-30},{24.167,-40},{-5.833,-50},{-15.833,-30},{
            4.167,20},{12.167,65}},
        smooth=Smooth.Bezier,
        lineColor={0,0,0}), Polygon(
        origin={2.7403,15.6673},
        fillColor={128,128,128},
        fillPattern=FillPattern.Solid,
        points={{49.2597,22.3327},{31.2597,24.3327},{7.2597,18.3327},{-26.7403,
            10.3327},{-46.7403,14.3327},{-48.7403,6.3327},{-32.7403,0.3327},{-6.7403,
            4.3327},{33.2597,14.3327},{49.2597,14.3327},{49.2597,22.3327}},
        smooth=Smooth.Bezier)}));
end Types;
