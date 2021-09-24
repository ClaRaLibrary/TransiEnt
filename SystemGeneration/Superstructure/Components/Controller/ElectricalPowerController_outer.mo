within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ElectricalPowerController_outer "Controller for superstructure masks, currently supports only 2 types of power plants"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  outer TransiEnt.SimCenter simCenter;
  extends TransiEnt.Basics.Icons.Controller;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter Integer MaximumDifferentTypesOfPowerPlants;
  parameter Integer MaximumDifferentTypesOfElectricalStorages;
  parameter Integer MaximumDifferentTypesOfPtG;

  parameter Integer NumberOfPowerplantsOverAllRegions;
  parameter Integer NumberOfElectricalStoragesOverAllRegions;
  parameter Integer NumberOfPowerToGasPlantsOverAllRegions;
  parameter Integer NumberOfElectricalHeatersOverAllRegions;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

public
  parameter Integer nRegions=3;
  parameter Integer MeritOrderPositionElectricStorages=1 "Electric Storages" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3",
      choice=4 "4"));
  parameter Integer MeritOrderPositionPowerToGas=4 "Power-to-Gas" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3",
      choice=4 "4"));
  parameter Integer MeritOrderPositionElectricHeater=2 "Electric Heater (District Heating)" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3",
      choice=4 "4"));

  parameter Integer powerPlantMatrix[max(1, NumberOfPowerplantsOverAllRegions),2];
  parameter Integer electricalStorageMatrix[max(1, NumberOfElectricalStoragesOverAllRegions),2];
  parameter Integer ptGMatrix[max(1, NumberOfPowerToGasPlantsOverAllRegions),2];
  parameter Integer electricalHeaterMatrix[max(1, NumberOfElectricalHeatersOverAllRegions),2];

  parameter SI.Power P_nom_PowerPlant[max(1, NumberOfPowerplantsOverAllRegions)] "nominal power of power plants";
  parameter SI.Power P_min_const_PowerPlant[max(1, NumberOfPowerplantsOverAllRegions)] "minimum power of power plants";
  parameter SI.Power P_max_const_PowerPlant[max(1, NumberOfPowerplantsOverAllRegions)] "minimum power of power plants";

  parameter SI.Power P_nom_load_ElectricalStorage_input[max(1, NumberOfElectricalStoragesOverAllRegions)] "nominal loading power of electrical storages";
  parameter SI.Power P_nom_unload_ElectricalStorage_input[max(1, NumberOfElectricalStoragesOverAllRegions)] "nominal unloading power of electrical storages";

  parameter SI.Power P_nom_load_PtG_input[max(1, NumberOfPowerToGasPlantsOverAllRegions)] "nominal power of PtG-plants";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealOutput P_set_PowerPlant[nRegions,MaximumDifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,-40})));
  Modelica.Blocks.Interfaces.RealOutput P_set_ElectricalStorage[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,0})));
  Modelica.Blocks.Interfaces.RealOutput P_set_PtG[nRegions,max(1, MaximumDifferentTypesOfPtG)] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,30})));
  Modelica.Blocks.Interfaces.RealOutput P_curtailment_Region[nRegions] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,60})));
  Modelica.Blocks.Interfaces.RealOutput P_set_ElectricalHeater[nRegions] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,-70})));

  Modelica.Blocks.Interfaces.RealInput P_max_load_storage[nRegions,MaximumDifferentTypesOfElectricalStorages] if MaximumDifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,-110})));
  Modelica.Blocks.Interfaces.RealInput P_max_unload_storage[nRegions,MaximumDifferentTypesOfElectricalStorages] if MaximumDifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealInput P_storage_is[nRegions,MaximumDifferentTypesOfElectricalStorages] if MaximumDifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealInput P_ElectricalHeater_max[nRegions] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput P_PowerToGasPlant_is[nRegions] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,48})));
  Modelica.Blocks.Interfaces.RealInput P_renewable[nRegions] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealInput P_PowerPlant_is[nRegions] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,-48})));
  Modelica.Blocks.Interfaces.RealInput P_PowerPlant_max[nRegions,MaximumDifferentTypesOfPowerPlants] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,-16})));
  Modelica.Blocks.Interfaces.RealInput P_residual_Region[nRegions] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealInput P_DAC[nRegions] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,16})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.RealExpression P_set_PowerPlant_nonExistent[nRegions,MaximumDifferentTypesOfPowerPlants](y=-1e9) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,-36})));
  Modelica.Blocks.Sources.RealExpression P_set_ElectricalStorage_nonExistent[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,4})));
  Modelica.Blocks.Sources.RealExpression P_set_PtG_nonExistent[nRegions,max(1, MaximumDifferentTypesOfPtG)] annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,34})));

  Modelica.Blocks.Sources.RealExpression Zero(y=0) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-38,-40})));

  Modelica.Blocks.Math.Gain P_set_PowerPlants_mod[mod.n_PowerPlant](each k=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={44,-40})));

  //this internal controller indexes all plants with one number, so some outside inputs(two dimensions) have to be flattened during connection
  ElectricalPowerController_inner mod(
    Region=nRegions,
    P_min_const_PowerPlant=P_min_const_PowerPlant,
    P_max_const_PowerPlant=P_max_const_PowerPlant,
    P_nom_PowerPlant=P_nom_PowerPlant,
    P_nom_load_ElectricalStorage=P_nom_load_ElectricalStorage_input,
    P_nom_unload_ElectricalStorage=P_nom_unload_ElectricalStorage_input,
    P_nom_load_PtG=P_nom_load_PtG_input,
    MeritOrderPositionElectricalStorage=MeritOrderPositionElectricStorages,
    MeritOrderPositionPtG=MeritOrderPositionPowerToGas,
    MeritOrderPositionElectricalHeater=MeritOrderPositionElectricHeater,
    MaximumDifferentTypesOfPowerPlants=MaximumDifferentTypesOfPowerPlants,
    NumberOfPowerplantsOverAllRegions=NumberOfPowerplantsOverAllRegions,
    NumberOfPowerToGasPlantsOverAllRegions=NumberOfPowerToGasPlantsOverAllRegions,
    NumberOfElectricalStoragesOverAllRegions=NumberOfElectricalStoragesOverAllRegions,
    NumberOfElectricalHeatersOverAllRegions=NumberOfElectricalHeatersOverAllRegions,
    powerPlantTypeDefinition={if powerPlantMatrix[i, 2] == 1 then 2 else 1 for i in 1:NumberOfPowerplantsOverAllRegions},
    powerPlantMatrix=powerPlantMatrix,
    regionOfElectricalStorage=electricalStorageMatrix[:, 1],
    regionOfPtGPlant=ptGMatrix[:, 1],
    regionOfElectricalHeater={(if Modelica.Math.Vectors.find(i, electricalHeaterMatrix[:, 1]) <> 0 then i else 0) for i in 1:nRegions},
    regionOfPowerPlant=powerPlantMatrix[:, 1]) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-2,0})));

  Modelica.Blocks.Math.Gain P_set_ElectricalStorages_mod[mod.n_ElectricalStorage](k=1) if MaximumDifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={44,0})));

  Modelica.Blocks.Interfaces.RealInput f_grid annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={80,-110})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  //Powerplants
  for i in 1:nRegions loop
    for j in 1:MaximumDifferentTypesOfPowerPlants loop
      //1. sees if index is in list of powerplants by substraction and checking for scalar product of difference being 0
      if min((abs(powerPlantMatrix - fill({i,j}, max(1, NumberOfPowerplantsOverAllRegions))))*[1; 1]) == 0 then
        //2a. if yes: this row index (of list of powerplants) is connected to P_set_PowerPlant through P_set_PowerPlants_mod (which is used for a possible gain?)
        connect(P_set_PowerPlants_mod[Modelica.Math.Vectors.find(0, vector((abs(powerPlantMatrix - fill({i,j}, max(1, NumberOfPowerplantsOverAllRegions))))*[1; 1]))].y, P_set_PowerPlant[i, j]) annotation (Line(points={{55,-40},{110,-40}}, color={0,0,127}));
        //2b. also the Pmax input of the mod controller as row index is handed over from input
        connect(mod.P_max_input_PowerPlant[Modelica.Math.Vectors.find(0, vector((abs(powerPlantMatrix - fill({i,j}, max(1, NumberOfPowerplantsOverAllRegions))))*[1; 1]))], P_PowerPlant_max[i, j]) annotation (Line(points={{-14,0},{-90,0},{-90,-16},{-110,-16}}, color={0,0,127}));
      else
        //3.output indices referring to nonexisting plants are set to 0
        connect(P_set_PowerPlant_nonExistent[i, j].y, P_set_PowerPlant[i, j]) annotation (Line(points={{81,-36},{96,-36},{96,-40},{110,-40}}, color={0,0,127}));
      end if;
    end for;
  end for;

  //Electrical Storages
  for i in 1:nRegions loop
    if MaximumDifferentTypesOfElectricalStorages < 1 then
      //1. if no electrical strorages exist: internal controller gets zero
      connect(mod.P_max_load_ElectricalStorage[1], Zero.y) annotation (Line(points={{-2,-12},{-2,-40},{-27,-40}}, color={0,0,127}));
      connect(mod.P_max_unload_ElectricalStorage[1], Zero.y) annotation (Line(points={{-6,-12},{-6,-40},{-27,-40}}, color={0,0,127}));
      connect(mod.P_is_ElectricalStorage[1], Zero.y) annotation (Line(points={{2,-12},{2,-40},{-27,-40}}, color={0,0,127}));
    else
      for j in 1:MaximumDifferentTypesOfElectricalStorages loop
        //2. see if electrical storage exists at this index
        if min((abs(electricalStorageMatrix[:, 1:2] - fill({i,j}, NumberOfElectricalStoragesOverAllRegions)))*[1; 1]) == 0 then
          //connect output to mod gain
          connect(P_set_ElectricalStorages_mod[Modelica.Math.Vectors.find(0, vector(((abs(electricalStorageMatrix - fill({i,j}, max(1, NumberOfElectricalStoragesOverAllRegions))))*[1; 1])))].y, P_set_ElectricalStorage[i, j]) annotation (Line(points={{55,0},{110,0}}, color={0,0,127}));
          //connect inputs to internal controller:     P_storage_is & max_load & min_load
          connect(mod.P_max_load_ElectricalStorage[Modelica.Math.Vectors.find(0, vector(((abs(electricalStorageMatrix - fill({i,j}, max(1, NumberOfElectricalStoragesOverAllRegions))))*[1; 1])))], P_max_load_storage[i, j]) annotation (Line(points={{-2,-12},{-2,-90},{-80,-90},{-80,-110}}, color={0,0,127}));
          connect(mod.P_max_unload_ElectricalStorage[Modelica.Math.Vectors.find(0, vector(((abs(electricalStorageMatrix - fill({i,j}, max(1, NumberOfElectricalStoragesOverAllRegions))))*[1; 1])))], P_max_unload_storage[i, j]) annotation (Line(points={{-6,-12},{-6,-86},{-40,-86},{-40,-110}}, color={0,0,127}));
          connect(mod.P_is_ElectricalStorage[Modelica.Math.Vectors.find(0, vector(((abs(electricalStorageMatrix - fill({i,j}, max(1, NumberOfElectricalStoragesOverAllRegions))))*[1; 1])))], P_storage_is[i, j]) annotation (Line(points={{2,-12},{2,-94},{0,-94},{0,-110}}, color={0,0,127}));
        else
          //3.output indices referring to nonexisting el stroages are set to 0
          connect(P_set_ElectricalStorage_nonExistent[i, j].y, P_set_ElectricalStorage[i, j]) annotation (Line(points={{81,4},{96,4},{96,0},{110,0}}, color={0,0,127}));
        end if;
      end for;
    end if;
  end for;

  //Power To Gas plants
  for i in 1:nRegions loop
    if MaximumDifferentTypesOfPtG < 1 then
      //1. if no PtG exists: internal controller gets zero
      connect(mod.P_is_PowerToGasPlant[1], Zero.y) annotation (Line(points={{-14,-8},{-24,-8},{-24,-40},{-27,-40}}, color={0,0,127}));
      connect(mod.P_DAC[1], Zero.y) annotation (Line(points={{-14,8},{-24,8},{-24,-40},{-27,-40}}, color={0,0,127}));
      connect(P_set_PtG_nonExistent.y, P_set_PtG) annotation (Line(points={{81,34},{96,34},{96,30},{110,30}}, color={0,0,127}));
    else
      for j in 1:MaximumDifferentTypesOfPtG loop
        //2. see if  PtG exists at this index
        if min((abs(ptGMatrix - fill({i,j}, max(1, NumberOfPowerToGasPlantsOverAllRegions))))*[1; 1]) == 0 then
          //internal controller output is connected to real output
          connect(mod.P_set_PtG[Modelica.Math.Vectors.find(0, vector(((abs(ptGMatrix - fill({i,j}, max(1, NumberOfPowerToGasPlantsOverAllRegions))))*[1; 1])))], P_set_PtG[i, j]) annotation (Line(points={{9,0},{20,0},{20,30},{110,30}}, color={0,0,127}));
          //connect inputs to controllers: P_is_PtG & P_DAC
          connect(mod.P_is_PowerToGasPlant[Modelica.Math.Vectors.find(0, vector(((abs(ptGMatrix - fill({i,j}, max(1, NumberOfPowerToGasPlantsOverAllRegions))))*[1; 1])))], P_PowerToGasPlant_is[i]) annotation (Line(points={{-14,-8},{-82,-8},{-82,48},{-110,48}}, color={0,0,127}));
          connect(mod.P_DAC[Modelica.Math.Vectors.find(0, vector(((abs(ptGMatrix - fill({i,j}, max(1, NumberOfPowerToGasPlantsOverAllRegions))))*[1; 1])))], P_DAC[i]) annotation (Line(points={{-14,8},{-92,8},{-92,16},{-110,16}}, color={0,0,127}));
        else
          //3.output indices referring to nonexisting PtG are set to 0
          connect(P_set_PtG_nonExistent[i, j].y, P_set_PtG[i, j]) annotation (Line(points={{81,34},{96,34},{96,30},{110,30}}, color={0,0,127}));
        end if;
      end for;
    end if;
  end for;

  //other outputs
  connect(mod.P_set_PowerPlant, P_set_PowerPlants_mod.u) annotation (Line(points={{9,4},{22,4},{22,-40},{32,-40}}, color={0,0,127}));
  connect(mod.P_set_Storage, P_set_ElectricalStorages_mod.u) annotation (Line(points={{9,-4},{24,-4},{24,0},{32,0}}, color={0,0,127}));
  connect(mod.P_set_ElectricalHeater, P_set_ElectricalHeater) annotation (Line(points={{9,-8},{18,-8},{18,-70},{110,-70}}, color={0,0,127}));
  connect(mod.P_curtailment_Region, P_curtailment_Region) annotation (Line(points={{9,8},{18,8},{18,60},{110,60}}, color={0,0,127}));
  //other inputs
  connect(P_ElectricalHeater_max, mod.P_max_ElectricalHeater) annotation (Line(points={{-110,80},{-74,80},{-74,-80},{-10,-80},{-10,-12}}, color={0,0,127}));
  connect(P_renewable, mod.P_renewable) annotation (Line(points={{-110,-80},{-92,-80},{-92,4},{-14,4}}, color={0,0,127}));
  connect(P_PowerPlant_is, mod.P_is_PowerPlant) annotation (Line(points={{-110,-48},{-86,-48},{-86,-4},{-14,-4}}, color={0,0,127}));
  connect(mod.P_residual_Region, P_residual_Region) annotation (Line(points={{6,-12},{6,-94},{40,-94},{40,-110}}, color={0,0,127}));
  connect(f_grid, mod.f_grid) annotation (Line(
      points={{80,-110},{80,-76},{14,-76},{14,16},{-6,16},{-6,12}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is intended to hand over variables from input to the inner controller and vice versa. The structure of the variables is changed in some cases to allow an easier control.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end ElectricalPowerController_outer;
