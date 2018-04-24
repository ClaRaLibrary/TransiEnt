within ;

























package TransiEnt "Library for transient simulation of coupled energy networks with high share of renewable energy"
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


extends TransiEnt.Basics.Icons.Package;
import EnergyResource =
                TransiEnt.Basics.Types.TypeOfResource;
import PrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier;

import PrimaryEnergyCarrierHeat = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat;

import SI = Modelica.SIunits "Usage of Modelica Standard library unit package";
// SI = TransiEnt.Base.Units "Usage of own units package";





































































































annotation (uses(
    Modelica(version="3.2.2"),
    ModelicaReference(version="3.2.2"),
    Modelica_StateGraph2(version="2.0.3"),
    DataFiles(version="1.0.4"),
    TILMedia(version="1.3.0 ClaRa"),
    Design(version="1.0.5"),
    Modelica_LinearSystems2(version="2.3.4"),
    DymolaCommands(version="1.4"),
    ClaRa(version="1.3.0")),        Icon(coordinateSystem(
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
<h4><span style=\"color: #008000\">List of developers (2013 - 2017)</span></h4>
<p>Coordinating developers:</p>
<ul>
<li>Bode, Carsten</li>
<li>Heckel, Jan-Peter</li>
<li>Schuelting, Oliver</li>
<li>Senkel, Anne</li>
</ul>
<p>Consulting developers:</p>
<ul>
<li>Brunnemann, Johannes</li>
</ul>
<p>Other developers:</p>
<ul>
<li>Andresen, Lisa</li>
<li>Becke, Tobias</li>
<li>Bixel, Tonio</li>
<li>Braune, Jan</li>
<li>Denninger, Rebekka</li>
<li>Doerschlag, Arne</li>
<li>Drake, Russell</li>
<li>Dubucq, Pascal</li>
<li>Ernst, Malte</li>
<li>Gaeth, Jakobus</li>
<li>Goettsch, Patrick</li>
<li>Guddusch, Sascha</li>
<li>Harling, Verena</li>
<li>Helbig, Christopher</li>
<li>Kattelmann, Felix</li>
<li>Kernstock, Paul</li>
<li>Kirschstein, Arne</li>
<li>Knop, Inken</li>
<li>Koeppen, Arne</li>
<li>Lange, Jelto</li>
<li>Lindemann, Tom Oliver</li>
<li>Peniche Garcia, Ricardo</li>
<li>Ramm, Tobias</li>
<li>Schroeder, Vitja</li>
<li>Toerber, Tobias</li>
<li>Wagner, Philipp</li>
<li>Weilbach, Simon</li>
<li>Zaczek, Alexander</li>
</ul>
</html>"),
  version="1.1.0",
  conversion(from(version="0.3", to="1.1.0", script="modelica://Scripts/ConvertTransiEnt_from_1.0_to_1.1.mos"),
  from(version="1.0.1", to="1.1.0", script="modelica://Scripts/ConvertTransiEnt_from_1.0_to_1.1.mos")));
end TransiEnt;





