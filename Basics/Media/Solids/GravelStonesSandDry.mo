within TransiEnt.Basics.Media.Solids;
model GravelStonesSandDry "Gravel, stones, sand, dry "
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
  //[1] VDI 4640 Blatt 1: Thermische Nutzung des Untergrunds - Grundlagen, Genehmigungen, Umweltaspekte. In: Verein Deutscher Ingenieure e.V. Duesseldorf (2010)
  //[2] Grimm, Rdiger: Effiziente Loesungen fuer die Wohnungs- und Immobilienwirtschaft Beispiel: Sanierung Talstrae 5-9 in Freiberg/Sa. Bochum (2011)
  extends TILMedia.SolidTypes.BaseSolid(
    final d = 2120 "from [1], linear interpolated with lambda=0.8",
    final cp_nominal = 726.45 "from [1], linear interpolated with lambda=0.8",
    final lambda_nominal = 0.8 "from [2]",
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);

equation
  cp=cp_nominal;
  lambda=lambda_nominal;
  nu = nu_nominal;
  E = E_nominal;
  G = G_nominal;
  beta = beta_nominal;
end GravelStonesSandDry;
