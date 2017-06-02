within TransiEnt.Basics.Media.Solids;
model GravelStonesSandDry "Gravel, stones, sand, dry "
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
  //[1] VDI 4640 Blatt 1: Thermische Nutzung des Untergrunds - Grundlagen, Genehmigungen, Umweltaspekte. In: Verein Deutscher Ingenieure e.V. Duesseldorf (2010)
  //[2] Grimm, Rdiger: Effiziente Loesungen fuer die Wohnungs- und Immobilienwirtschaft Beispiel: Sanierung Talstrae 5-9 in Freiberg/Sa. Bochum (2011)
  extends TILMedia.SolidTypes.BaseSolid(
    final d = 2120 "from [1], linear interpolated with lambda=0.8",
    final cp_nominal = 726.45 "from [1], linear interpolated with lambda=0.8",
    final lambda_nominal = 0.8 "from [2]");

equation
  cp=cp_nominal;
  lambda=lambda_nominal;
end GravelStonesSandDry;
