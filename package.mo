within ;






































































































package TransiEnt "Library for transient simulation of integrated energy networks with a high share of renewable energies"

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





extends TransiEnt.Basics.Icons.Package;
import EnergyResource =
                TransiEnt.Basics.Types.TypeOfResource;
import PrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier;

import PrimaryEnergyCarrierHeat = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat;

import      Modelica.Units.SI
                             "Usage of Modelica Standard library unit package";
// SI = TransiEnt.Base.Units "Usage of own units package";





































































































annotation (uses(
    Modelica_StateGraph2(version="2.0.4"),
    DataFiles(version="1.0.5"),
    Design(version="1.0.7"),
    Buildings(version="7.0.0"),
    Modelica(version="4.0.0"),
    Modelica_LinearSystems2(version="2.4.0"),
    ModelicaReference(version="4.0.0"),
    TILMedia(version="1.7.0 ClaRa"),
    ClaRa(version="1.7.0"),
    DymolaCommands(version="1.11")),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-56,-4},{52,-16}},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
        radius=3,
        pattern=LinePattern.None),   Polygon(
          points={{-56,24},{-37,24},{-27,22},{-19,20},{-8,16},{6,8},{14,2},{26,
            -4},{33,-4},{47,-4},{52,-4},{52,16},{30,18},{22,22},{-6,38},{-44,48},
            {-56,48},{-56,24}},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
        pattern=LinePattern.None)}),
  Documentation(info="<html>
<p><img src=\"modelica://TransiEnt/Images/TransiEntLibraryInfo.png\"/></p>
<h4><span style=\"color: #008000\">List of developers (since 2013)</span></h4>
<p>Coordinating developers:</p>
<ul>
<li>Gillner, Markus</li>
<li>Heckel, Jan-Peter</li>
</ul>
<p>Consulting developers:</p>
<ul>
<li>Brunnemann, Johannes</li>
<li>Flesch, Robert</li>
<li>Rohde, Daniel</li>
</ul>
<p>Other developers:</p>
<ul>
<li>Andresen, Lisa</li>
<li>Babst, Jon Frederik</li>
<li>Becke, Tobias</li>
<li>Benthin, Joern</li>
<li>Bixel, Tonio</li>
<li>Bode, Carsten</li>
<li>Braune, Jan</li>
<li>Denninger, Rebekka</li>
<li>Djukow, Michael</li>
<li>Doerschlag, Arne</li>
<li>Drake, Russell</li>
<li>Dubucq, Pascal</li>
<li>Ernst, Malte</li>
<li>Gaeth, Jakobus</li>
<li>Goettsch, Patrick</li>
<li>Guddusch, Sascha</li>
<li>Hagemeier, Anne</li>
<li>Harling, Verena</li>
<li>Helbig, Christopher</li>
<li>Heyer, Annika</li>
<li>Huismann, Philipp</li>
<li>Kattelmann, Felix</li>
<li>Kernstock, Paul</li>
<li>Kirschstein, Arne</li>
<li>Knop, Inken</li>
<li>Koeppen, Arne</li>
<li>Lange, Jelto</li>
<li>Lindemann, Tom Oliver</li>
<li>Peniche Garcia, Ricardo</li>
<li>Ramm, Tobias</li>
<li>Ruppert, Stefanie</li>
<li>Schroeder, Vitja</li>
<li>Schuelting, Oliver</li>
<li>Senkel, Anne</li>
<li>Settgast, Christine</li>
<li>Toerber, Tobias</li>
<li>Urbansky, Julian</li>
<li>Wagner, Philipp</li>
<li>Webster, John</li>
<li>Westphal, Jan</li>
<li>Weilbach, Simon</li>
<li>Vojacek, Ales</li>
<li>Zaczek, Alexander</li>
</ul>
</html>"),
  version="2.0.1",
  conversion(from(version="0.3", to="1.1.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.0_to_1.1.mos"),
  from(version="1.0.1", to="1.1.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.0_to_1.1.mos"),
  from(version="1.1.0", to="1.2.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.1.0_to_1.2.0.mos"),
  from(version="1.2.0", to="1.3.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.2.0_to_1.3.0.mos"),
  from(version="1.3.0", to="2.0.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.3.1_to_2.0.0.mos"),
  from(version="1.3.1", to="2.0.0", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_1.3.1_to_2.0.0.mos"),
  from(version="2.0.0", to="2.0.1", script="modelica://TransiEnt/Scripts/ConvertTransiEnt_from_2.0.0_to_2.0.1.mos")));
end TransiEnt;








