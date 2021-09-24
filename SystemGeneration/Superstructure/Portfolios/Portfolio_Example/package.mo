within TransiEnt.SystemGeneration.Superstructure.Portfolios;
package Portfolio_Example

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


  extends Base;

  extends TransiEnt.Basics.Icons.ExamplesPackage;


  redeclare package extends Records "These Records contains parameters that are different for each region or for different instances in a single region"
    extends TransiEnt.Basics.Icons.DataPackage;

    redeclare record ElectricalStorageRecord "Choose parameters for each storage type in the region, one row per type"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter Real a=0.015931978;
      parameter Real b=1.35258929;
      parameter Real c=1.022756556;
      parameter Real d=0.716106727;

      parameter Real P_max_load=1e9;
      parameter Real P_max_unload=1e9;

      parameter Real eta_load=0.95;
      parameter Real eta_unload=0.95;

      parameter Real E_max=3e13;
      parameter Real E_min=0;
      parameter Real E_start=0;

      parameter Real P_grad_max=1.2e9;

      parameter Real selfDischargeRate=5.6e-9;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for electrical storages in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end ElectricalStorageRecord;

    redeclare record GasStorageRecord "Choose parameters for the gas storage system"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter SI.Volume Volume=500000;

      parameter SI.Pressure p_gas_const=120e5;
      parameter SI.Mass m_gas_start=1e5;

      parameter Real m_flow_nom=417.573;

      parameter Real Vgeo_per_mMax=3.62e+09;
      parameter Real m_flow_inMax=5000;
      parameter Real m_flow_outMax=5000;
      parameter Real GasStrorageTypeNo=1;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for gas storages in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end GasStorageRecord;

    redeclare record PowerPlantRecord "Choose parameters for each powerplant type in the region, one row per type"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter Real P_el_n=4.648e10;
      parameter Real eta_total=0.6331;
      parameter Integer quantity=2;
      parameter Real P_init_set=0;
      parameter Real t_startup=0;
      parameter Real P_min_star=0.00403;
      parameter Real P_grad_max_star=0.001719;
      parameter Real CO2_Deposition_Rate=0;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for power plants in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end PowerPlantRecord;

    redeclare record LocalDemandRecord "Choose parameters for the local demand model"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter Real Fraction[10]={0.5,0,0,0,0,0,0,0,0.5,0};
      parameter Modelica.Units.SI.Heat Q_demand_annual=4.650049e23;
      parameter Boolean LocalGasDemandMaterialUse=true;
      parameter Modelica.Units.SI.Volume volume_junction=10676.733;

      parameter Real loadVariability_kpf=1;
      parameter Real loadVariability_kpu=0;
      parameter Real loadVariability_kqf=0;
      parameter Real loadVariability_kqu=0;

      parameter Real HeatPumpAndSolarSole_COP_n=4 "Coefficient of performance at nominal conditions A2/W35 according to EN14511";
      parameter Real HeatPumpSole_COP_n=4 "Coefficient of performance at nominal conditions A2/W35 according to EN14511";
      parameter Real HeatPumpAndSolar_COP_n=4 "Coefficient of performance at nominal conditions A2/W35 according to EN14511";
      parameter Real HeatPump_COP_n=4 "Coefficient of performance at nominal conditions A2/W35 according to EN14511";
      parameter SI.Efficiency gasboiler_eta=0.7;
      parameter SI.Efficiency electricBoiler_eta=0.99;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for local demand in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end LocalDemandRecord;

    redeclare record LocalRenewableProductionRecord "Choose parameters for the local renewable production model"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for local renewable production in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end LocalRenewableProductionRecord;

    redeclare record CO2SystemRecord "Choose parameters for the CO2 system"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter Modelica.Units.SI.Energy DirectAirCapture_EnergyDemandThermal=7.92e6;
      parameter Modelica.Units.SI.Energy DirectAirCapture_EnergyDemandElectrical=2.52e6;
      parameter Real m_start_CO2_storage=0;
      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for CO<sub>2 </sub>systems in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end CO2SystemRecord;

    redeclare record PowerToGasRecord "Choose parameters for each PtG type in the region, one row per type"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter SI.Volume WasteHeatUsage_V_storage=244969.27e12*0.22923*48/(4.18*(105 - 20))/959;
      parameter SI.MassFlowRate MethanationPlant_m_flow_n_Hydrogen=244969.27e12*0.927995/(141.79e6 - 219972) "Nominal mass flow rate of hydrogen at the inlet";

      parameter SI.ActivePower P_el_n=1e9;
      parameter Real eta_n=0.851;
      parameter SI.Energy max_storage=3e12;
      parameter Real P_el_min_rel=0;
      parameter Integer complexityLevelMethanation=2;
      parameter SI.Pressure p_Start=38e5;

      parameter SI.Pressure p_minLow_constantDemand=30;
      parameter SI.Pressure p_minLow=38;
      parameter SI.Pressure p_minHigh=45;
      parameter SI.Pressure p_maxLow=180;
      parameter SI.Pressure p_maxHigh=185;
      parameter SI.MassFlowRate m_flow_internaldemand_constant=0;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for power to gas in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end PowerToGasRecord;

    redeclare record HeatingGridSystemStorageRecord "Choose parameters for each type in the region, one row per type"

      // _____________________________________________
      //
      //              Visible Parameters
      // _____________________________________________

      parameter Real gridLosses_districtHeating=0.127 "Losses of district heating network";
      parameter Integer controlPeakBoiler=1 "heat flow control of peak boiler" annotation (choices(choice=1 "Electric Boiler first", choice=2 "Gas Boiler first"));

      parameter Real Q_flow_max=0.16*1.3e10;

      parameter Integer ElHeater_quantity=0;
      parameter Real ElHeater_Q_el_n=1e9;
      parameter Real ElHeater_eta_n=0.95;

      parameter Integer CHP_quantity=0;
      parameter Real CHP_P_el_n=2e9;
      parameter Real CHP_Q_flow_n=1e9;
      parameter Integer CHP_meritOrder=1;
      parameter Real CHP_Q_flow_init=1e9;

      parameter Real CHP_eta_n=1;

      parameter Real GasBoiler_Q_flow_n=1.5e9;
      parameter Real GasBoiler_eta_n=0.985;
      parameter Integer GasBoiler_quantity=0;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define parameters for heating grids in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
    end HeatingGridSystemStorageRecord;

    redeclare package extends InstancesRecords "These records contain definitions of a system type and parametrization for each region "

      redeclare record ElectricalStorageInstancesRecord "Define one row per region
nElectricalStorages: number of electrical storage types present, 0 or more
electricalStorageType: types of storage in region [nElectricalStorages]
electricalStorageRecord: parametrization records for storages in region [nElectricalStorages]"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Integer nElectricalStorages=1;
        parameter ElectricalStorageType electricalStorageType[nElectricalStorages]=fill(ElectricalStorageType(1), nElectricalStorages);

        parameter Records.ElectricalStorageRecord electricalStorageRecord[nElectricalStorages]=fill(Records.ElectricalStorageRecord(), nElectricalStorages);

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for electrical storages in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end ElectricalStorageInstancesRecord;

      redeclare record GasStorageInstancesRecord "Define one row per region
nGasStorages: number of gas storage types present, 0 or 1
gasStorageType: type of storage in region 
gasStorageRecord: parametrization record for storage in region"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Integer nGasStorages(
          min=0,
          max=1) = 0 "currently only up to one per region is supported" annotation (Dialog(enabled=true), choices(choice=0 "0", choice=1 "1"));
        parameter GasStorageType gasStorageType=GasStorageType(1);
        parameter Records.GasStorageRecord gasStorageRecord=Records.GasStorageRecord();

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for gas storages in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end GasStorageInstancesRecord;

      redeclare record PowerPlantInstancesRecord "Define one row per region
nPowerPlants: number of powerplant types present, 1 or more
powerPlantType: types of powerplants in region [nPowerPlants]
powerPlantRecord: parametrization records for powerplants in region [nPowerPlants]"

          // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Integer nPowerPlants(min=1) = 1;

        parameter PowerPlantType powerPlantType[nPowerPlants]=fill(PowerPlantType(1), nPowerPlants);
        parameter Records.PowerPlantRecord powerPlantRecord[nPowerPlants]=fill(Records.PowerPlantRecord(), nPowerPlants);
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for power plants in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end PowerPlantInstancesRecord;

      redeclare record LocalDemandInstancesRecord "Define one row per region
  localDemandRecord: parametrization record for local demand in region"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Records.LocalDemandRecord localDemandRecord=Records.LocalDemandRecord();
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for local demand in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end LocalDemandInstancesRecord;

      redeclare record LocalRenewableProductionInstancesRecord "Define one row per region
  localRenewableProductionRecord: parametrization record for local renewable production in region"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Records.LocalRenewableProductionRecord localRenewableProductionRecord=Records.LocalRenewableProductionRecord();

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for local renewable production in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end LocalRenewableProductionInstancesRecord;

      redeclare record CO2SystemInstancesRecord "Define one row per region
  CO2SystemRecord: parametrization record for CO2 system in region"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Records.CO2SystemRecord cO2SystemRecord=Records.CO2SystemRecord();

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for CO<sub>2</sub> systems in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end CO2SystemInstancesRecord;

      redeclare record PowerToGasInstancesRecord "Define one row per region
nPowerToGasPlants: number of PtGplant types present, 0 or more
powerToGasType: types of PtGplants in region [nPowerToGasPlants]
powerToGasRecord: parametrization records for PtGplants in region [nPowerToGasPlants]"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Integer nPowerToGasPlants=0 "currently only up to one per region is supported" annotation (Dialog(enabled=true), choices(choice=0 "0", choice=1 "1"));
        parameter PowerToGasType powerToGasType=PowerToGasType(1) annotation (Dialog(enabled=nPowerToGasPlants > 0));
        parameter Records.PowerToGasRecord powerToGasRecord=Records.PowerToGasRecord() annotation (Dialog(enabled=nPowerToGasPlants > 0));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for power to gas in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end PowerToGasInstancesRecord;

      redeclare record HeatingGridSystemStorageInstancesRecord "Define one row per region
  nHeatingGrid: number of heating grids in region
  heatingGridSystemStorageRecord: parametrization record for heating grid in region"

        // _____________________________________________
        //
        //              Visible Parameters
        // _____________________________________________

        parameter Integer nHeatingGrid=0 annotation (Dialog(enabled=true), choices(choice=0 "0", choice=1 "1"));

        parameter Records.HeatingGridSystemStorageRecord heatingGridSystemStorageRecord=Records.HeatingGridSystemStorageRecord() annotation (Dialog(enabled=nHeatingGrid > 0));

        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record to define instances for heating grids in superstructure</p>
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
<p>Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </p>
</html>"));
      end HeatingGridSystemStorageInstancesRecord;
    end InstancesRecords;
  end Records;

  redeclare type PowerPlantType = enumeration(
    Gasturbine_with_Gasport_constantEff   "Gasturbine_with_Gasport and constant efficiency",
    CCP_with_Gasport_constantEff   "CCP_with_Gasport and constant efficiency") "Choose power plant type";

  redeclare model extends PowerPlantSystem(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumGas=simCenter.gasModel1;
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1;
    parameter Boolean useHydrogenFromPtGInPowerPlants;
    parameter SI.MassFlowRate m_flow_small=0 "small leackage mass flow for numerical stability";
    parameter Boolean CCSInPowerPlants=true;
    parameter Real CO2StorageNeeded=true;
    parameter Boolean isSlack=false "true for Slack bus";

    parameter PowerPlantType powerPlantType=PowerPlantType(1);
    parameter Records.PowerPlantRecord powerPlantRecord=Records.PowerPlantRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________
    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn1(Medium=simCenter.gasModel1) if useHydrogenFromPtGInPowerPlants annotation (Placement(transformation(rotation=0, extent={{95,-65},{105,-55}}), iconTransformation(extent={{95,-65},{105,-55}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_CDE if (CO2StorageNeeded > 0 and powerPlantRecord.CO2_Deposition_Rate > 0) annotation (Placement(transformation(rotation=0, extent={{95,35},{105,45}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Components.Sensors.ElectricPowerComplex electricActivePower_PowerPlants annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={66,60})));
    TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine_PowerPlants(
      each activateSwitch=false,
      each HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
      each p=350,
      each ChooseVoltageLevel=4,
      each r_custom=0,
      each l(displayUnit="m") = 200) if not simCenter.idealSuperstructLocalGrid annotation (Placement(transformation(extent={{38,56},{28,66}})));
    TransiEnt.Components.Electrical.Grid.IdealCoupling transmissionLine if simCenter.idealSuperstructLocalGrid annotation (Placement(transformation(extent={{30,40},{42,52}})));

    TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts_isoth junction1(
      medium=mediumGas,
      n_ports=if useHydrogenFromPtGInPowerPlants then 3 else 2,
      volume=1e2,
      m_flow_nom=ones(junction1.n_ports)*10000,
      Delta_p_nom=vector([{1}; zeros(junction1.n_ports - 1)])*1e5) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=90,
          origin={24,0})));
    TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_PowerPlants(medium=mediumGas, xiNumber=0) annotation (Placement(transformation(extent={{76,0},{56,24}})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow4(
      medium=mediumGas,
      variable_m_flow=false,
      m_flow_const=1) annotation (Placement(transformation(extent={{46,-20},{56,-10}})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow5(
      medium=mediumGas,
      variable_m_flow=false,
      m_flow_const=-1) annotation (Placement(transformation(
          extent={{5,-5},{-5,5}},
          rotation=180,
          origin={75,-15})));

    Modelica.Blocks.Sources.RealExpression P_powerPlantType1_max_noCCs(y=-powerPlantType1.P_max_with_CCS.y) if powerPlantType == PowerPlantType.CCP_with_Gasport_constantEff annotation (Placement(transformation(extent={{-78,84},{-90,96}})));
    Modelica.Blocks.Sources.RealExpression P_powerPlantType2_max_noCCs(y=-powerPlantType2.P_max_with_CCS.y) if powerPlantType == PowerPlantType.Gasturbine_with_Gasport_constantEff annotation (Placement(transformation(extent={{-78,72},{-90,84}})));

    //----Instances of Types---
    TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport powerPlantType1(
      P_el_n=powerPlantRecord.P_el_n,
      eta_total=powerPlantRecord.eta_total,
      P_init_set=powerPlantRecord.P_init_set,
      P_min_star=powerPlantRecord.P_min_star,
      P_grad_max_star=powerPlantRecord.P_grad_max_star,
      t_startup=powerPlantRecord.t_startup,
      t_min_operating=120,
      CO2_Deposition_Rate=if CO2StorageNeeded > 0 then powerPlantRecord.CO2_Deposition_Rate else 0,
      CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC(),
      quantity=powerPlantRecord.quantity,
      useHomotopyVarSlewRateLim=false,
      mediumGas=mediumGas,
      useSecondGasPort=false,
      useCDEPort=if powerPlantRecord.CO2_Deposition_Rate > 0 then true else false,
      m_flow_small=m_flow_small,
      isSecondaryControlActive=false,
      isPrimaryControlActive=true,
      useLeakageMassFlow=true,
      Turbine(T_plant=2, useSlewRateLimiter=true),
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex Generator(IsSlack=isSlack),
      redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort Exciter,
      redeclare TransiEnt.Producer.Electrical.Controllers.PrimaryBalancingController primaryBalancingController) if powerPlantType == PowerPlantType.CCP_with_Gasport_constantEff annotation (Placement(transformation(extent={{-40,62},{-20,82}})));

    TransiEnt.Producer.Electrical.Conventional.Gasturbine_with_Gasport powerPlantType2(
      P_el_n=powerPlantRecord.P_el_n,
      eta_total=powerPlantRecord.eta_total,
      P_init_set=powerPlantRecord.P_init_set,
      P_min_star=powerPlantRecord.P_min_star,
      P_grad_max_star=powerPlantRecord.P_grad_max_star,
      t_min_operating=120,
      CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC(),
      quantity=powerPlantRecord.quantity,
      useHomotopyVarSlewRateLim=false,
      mediumGas=mediumGas,
      useSecondGasPort=false,
      useCDEPort=if powerPlantRecord.CO2_Deposition_Rate > 0 then true else false,
      m_flow_small=m_flow_small,
      isSecondaryControlActive=false,
      isPrimaryControlActive=true,
      useLeakageMassFlow=true,
      t_startup=powerPlantRecord.t_startup,
      Turbine(T_plant=2, useSlewRateLimiter=true),
      CO2_Deposition_Rate=if CO2StorageNeeded > 0 then powerPlantRecord.CO2_Deposition_Rate else 0,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex Generator(IsSlack=isSlack),
      redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort Exciter,
      redeclare TransiEnt.Producer.Electrical.Controllers.PrimaryBalancingController primaryBalancingController) if powerPlantType == PowerPlantType.Gasturbine_with_Gasport_constantEff annotation (Placement(transformation(extent={{-40,24},{-20,44}})));

  equation

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________
    connect(powerPlantType1.epp, TransmissionLine_PowerPlants.epp_n) annotation (Line(
        points={{-21,79},{2,79},{2,61},{28,61}},
        color={28,108,200},
        thickness=0.5));
    connect(powerPlantType1.epp, transmissionLine.epp_p) annotation (Line(
        points={{-21,79},{-6,79},{-6,46},{30,46}},
        color={28,108,200},
        thickness=0.5));
    connect(powerPlantType1.P_el_set, P_el_set) annotation (Line(points={{-31.5,81.9},{-60,81.9},{-60,94},{-106,94}},   color={0,127,127}));
    connect(powerPlantType1.useCCS, controlBus.powerPlantSystem_useCCS) annotation (Line(
        points={{-42,72},{-52,72},{-52,0},{-102,0}},
        color={255,204,51},
        thickness=0.5));
    connect(powerPlantType1.gasPortOut_CDE, gasPortOut_CDE) annotation (Line(points={{-20,76},{12,76},{12,40},{100,40}}, color={215,215,215}));
    connect(powerPlantType1.gasPortIn, junction1.gasPort[2]) annotation (Line(
        points={{-20,68},{-10,68},{-10,0},{24,0}},
        color={255,255,0},
        thickness=1.5));
    connect(P_powerPlantType1_max_noCCs.y, P_max_noCCs) annotation (Line(points={{-90.6,90},{-96,90},{-96,72},{-106,72}}, color={0,0,127}));

    connect(powerPlantType2.epp, TransmissionLine_PowerPlants.epp_n) annotation (Line(
        points={{-21,41},{-21,38},{2,38},{2,61},{28,61}},
        color={28,108,200},
        thickness=0.5));
    connect(powerPlantType2.epp, transmissionLine.epp_p) annotation (Line(
        points={{-21,41},{-21,38},{-6,38},{-6,46},{30,46}},
        color={28,108,200},
        thickness=0.5));
    connect(powerPlantType2.P_el_set, P_el_set) annotation (Line(points={{-31.5,43.9},{-60,43.9},{-60,94},{-106,94}},   color={0,127,127}));
    connect(powerPlantType2.useCCS, controlBus.powerPlantSystem_useCCS) annotation (Line(
        points={{-42,34},{-52,34},{-52,0},{-102,0}},
        color={255,204,51},
        thickness=0.5));
    connect(powerPlantType2.gasPortOut_CDE, gasPortOut_CDE) annotation (Line(points={{-20,38},{12,38},{12,40},{100,40}}, color={215,215,215}));
    connect(powerPlantType2.gasPortIn, junction1.gasPort[2]) annotation (Line(
        points={{-20,30},{-10,30},{-10,0},{24,0}},
        color={255,255,0},
        thickness=1.5));
    connect(P_powerPlantType2_max_noCCs.y, P_max_noCCs) annotation (Line(points={{-90.6,78},{-96,78},{-96,72},{-106,72}}, color={0,0,127}));

    // other connects
    connect(TransmissionLine_PowerPlants.epp_p, electricActivePower_PowerPlants.epp_IN) annotation (Line(
        points={{38,61},{56,61},{56,60},{56.8,60}},
        color={28,108,200},
        thickness=0.5));
    connect(transmissionLine.epp_n, electricActivePower_PowerPlants.epp_IN) annotation (Line(
        points={{42,46},{56.8,46},{56.8,60}},
        color={28,108,200},
        thickness=0.5));
    connect(epp_OUT, electricActivePower_PowerPlants.epp_OUT) annotation (Line(
        points={{0,100},{75.4,100},{75.4,60}},
        color={28,108,200},
        thickness=0.5));

    connect(boundary_Txim_flow4.gasPort, massFlowSensor_PowerPlants.gasPortOut) annotation (Line(
        points={{56,-15},{56,0}},
        color={255,255,0},
        thickness=1.5));
    connect(boundary_Txim_flow5.gasPort, massFlowSensor_PowerPlants.gasPortIn) annotation (Line(
        points={{80,-15},{82,-15},{82,0},{76,0}},
        color={255,255,0},
        thickness=1.5));
    connect(massFlowSensor_PowerPlants.gasPortIn, gasPortIn) annotation (Line(
        points={{76,0},{100,0}},
        color={255,255,0},
        thickness=1.5));

    connect(junction1.gasPort[1], massFlowSensor_PowerPlants.gasPortOut) annotation (Line(
        points={{24,0},{56,0}},
        color={255,255,0},
        thickness=1.5));
    connect(junction1.gasPort[3], gasPortIn1) annotation (Line(
        points={{24,0},{26,0},{26,-60},{100,-60}},
        color={255,255,0},
        thickness=1.5));
    connect(electricActivePower_PowerPlants.P, P_Powerplant_is) annotation (Line(
        points={{61,68.6},{61,90},{106,90}},
        color={0,135,135},
        pattern=LinePattern.Dash));
  connect(massFlowSensor_PowerPlants.m_flow, m_flow_Powerplant_is) annotation (Line(points={{55,12},{50,12},{50,30},{90,30},{90,70},{106,70}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the powerplant system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This definition includes the type options:</p>
<ul>
<li><a href=\"TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport\">CCP_with_Gasport</a></li>
<li><a href=\"TransiEnt.Producer.Electrical.Conventional.Gasturbine_with_Gasport\">Gasturbine_with_Gasport</a></li>
</ul>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
<li>P_el_set</li>
<li>gasPortIn and gasPortIn1</li>
</ul>
<p>Outputs:</p>
<ul>
<li>epp</li>
<li>P_max_noCCs</li>
<li>P_Powerplant_is</li>
<li>gasPortOut for CO2 deposition</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.PowerPlantType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end PowerPlantSystem;

  redeclare type ElectricalStorageType = enumeration(
    leadAcidBattery "Model of a lead acid battery",
    lithiumIonBattery "Model of a ltihium ion battery",
    battery "Typical characteristic of battery storage") "Choose electrical storage type";

  redeclare model extends ElectricalStorageSystem(redeclare package Config = Portfolio_Example)
     // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    // Interface parameters
    parameter ElectricalStorageType electricalStorageType=ElectricalStorageType(1);

    parameter Records.ElectricalStorageRecord electricalStorageRecord=Records.ElectricalStorageRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Storage.Electrical.Base.Battery electricalStorage1(
      use_PowerRateLimiter=false,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort",
      redeclare model StorageModel = TransiEnt.Storage.Base.GenericStorageHyst (
          params=electricalStorage1.StorageModelParams,
          use_PowerRateLimiter=false,
          stationaryLossOnlyIfInactive=true,
          redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRateRelative,
          relDeltaEnergyHystFull=0.02),
      StorageModelParams(
        E_start=electricalStorageRecord.E_start,
        E_max=electricalStorageRecord.E_max,
        E_min=electricalStorageRecord.E_min,
        P_max_unload=electricalStorageRecord.P_max_unload,
        P_max_load=electricalStorageRecord.P_max_load,
        P_grad_max=electricalStorageRecord.P_grad_max,
        eta_unload=electricalStorageRecord.eta_unload,
        eta_load=electricalStorageRecord.eta_load,
        selfDischargeRate=electricalStorageRecord.selfDischargeRate,
        a=electricalStorageRecord.a,
        b=electricalStorageRecord.b,
        c=electricalStorageRecord.c,
        d=electricalStorageRecord.d),
      redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRateRelative) if electricalStorageType == ElectricalStorageType.battery annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

    TransiEnt.Storage.Electrical.LeadAcidBattery electricalStorage2(
      use_PowerRateLimiter=false,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort",
      redeclare model StorageModel = TransiEnt.Storage.Base.GenericStorageHyst (
          params=electricalStorage2.StorageModelParams,
          use_PowerRateLimiter=false,
          stationaryLossOnlyIfInactive=true,
          redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRateRelative,
          relDeltaEnergyHystFull=0.02),
      StorageModelParams=TransiEnt.Storage.Electrical.Specifications.LeadAcidBattery(
                E_start=electricalStorageRecord.E_start,
                E_max=electricalStorageRecord.E_max,
                E_min=electricalStorageRecord.E_min,
                P_max_unload=electricalStorageRecord.P_max_unload,
                P_max_load=electricalStorageRecord.P_max_load,
                P_grad_max=electricalStorageRecord.P_grad_max,
                eta_unload=electricalStorageRecord.eta_unload,
                eta_load=electricalStorageRecord.eta_load,
                selfDischargeRate=electricalStorageRecord.selfDischargeRate,
                a=electricalStorageRecord.a,
                b=electricalStorageRecord.b,
                c=electricalStorageRecord.c,
                d=electricalStorageRecord.d)) if electricalStorageType == ElectricalStorageType.leadAcidBattery annotation (Placement(transformation(extent={{-78,42},{-62,58}})));

    TransiEnt.Storage.Electrical.LithiumIonBattery electricalStorage3(
      use_PowerRateLimiter=false,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort",
      redeclare model StorageModel = TransiEnt.Storage.Base.GenericStorageHyst (
          params=electricalStorage3.StorageModelParams,
          use_PowerRateLimiter=false,
          stationaryLossOnlyIfInactive=true,
          redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRateRelative,
          relDeltaEnergyHystFull=0.02),
      StorageModelParams=TransiEnt.Storage.Electrical.Specifications.LithiumIon(
                E_start=electricalStorageRecord.E_start,
                E_max=electricalStorageRecord.E_max,
                E_min=electricalStorageRecord.E_min,
                P_max_unload=electricalStorageRecord.P_max_unload,
                P_max_load=electricalStorageRecord.P_max_load,
                P_grad_max=electricalStorageRecord.P_grad_max,
                eta_unload=electricalStorageRecord.eta_unload,
                eta_load=electricalStorageRecord.eta_load,
                selfDischargeRate=electricalStorageRecord.selfDischargeRate,
                a=electricalStorageRecord.a,
                b=electricalStorageRecord.b,
                c=electricalStorageRecord.c,
                d=electricalStorageRecord.d)) if electricalStorageType == ElectricalStorageType.lithiumIonBattery annotation (Placement(transformation(extent={{-78,4},{-62,20}})));

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

  equation

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________
    connect(P_set, electricalStorage1.P_set) annotation (Line(points={{-115.5,79.5},{-90,79.5},{-90,100},{-70,100},{-70,97.52}}, color={0,127,127}));
    connect(electricalStorage1.epp, epp) annotation (Line(
        points={{-62,90},{0,90},{0,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(P_set, electricalStorage2.P_set) annotation (Line(points={{-115.5,79.5},{-90,79.5},{-90,64},{-70,64},{-70,57.52}}, color={0,127,127}));
    connect(electricalStorage2.epp, epp) annotation (Line(
        points={{-62,50},{0,50},{0,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(P_set, electricalStorage3.P_set) annotation (Line(points={{-115.5,79.5},{-90,79.5},{-90,28},{-70,28},{-70,19.52}}, color={0,127,127}));
    connect(electricalStorage3.epp, epp) annotation (Line(
        points={{-62,12},{0,12},{0,0},{100,0}},
        color={28,108,200},
        thickness=0.5));

    connect(electricalStorage1.storageModel.P_max_load_is, P_max_load_storage);
    connect(electricalStorage2.storageModel.P_max_load_is, P_max_load_storage);
    connect(electricalStorage3.storageModel.P_max_load_is, P_max_load_storage);

    connect(electricalStorage1.batteryPowerLimit.P_max_unload_star, P_max_unload_storage);
    connect(electricalStorage2.batteryPowerLimit.P_max_unload_star, P_max_unload_storage);
    connect(electricalStorage3.batteryPowerLimit.P_max_unload_star, P_max_unload_storage);

    connect(electricalStorage1.storageModel.P_is, P_storage_is);
    connect(electricalStorage2.storageModel.P_is, P_storage_is);
    connect(electricalStorage3.storageModel.P_is, P_storage_is);

    connect(electricalStorage1.storageModel.E_is.y,  E_storage_is);
    connect(electricalStorage2.storageModel.E_is.y,  E_storage_is);
    connect(electricalStorage3.storageModel.E_is.y,  E_storage_is);

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the electrical storage system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This definition includes the type options:</p>
<ul>
<li><a href=\"TransiEnt.Storage.Electrical.LeadAcidBattery\">LeadAcidBattery</a></li>
<li><a href=\"TransiEnt.Storage.Electrical.LithiumIonBattery\">LithiumIonBattery</a></li>
</ul>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>P_set real</li>
</ul>
<p>Outputs:</p>
<ul>
<li>epp</li>
<li>P_max_load_storage</li>
<li>P_max_unload_storage</li>
<li>P_storage_is</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.ElectricalStorageType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end ElectricalStorageSystem;

  redeclare type PowerToGasType = enumeration(
    FeedInStation_woStorage
                     "FeedInStation_woStorage",
    FeedInStation_Storage   "FeedInStation_Storage",
    FeedInStation_CavernComp
                     "FeedInStation_CavernComp",
    FeedInStation_Methanation_CvnCmp
                            "FeedInStation_Methanation_with_CavernCompression",
    FeedInStation_Methanation_CvnCmp_hydPort
                            "FeedInStation_Methanation_with_CavernCompression_seperateHydrogenPort",
    FeedInStation_Methanation_woStorage
                            "FeedInStation_Methanation_woStorage") "Choose power to gas type";

  redeclare model extends PowerToGasSystem(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //        Constants and  Hidden Parameters
    // _____________________________________________

    final parameter Boolean typeIsMethanation=not (powerToGasType == PowerToGasType(1) or powerToGasType == PowerToGasType(2) or powerToGasType == PowerToGasType(3)) "Choosen type is a mathanator";
    final parameter Boolean typeIsWOStorage=(powerToGasType == PowerToGasType(1) or powerToGasType == PowerToGasType(6)) "Choosen type does not include a storage";

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1 "CO2 model to be used" annotation (Dialog(tab="General", group="General"));
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_Hydrogen=simCenter.gasModel3 "Hydrogen model to be used" annotation (Dialog(tab="General", group="General"));

    parameter Boolean useVariableHydrogenFraction "true, if hydrogen fraction of PtG-plants can vary dependent on hydrogen content of gas grid";
    parameter Boolean CO2NeededForPowerToGas;
    parameter Real T_supply_max_districtHeating;
    outer parameter Modelica.Units.SI.MassFraction xi_const_noZeroMassFlow[max(simCenter.gasModel1.nc - 1, 1)];
    parameter SI.MassFlowRate m_flow_small=0 "small leackage mass flow for numerical stability";

    parameter Records.PowerToGasRecord powerToGasRecord=Records.PowerToGasRecord() annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
    parameter PowerToGasType powerToGasType=PowerToGasType.FeedInStation_Methanation_CvnCmp;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_CO2(Medium=medium_CO2) if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{95,75},{105,85}})));
    Modelica.Blocks.Interfaces.RealInput PP_m_flowGas annotation (Placement(transformation(extent={{-110,-100},{-90,-80}}), iconTransformation(extent={{-110,-100},{-90,-80}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage powerToGasPlantType1(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      medium=medium_Hydrogen,
      medium_ng=medium,
      P_el_n=powerToGasRecord.P_el_n,
      P_el_max=powerToGasRecord.P_el_n,
      eta_n=powerToGasRecord.eta_n,
      redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 (use_arrayefficiency=true),
      useFluidCoolantPort=if usageOfWasteHeatOfPtG >= 2 then true else false,
      electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare replaceable TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1)),
      T_out_coolant_target=273.15 + 67) if powerToGasType == PowerToGasType.FeedInStation_woStorage annotation (Placement(transformation(extent={{0,80},{-20,60}})));

    TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage powerToGasPlantType2(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      medium=medium_Hydrogen,
      medium_ng=medium,
      P_el_n=powerToGasRecord.P_el_n,
      P_el_max=powerToGasRecord.P_el_n,
      eta_n=powerToGasRecord.eta_n,
      redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 (use_arrayefficiency=true),
      p_maxLow=powerToGasRecord.p_maxLow,
      p_maxHigh=powerToGasRecord.p_maxHigh,
      p_minLow_constantDemand=powerToGasRecord.p_minLow_constantDemand,
      m_flow_hydrogenDemand_constant=powerToGasRecord.m_flow_internaldemand_constant,
      useFluidCoolantPort=if usageOfWasteHeatOfPtG >= 2 then true else false,
      electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare replaceable TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1)),
      T_out_coolant_target=273.15 + 67) if powerToGasType == PowerToGasType.FeedInStation_Storage annotation (Placement(transformation(extent={{0,54},{-20,34}})));

    TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp powerToGasPlantType3(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      medium_h2=medium_Hydrogen,
      medium_ng=medium,
      P_el_n=powerToGasRecord.P_el_n,
      P_el_max=powerToGasRecord.P_el_n,
      eta_n=powerToGasRecord.eta_n,
      redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 (use_arrayefficiency=true),
      p_maxLow=powerToGasRecord.p_maxLow,
      p_maxHigh=powerToGasRecord.p_maxHigh,
      p_minLow=powerToGasRecord.p_minLow,
      p_minHigh=powerToGasRecord.p_minHigh,
      p_minLow_constantDemand=powerToGasRecord.p_minLow_constantDemand,
      m_flow_hydrogenDemand_constant=powerToGasRecord.m_flow_internaldemand_constant,
      useFluidCoolantPort=if usageOfWasteHeatOfPtG >= 2 then true else false,
      electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare replaceable TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1)),
      T_out_coolant_target=273.15 + 67) if powerToGasType == PowerToGasType.FeedInStation_CavernComp annotation (Placement(transformation(extent={{0,28},{-20,8}})));

    TransiEnt.Producer.Gas.MethanatorSystem.FeedInStation_Methanation powerToGasPlantType4(
      useSeperateHydrogenOutput=useHydrogenFromPtGInPowerPlants,
      m_flow_n_Hydrogen=powerToGasRecord.MethanationPlant_m_flow_n_Hydrogen,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      medium=medium,
      medium_CO2=medium_CO2,
      heatLossCalculation=2,
      useLeakageMassFlow=true,
      useFluidCoolantPort=if usageOfWasteHeatOfPtG >= 2 then true else false,
      useVariableHydrogenFraction=useVariableHydrogenFraction,
      useCO2Input=if CO2NeededForPowerToGas then true else false,
      T_out_coolant_target=if usageOfWasteHeatOfPtG == 2 then 273.15 + 105 else T_supply_max_districtHeating + 273.15,
      redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        usePowerPort=true,
        P_el_n=powerToGasRecord.P_el_n,
        P_el_max=powerToGasRecord.P_el_n,
        eta_n=powerToGasRecord.eta_n,
        p_maxHigh=powerToGasRecord.p_maxHigh,
        p_maxLow=powerToGasRecord.p_maxLow,
        p_minLow=powerToGasRecord.p_minLow,
        p_minHigh=powerToGasRecord.p_minHigh,
        p_minLow_constantDemand=powerToGasRecord.p_minLow_constantDemand,
        m_flow_hydrogenDemand_constant=powerToGasRecord.m_flow_internaldemand_constant,
        redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 (use_arrayefficiency=true),
        electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")),
      chooseHeatSources=3) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(extent={{-14,-40},{-34,-20}})));

    TransiEnt.Producer.Gas.MethanatorSystem.FeedInStation_Methanation powerToGasPlantType6(
      useSeperateHydrogenOutput=useHydrogenFromPtGInPowerPlants,
      m_flow_n_Hydrogen=powerToGasRecord.MethanationPlant_m_flow_n_Hydrogen,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      medium=medium,
      medium_CO2=medium_CO2,
      heatLossCalculation=2,
      useLeakageMassFlow=true,
      useFluidCoolantPort=if usageOfWasteHeatOfPtG >= 2 then true else false,
      useVariableHydrogenFraction=useVariableHydrogenFraction,
      useCO2Input=if CO2NeededForPowerToGas then true else false,
      T_out_coolant_target=if usageOfWasteHeatOfPtG == 2 then 273.15 + 105 else T_supply_max_districtHeating + 273.15,
      feedInStation_Hydrogen(
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        usePowerPort=true,
        P_el_n=powerToGasRecord.P_el_n,
        P_el_max=powerToGasRecord.P_el_n,
        P_el_min=powerToGasRecord.P_el_n*powerToGasRecord.P_el_min_rel,
        eta_n=powerToGasRecord.eta_n,
        redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 (use_arrayefficiency=true),
        electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")),
      chooseHeatSources=3) if powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage annotation (Placement(transformation(extent={{18,-40},{-2,-20}})));

    //other
    TransiEnt.Components.Sensors.ElectricPowerComplex electricActivePower_PtG annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=0,
          origin={40,-30})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow2(
      medium=medium,
      m_flow_const=m_flow_small,
      xi_const=if simCenter.gasModel1.nc == 1 then simCenter.gasModel1.xi_default else xi_const_noZeroMassFlow) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=270,
          origin={66,100})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow3(
      medium=medium,
      variable_m_flow=false,
      xi_const=if simCenter.gasModel1.nc == 1 then simCenter.gasModel1.xi_default elseif simCenter.gasModel1.nc == 2 then {0} else {0,0,0,0,0,0},
      m_flow_const=m_flow_small) if useHydrogenFromPtGInPowerPlants == true annotation (Placement(transformation(
          extent={{8,8},{-8,-8}},
          rotation=90,
          origin={82,32})));
    TransiEnt.SystemGeneration.Superstructure.Components.HeatingGridSystems.WasteHeatUsage_HeatPort wasteHeatUsage_2_1(V_storage=powerToGasRecord.WasteHeatUsage_V_storage) if usageOfWasteHeatOfPtG == 2 annotation (Placement(transformation(extent={{-2,-90},{-22,-70}})));

    Modelica.Blocks.Sources.RealExpression expresseion_wasteHeatPowerOut(y=wasteHeatUsage_2_1.electricPowerOut) if usageOfWasteHeatOfPtG == 2 annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-73,-39})));

    //controller out expressions
    Modelica.Blocks.Sources.RealExpression expression_PtG1_m_flow_Type4_5(y=powerToGasPlantType4.gasPortOut.m_flow) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-83,37})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedEta_Type4_5(y=powerToGasPlantType4.feedInStation_Hydrogen.eta_n) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-83,31})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeed_m_flow_Hydrogen_Type4_5(y=powerToGasPlantType4.feedInStation_Hydrogen.electrolyzer.gasPortOut.m_flow) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-83,43})));
    Modelica.Blocks.Sources.RealExpression expresseion_PtGFeedPel_Type4_5(y=powerToGasPlantType4.feedInStation_Hydrogen.P_el_n) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-83,49})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedp_Type4_5(y=powerToGasPlantType4.feedInStation_Hydrogen.gasPortOut.p) if useHydrogenFromPtGInPowerPlants and (powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp or powerToGasType == PowerToGasType.FeedInStation_Methanation_CvnCmp_hydPort) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-83,25})));

    Modelica.Blocks.Sources.RealExpression expression_PtG1_m_flow_Type6(y=powerToGasPlantType6.gasPortOut.m_flow) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-65,37})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedEta_Type6(y=powerToGasPlantType6.feedInStation_Hydrogen.eta_n) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-65,31})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeed_m_flow_Hydrogen_Type6(y=powerToGasPlantType6.feedInStation_Hydrogen.electrolyzer.gasPortOut.m_flow) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-65,43})));
    Modelica.Blocks.Sources.RealExpression expresseion_PtGFeedPel_Type6(y=powerToGasPlantType6.feedInStation_Hydrogen.P_el_n) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-65,49})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedp_Type6(y=powerToGasPlantType6.feedInStation_Hydrogen.gasPortOut.p) if (powerToGasType == PowerToGasType.FeedInStation_Methanation_woStorage) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-65,25})));

    Modelica.Blocks.Sources.RealExpression expresseion_PtGFeedPel_Type1(y=powerToGasPlantType1.P_el_n) if powerToGasType == PowerToGasType(1) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-125,49})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeed_m_flow_Hydrogen_Type1(y=powerToGasPlantType1.electrolyzer.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(1) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-125,43})));
    Modelica.Blocks.Sources.RealExpression expression_PtG1_m_flow_Type1(y=powerToGasPlantType1.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(1) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-125,37})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedEta_Type1(y=powerToGasPlantType1.eta_n) if powerToGasType == PowerToGasType(1) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-125,31})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedp_Type1(y=powerToGasPlantType1.gasPortOut.p) if  powerToGasType == PowerToGasType(1) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-125,25})));

    Modelica.Blocks.Sources.RealExpression expresseion_PtGFeedPel_Type2(y=powerToGasPlantType2.P_el_n) if powerToGasType == PowerToGasType(2) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-111,49})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeed_m_flow_Hydrogen_Type2(y=powerToGasPlantType2.electrolyzer.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(2) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-111,43})));
    Modelica.Blocks.Sources.RealExpression expression_PtG1_m_flow_Type2(y=powerToGasPlantType2.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(2) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-111,37})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedEta_Type2(y=powerToGasPlantType2.eta_n) if powerToGasType == PowerToGasType(2) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-111,31})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedp_Type2(y=powerToGasPlantType2.gasPortOut.p) if  powerToGasType == PowerToGasType(2) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-111,25})));

    Modelica.Blocks.Sources.RealExpression expresseion_PtGFeedPel_Type3(y=powerToGasPlantType3.P_el_n) if powerToGasType == PowerToGasType(3) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-97,49})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeed_m_flow_Hydrogen_Type3(y=powerToGasPlantType3.electrolyzer.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(3) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-97,43})));
    Modelica.Blocks.Sources.RealExpression expression_PtG1_m_flow_Type3(y=powerToGasPlantType3.gasPortOut.m_flow) if  powerToGasType == PowerToGasType(3) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-97,37})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedEta_Type3(y=powerToGasPlantType3.eta_n) if powerToGasType == PowerToGasType(3) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-97,31})));
    Modelica.Blocks.Sources.RealExpression expression_PtGFeedp_Type3(y=powerToGasPlantType3.gasPortOut.p) if  powerToGasType == PowerToGasType(3) annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=180,
          origin={-97,25})));
  equation
    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________
    //Type1
    connect(powerToGasPlantType1.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{0,70},{30,70},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(powerToGasPlantType1.gasPortOut, gasPortOut_1) annotation (Line(
        points={{-10,79.9},{-10,82},{66,82},{66,-20},{100,-20}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType1.gasPortOut, boundary_Txim_flow2.gasPort) annotation (Line(
        points={{-10,79.9},{-10,82},{66,82},{66,92}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType1.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-20,79},{-20,80},{-40,80},{-40,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType1.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-20,74},{-44,74},{-44,-34},{-60,-34},{-60,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType1.m_flow_feedIn, controlBus.powerToGas_m_flowFeedIn) annotation (Line(
        points={{-20,62},{-50,62},{-50,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType1.P_el_set, controlBus.powerToGas_P_el_set) annotation (Line(
        points={{-10,59.6},{-50,59.6},{-50,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

    //Type2
    connect(powerToGasPlantType2.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{0,44},{30,44},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(powerToGasPlantType2.gasPortOut, gasPortOut_1) annotation (Line(
        points={{-10,53.9},{-10,56},{66,56},{66,-20},{100,-20}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType2.gasPortOut, boundary_Txim_flow2.gasPort) annotation (Line(
        points={{-10,53.9},{-10,56},{66,56},{66,92}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType2.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-20,53},{-20,54},{-40,54},{-40,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType2.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-20,48},{-44,48},{-44,-34},{-60,-34},{-60,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType2.m_flow_feedIn, controlBus.powerToGas_m_flowFeedIn) annotation (Line(
        points={{-20,36},{-50,36},{-50,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType2.P_el_set, controlBus.powerToGas_P_el_set) annotation (Line(
        points={{-10,33.6},{-50,33.6},{-50,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

    //Type3
    connect(powerToGasPlantType3.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{0,18},{30,18},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(powerToGasPlantType3.gasPortOut, gasPortOut_1) annotation (Line(
        points={{-10,27.9},{-10,30},{66,30},{66,-20},{100,-20}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType3.gasPortOut, boundary_Txim_flow2.gasPort) annotation (Line(
        points={{-10,27.9},{-10,30},{66,30},{66,92}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType3.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-20,27},{-20,28},{-40,28},{-40,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType3.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-20,22},{-44,22},{-44,-34},{-60,-34},{-60,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType3.m_flow_feedIn, controlBus.powerToGas_m_flowFeedIn) annotation (Line(
        points={{-20,10},{-50,10},{-50,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType3.P_el_set, controlBus.powerToGas_P_el_set) annotation (Line(
        points={{-10,7.6},{-10,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

    //Type4
    connect(powerToGasPlantType4.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{-14,-30},{-8,-30},{-8,-50},{30,-50},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(powerToGasPlantType4.gasPortOut, gasPortOut_1) annotation (Line(
        points={{-24,-39.9},{-24,-44},{66,-44},{66,-20},{100,-20}},
        color={255,255,0},
        thickness=2));
    connect(powerToGasPlantType4.gasPortOut, boundary_Txim_flow2.gasPort) annotation (Line(
        points={{-24,-39.9},{-24,-44},{66,-44},{66,92}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType4.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-34,-39},{-34,-38},{-40,-38},{-40,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType4.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-34,-34},{-60,-34},{-60,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType4.m_flow_feedIn, controlBus.powerToGas_m_flowFeedIn) annotation (Line(
        points={{-34,-22},{-38,-22},{-38,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType4.P_el_set, controlBus.powerToGas_P_el_set) annotation (Line(
        points={{-24,-19.6},{-24,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));

    connect(powerToGasPlantType4.gasPortOut_H2, gasPortOut_H2_toPowerPlant) annotation (Line(
        points={{-33.7,-30.5},{-54,-30.5},{-54,-60},{82,-60},{82,20},{100,20}},
        color={170,213,255},
        thickness=2));
    connect(powerToGasPlantType4.gasPortOut_H2, boundary_Txim_flow3.gasPort) annotation (Line(
        points={{-33.7,-30.5},{-44,-30.5},{-44,-30},{-54,-30},{-54,-62},{82,-62},{82,24}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType4.gasPortIn_CO2, gasPortIn_CO2) annotation (Line(
        points={{-18,-40},{108,-40},{108,80},{100,80}},
        color={215,215,215},
        thickness=2));
    connect(powerToGasPlantType4.fluidPortIn, wasteHeatUsage_2_1.fluidPortOut) annotation (Line(
        points={{-34,-39},{-34,-38},{-40,-38},{-40,-82},{-22,-82}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType4.fluidPortOut, wasteHeatUsage_2_1.fluidPortIn) annotation (Line(
        points={{-34,-34},{-60,-34},{-60,-78},{-22.2,-78}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType4.m_flow_feedIn_H2, controlBus.powerToGas_plant1_m_flowFeedInH2) annotation (Line(
        points={{-14.2,-22},{-14.2,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(powerToGasPlantType4.hydrogenFraction_input, controlBus.powerToGas_hydrogenFraction_input) annotation (Line(
        points={{-14.2,-38},{-14.2,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    //other connects
    connect(wasteHeatUsage_2_1.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{-12,-70},{-12,-64},{30,-64},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(wasteHeatUsage_2_1.electricPowerOut, Pel_wasteHeatBoiler) annotation (Line(points={{-16,-69},{-16,-64},{-96,-64},{-96,-40},{-104,-40}}));
    connect(wasteHeatUsage_2_1.port_a, port_a) annotation (Line(points={{-1.8,-80},{60,-80},{60,-100}}, color={191,0,0}));

    connect(P, electricActivePower_PtG.P) annotation (Line(points={{-104,-26},{-94,-26},{-94,-4},{36,-4},{36,-24.84},{37,-24.84}}));
    connect(epp_IN, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{-20,100},{-20,86},{30,86},{30,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(epp_OUT, electricActivePower_PtG.epp_OUT) annotation (Line(
        points={{16,100},{52,100},{52,-30},{45.64,-30}},
        color={28,108,200},
        thickness=0.5));

    connect(powerToGasPlantType6.epp, electricActivePower_PtG.epp_IN) annotation (Line(
        points={{18,-30},{34.48,-30}},
        color={28,108,200},
        thickness=0.5));
    connect(powerToGasPlantType6.gasPortOut, gasPortOut_1) annotation (Line(
        points={{8,-39.9},{8,-44},{66,-44},{66,-20},{100,-20}},
        color={255,255,0},
        thickness=2));
    connect(powerToGasPlantType6.gasPortOut, boundary_Txim_flow2.gasPort) annotation (Line(
        points={{8,-39.9},{8,-50},{66,-50},{66,92}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType6.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-2,-39},{-2,-54},{-40,-54},{-40,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType6.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-2,-34},{-6,-34},{-6,-58},{-60,-58},{-60,-100}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType6.m_flow_feedIn, controlBus.powerToGas_m_flowFeedIn) annotation (Line(
        points={{-2,-22},{-4,-22},{-4,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType6.P_el_set, controlBus.powerToGas_P_el_set) annotation (Line(
        points={{8,-19.6},{8,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(powerToGasPlantType6.gasPortOut_H2, gasPortOut_H2_toPowerPlant) annotation (Line(
        points={{-1.7,-30.5},{-4,-30.5},{-4,-60},{82,-60},{82,20},{100,20}},
        color={170,213,255},
        thickness=2));
    connect(powerToGasPlantType6.gasPortOut_H2, boundary_Txim_flow3.gasPort) annotation (Line(
        points={{-1.7,-30.5},{-4,-30.5},{-4,-62},{82,-62},{82,24}},
        color={255,255,0},
        thickness=1.5));
    connect(powerToGasPlantType6.gasPortIn_CO2, gasPortIn_CO2) annotation (Line(
        points={{14,-40},{108,-40},{108,80},{100,80}},
        color={215,215,215},
        thickness=2));
    connect(powerToGasPlantType6.fluidPortIn, wasteHeatUsage_2_1.fluidPortOut) annotation (Line(
        points={{-2,-39},{-2,-54},{-40,-54},{-40,-82},{-22,-82}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType6.fluidPortOut, wasteHeatUsage_2_1.fluidPortIn) annotation (Line(
        points={{-2,-34},{-6,-34},{-6,-58},{-60,-58},{-60,-78},{-22.2,-78}},
        color={175,0,0},
        thickness=0.5));
    connect(powerToGasPlantType6.m_flow_feedIn_H2, controlBus.powerToGas_plant1_m_flowFeedInH2) annotation (Line(
        points={{17.8,-22},{22,-22},{22,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(powerToGasPlantType6.hydrogenFraction_input, controlBus.powerToGas_hydrogenFraction_input) annotation (Line(
        points={{17.8,-38},{26,-38},{26,0},{-108,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(controlBus.powerToGas_wasteHeat_P_el, expresseion_wasteHeatPowerOut.y) annotation (Line(
        points={{-108,0},{-84,0},{-84,-39},{-78.5,-39}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerPlantSystem_m_flowGas, PP_m_flowGas) annotation (Line(
        points={{-108,0},{-84,0},{-84,-90},{-100,-90}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(controlBus.powerToGas_plant1_m_flowGasOut, expression_PtG1_m_flow_Type4_5.y) annotation (Line(
        points={{-108,0},{-90,0},{-90,37},{-88.5,37}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_etaFeedIn, expression_PtGFeedEta_Type4_5.y) annotation (Line(
        points={{-108,0},{-90,0},{-90,31},{-88.5,31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_m_flowHydrogen, expression_PtGFeed_m_flow_Hydrogen_Type4_5.y) annotation (Line(
        points={{-108,0},{-90,0},{-90,43},{-88.5,43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_P_el_n, expresseion_PtGFeedPel_Type4_5.y) annotation (Line(
        points={{-108,0},{-90,0},{-90,49},{-88.5,49}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_p_feedIn, expression_PtGFeedp_Type4_5.y) annotation (Line(
        points={{-108,0},{-90,0},{-90,25},{-88.5,25}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(controlBus.powerToGas_plant1_m_flowGasOut, expression_PtG1_m_flow_Type6.y) annotation (Line(
        points={{-108,0},{-72,0},{-72,34},{-70.5,34},{-70.5,37}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_etaFeedIn, expression_PtGFeedEta_Type6.y) annotation (Line(
        points={{-108,0},{-72,0},{-72,28},{-70.5,28},{-70.5,31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_m_flowHydrogen, expression_PtGFeed_m_flow_Hydrogen_Type6.y) annotation (Line(
        points={{-108,0},{-72,0},{-72,40},{-70.5,40},{-70.5,43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_P_el_n, expresseion_PtGFeedPel_Type6.y) annotation (Line(
        points={{-108,0},{-72,0},{-72,50},{-70.5,50},{-70.5,49}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_p_feedIn, expression_PtGFeedp_Type6.y) annotation (Line(
        points={{-108,0},{-72,0},{-72,22},{-70.5,22},{-70.5,25}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(controlBus.powerToGas_plant1_m_flowGasOut,expression_PtG1_m_flow_Type1. y) annotation (Line(
        points={{-108,0},{-132,0},{-132,36},{-130.5,36},{-130.5,37}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_etaFeedIn,expression_PtGFeedEta_Type1. y) annotation (Line(
        points={{-108,0},{-132,0},{-132,31},{-130.5,31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_m_flowHydrogen,expression_PtGFeed_m_flow_Hydrogen_Type1. y) annotation (Line(
        points={{-108,0},{-132,0},{-132,43},{-130.5,43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_P_el_n, expresseion_PtGFeedPel_Type1.y) annotation (Line(
        points={{-108,0},{-132,0},{-132,49},{-130.5,49}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_p_feedIn,expression_PtGFeedp_Type1. y) annotation (Line(
        points={{-108,0},{-132,0},{-132,26},{-130.5,26},{-130.5,25}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(controlBus.powerToGas_plant1_m_flowGasOut,expression_PtG1_m_flow_Type2. y) annotation (Line(
        points={{-108,0},{-118,0},{-118,36},{-116.5,36},{-116.5,37}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_etaFeedIn,expression_PtGFeedEta_Type2. y) annotation (Line(
        points={{-108,0},{-118,0},{-118,31},{-116.5,31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_m_flowHydrogen,expression_PtGFeed_m_flow_Hydrogen_Type2. y) annotation (Line(
        points={{-108,0},{-118,0},{-118,43},{-116.5,43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_P_el_n,expresseion_PtGFeedPel_Type2. y) annotation (Line(
        points={{-108,0},{-118,0},{-118,49},{-116.5,49}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_p_feedIn,expression_PtGFeedp_Type2. y) annotation (Line(
        points={{-108,0},{-118,0},{-118,26},{-116.5,26},{-116.5,25}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(controlBus.powerToGas_plant1_m_flowGasOut,expression_PtG1_m_flow_Type3. y) annotation (Line(
        points={{-108,0},{-108,36},{-102.5,36},{-102.5,37}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_etaFeedIn,expression_PtGFeedEta_Type3. y) annotation (Line(
        points={{-108,0},{-108,31},{-102.5,31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_m_flowHydrogen,expression_PtGFeed_m_flow_Hydrogen_Type3. y) annotation (Line(
        points={{-108,0},{-108,43},{-102.5,43}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_P_el_n,expresseion_PtGFeedPel_Type3. y) annotation (Line(
        points={{-108,0},{-108,49},{-102.5,49}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.powerToGas_plant1_p_feedIn,expression_PtGFeedp_Type3. y) annotation (Line(
        points={{-108,0},{-108,26},{-102.5,26},{-102.5,25}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(expression_PtG1_m_flow_Type1.y, m_flow_gas_out) annotation (Line(points={{-130.5,37},{-150,37},{-150,-56},{-104,-56}}, color={0,0,127}));
    connect(expression_PtG1_m_flow_Type2.y, m_flow_gas_out) annotation (Line(points={{-116.5,37},{-150,37},{-150,-56},{-104,-56}}, color={0,0,127}));
    connect(expression_PtG1_m_flow_Type3.y, m_flow_gas_out) annotation (Line(points={{-102.5,37},{-150,37},{-150,-56},{-104,-56}}, color={0,0,127}));
    connect(expression_PtG1_m_flow_Type4_5.y, m_flow_gas_out) annotation (Line(points={{-88.5,37},{-150,37},{-150,-56},{-104,-56}}, color={0,0,127}));
    connect(expression_PtG1_m_flow_Type6.y, m_flow_gas_out) annotation (Line(points={{-70.5,37},{-150,37},{-150,-56},{-104,-56}}, color={0,0,127}));

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the power to gas system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This definition includes the type options:</p>
<ul>
<li><a href=\"TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport\">CCP_with_Gasport</a></li>
<li><a href=\"TransiEnt.Producer.Electrical.Conventional.Gasturbine_with_Gasport\">Gasturbine_with_Gasport</a></li>
</ul>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
<li>P_el_set</li>
<li>gasPortIn and gasPortIn1</li>
</ul>
<p>Outputs:</p>
<ul>
<li>epp</li>
<li>P_max_noCCs</li>
<li>P_Powerplant_is</li>
<li>gasPortOut for CO2 deposition</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.PowerPlantType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end PowerToGasSystem;

  redeclare type GasStorageType = enumeration(
    GasStorage_constXi_L1   "L1: Model of a simple gas storage volume for constant composition",
    GasStorage_varXi_L1   "L1: Model of a simple gas storage volume for variable composition",
    GasStorage_constXi_L2   "L2: Model of a simple gas storage volume for constant composition",
    GasStorage_varXi_L2   "L2: Model of a simple gas storage volume for variable composition") "Choose gas storage";

  redeclare model extends GasStorageSystem(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
    parameter Modelica.Units.SI.Pressure p_gasGrid_desired=simCenter.p_amb_const + simCenter.p_eff_2 "desired gas grid pressure in region";
    parameter GasStorageType gasStorageType=GasStorageType.GasStorage_constXi_L1;
    parameter Records.GasStorageRecord gasStorageRecord=Records.GasStorageRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Storage.Gas.GasStorage_constXi_L1 gasStorageType1(
      medium=medium,
      V_geo=gasStorageRecord.Volume,
      m_gas_start=gasStorageRecord.m_gas_start,
      p_gas_const=gasStorageRecord.p_gas_const) if gasStorageType == GasStorageType.GasStorage_constXi_L1 annotation (Placement(transformation(extent={{-24,-10},{-4,10}})));
    TransiEnt.Storage.Gas.GasStorage_varXi_L1 gasStorageType2(
      medium=medium,
      V_geo=gasStorageRecord.Volume,
      m_gas_start=gasStorageRecord.m_gas_start,
      p_gas_const=gasStorageRecord.p_gas_const) if gasStorageType == GasStorageType.GasStorage_varXi_L1 annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    TransiEnt.Storage.Gas.GasStorage_constXi_L2 gasStorageType3(
      medium=medium,
      V_geo=gasStorageRecord.Volume,
      m_gas_start=gasStorageRecord.m_gas_start,
      p_gas_start=gasStorageRecord.p_gas_const) if gasStorageType == GasStorageType.GasStorage_constXi_L2 annotation (Placement(transformation(extent={{24,-10},{44,10}})));
    TransiEnt.Storage.Gas.GasStorage_varXi_L2 gasStorageType4(
      medium=medium,
      V_geo=gasStorageRecord.Volume,
      m_gas_start=gasStorageRecord.m_gas_start,
      p_gas_start=gasStorageRecord.p_gas_const) if gasStorageType == GasStorageType.GasStorage_varXi_L2 annotation (Placement(transformation(extent={{48,-10},{68,10}})));

    TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ValveDesiredMassFlow valveDesiredMassFlow_GasStorage(
      medium=medium,
      hysteresisWithDelta_p=false,
      Delta_p_low=-50000,
      Delta_p_high=-20000,
      p_low=10000,
      p_high=100000,
      useLeakageMassFlow=true) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={28,62})));
    Modelica.Blocks.Sources.RealExpression sourceStorage_m_gas_L1_Type1(y=gasStorageType1.m_gas) if gasStorageType == GasStorageType.GasStorage_constXi_L1 annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-50,38})));
    Modelica.Blocks.Sources.RealExpression sourceStorage_m_gas_L1_Type2(y=gasStorageType2.m_gas) if gasStorageType == GasStorageType.GasStorage_varXi_L1 annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-50,20})));
    Modelica.Blocks.Sources.RealExpression sourceStorage_m_gas_L2_Type3(y=gasStorageType3.m_gas) if gasStorageType == GasStorageType.GasStorage_constXi_L2 annotation (Placement(transformation(rotation=0, extent={{-40,-10},{-60,10}})));
    Modelica.Blocks.Sources.RealExpression sourceStorage_m_gas_L2_Type4(y=gasStorageType4.m_gas) if gasStorageType == GasStorageType.GasStorage_varXi_L2 annotation (Placement(transformation(rotation=0, extent={{-40,-30},{-60,-10}})));

    TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensor(medium=medium) annotation (Placement(transformation(extent={{68,60},{50,82}})));
    Modelica.Blocks.Sources.RealExpression realExpression annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
    TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts_isoth junction1(
      medium=medium,
      n_ports=2,
      volume=100,
      m_flow_nom=ones(2)*gasStorageRecord.m_flow_nom,
      Delta_p_nom=vector([{1}; zeros(2 - 1)])*1e4,
      p_start=p_gasGrid_desired) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=90,
          origin={80,0})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(medium=medium) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={22,-36})));

    TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor(medium=medium, xiNumber=0)
                                                                                      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=270,
          origin={90,30})));
  equation

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________
    connect(controlBus.gasStorage_m_gas, sourceStorage_m_gas_L1_Type1.y) annotation (Line(
        points={{-100,0},{-78,0},{-78,38},{-61,38}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.gasStorage_m_gas, sourceStorage_m_gas_L2_Type3.y) annotation (Line(
        points={{-100,0},{-61,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(valveDesiredMassFlow_GasStorage.gasPortIn, pressureSensor.gasPortOut) annotation (Line(
        points={{38,60.5714},{38,60},{50,60}},
        color={255,255,0},
        thickness=1.5));
    connect(controlBus.gasStorage_p_in, pressureSensor.p) annotation (Line(
        points={{-100,0},{-78,0},{-78,90},{48,90},{48,71},{49.1,71}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.gasStorage_p_gas, realExpression.y) annotation (Line(
        points={{-100,0},{-78,0},{-78,-40},{-61,-40}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(controlBus.gasStorage_mFlowDes, valveDesiredMassFlow_GasStorage.m_flowDes) annotation (Line(
        points={{-100,0},{-78,0},{-78,90},{44,90},{44,69.1429},{38,69.1429}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(junction1.gasPort[1], gasPortIn) annotation (Line(
        points={{80.3,0},{90,0},{90,-8},{100,-8}},
        color={255,255,0},
        thickness=1.5));
    connect(gasStorageType1.gasPortIn, valveDesiredMassFlow_GasStorage.gasPortOut) annotation (Line(
        points={{-14,4.9},{-14,60.5714},{18,60.5714}},
        color={255,255,0},
        thickness=1.5));
    connect(gasStorageType2.gasPortIn, valveDesiredMassFlow_GasStorage.gasPortOut) annotation (Line(
        points={{10,4.9},{10,28},{-14,28},{-14,60.5714},{18,60.5714}},
        color={255,255,0},
        thickness=1.5));
    connect(gasStorageType3.gasPortIn, valveDesiredMassFlow_GasStorage.gasPortOut) annotation (Line(
        points={{34,4.9},{32,4.9},{32,28},{-14,28},{-14,60.5714},{18,60.5714}},
        color={255,255,0},
        thickness=1.5));
    connect(gasStorageType4.gasPortIn, valveDesiredMassFlow_GasStorage.gasPortOut) annotation (Line(
        points={{58,4.9},{58,28},{-14,28},{-14,60.5714},{18,60.5714}},
        color={255,255,0},
        thickness=1.5));
    connect(boundary_Txim_flow.gasPort, gasStorageType1.gasPortOut) annotation (Line(
        points={{22,-26},{22,-20},{-14,-20},{-14,-6.3}},
        color={255,255,0},
        thickness=1.5));
    connect(boundary_Txim_flow.gasPort, gasStorageType2.gasPortOut) annotation (Line(
        points={{22,-26},{22,-20},{10,-20},{10,-6.3}},
        color={255,255,0},
        thickness=1.5));
    connect(boundary_Txim_flow.gasPort, gasStorageType3.gasPortOut) annotation (Line(
        points={{22,-26},{22,-20},{34,-20},{34,-6.3}},
        color={255,255,0},
        thickness=1.5));
    connect(boundary_Txim_flow.gasPort, gasStorageType4.gasPortOut) annotation (Line(
        points={{22,-26},{22,-20},{58,-20},{58,-6.3}},
        color={255,255,0},
        thickness=1.5));
    connect(controlBus.gasStorage_m_gas, sourceStorage_m_gas_L1_Type2.y) annotation (Line(
        points={{-100,0},{-78,0},{-78,20},{-61,20}},
        color={255,204,51},
        thickness=0.5));
    connect(controlBus.gasStorage_m_gas, sourceStorage_m_gas_L2_Type4.y) annotation (Line(
        points={{-100,0},{-78,0},{-78,-20},{-61,-20}},
        color={255,204,51},
        thickness=0.5));

    connect(gasStorageType1.m_gas, m_gas);
    connect(gasStorageType2.m_gas, m_gas);
    connect(gasStorageType3.m_gas, m_gas);
    connect(gasStorageType4.m_gas, m_gas);

    connect(controlBus.gasStorage_m_gas, m_storage) annotation (Line(
        points={{-100,0},{-78,0},{-78,90},{92,90},{92,70},{110,70}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(pressureSensor.gasPortIn, massFlowSensor.gasPortOut) annotation (Line(
        points={{68,60},{80,60},{80,40}},
        color={255,255,0},
        thickness=1.5));
    connect(massFlowSensor.gasPortIn, junction1.gasPort[2]) annotation (Line(
        points={{80,20},{80,0},{79.7,0}},
        color={255,255,0},
        thickness=1.5));
    connect(massFlowSensor.m_flow, m_flow_storage) annotation (Line(points={{90,41},{90,50},{110,50}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the gas storage system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This definition includes the type options:</p>
<ul>
<li><a href=\"TransiEnt.Storage.Gas.GasStorage_constXi_L1\">GasStorage_constXi_L1</a></li>
<li><a href=\"TransiEnt.Storage.Gas.GasStorage_varXi_L1\">GasStorage_varXi_L1</a></li>
<li><a href=\"TransiEnt.Storage.Gas.GasStorage_constXi_L2\">GasStorage_constXi_L2</a></li>
<li><a href=\"TransiEnt.Storage.Gas.GasStorage_varXi_L2\">GasStorage_varXi_L2</a></li>
</ul>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortIn</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.GasStorageType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end GasStorageSystem;

  redeclare model extends LocalDemand(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //        Constants and  Hidden Parameters
    // _____________________________________________

    final inner parameter Real LocalGasDemandMaterialUse_real=if LocalGasDemandMaterialUse then 1 else 0;
    final parameter Integer NeededGasPortsForJunction=integer(2 + LocalGasDemandMaterialUse_real + Fraction[1]/max(1, Fraction[1]) + Fraction[2]/max(1, Fraction[2]) + Fraction[7]/max(1, Fraction[7]) + Fraction[8]/max(1, Fraction[8]));

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Gas model to be used";

    parameter Real Fraction[10]=localDemandRecord.Fraction;
    parameter Modelica.Units.SI.Heat Q_demand_annual=localDemandRecord.Q_demand_annual;
    parameter Boolean LocalGasDemandMaterialUse=localDemandRecord.LocalGasDemandMaterialUse;
    parameter Modelica.Units.SI.Volume volume_junction=localDemandRecord.volume_junction;
    parameter Modelica.Units.SI.Pressure p_min=1e5;
    parameter Modelica.Units.SI.Pressure p_min_backin=2e5;
    parameter Modelica.Units.SI.Pressure p_gasGrid_desired=simCenter.p_amb_const + simCenter.p_eff_2 "desired gas grid pressure in region";

    parameter Integer n_gasPortOut_split=1 annotation (Dialog(group="GasPortSplitter"));
    parameter Real splitRatio[max(1, n_gasPortOut_split)]={0.1} annotation (Dialog(group="GasPortSplitter"));

    parameter Records.LocalDemandRecord localDemandRecord=Records.LocalDemandRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
    parameter String localElectricDemand_pathToTable;
    parameter Real localElectricDemand_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localGasDemand_pathToTable;
    parameter Real localGasDemand_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localSolarthermalProduction_pathToTable;
    parameter Real localSolarthermalProduction_constantMultiplier=1.0 "Multiply output with constant factor";

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;
    outer Modelica.Units.SI.Temperature T_region if Fraction[3] > 0;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    inner Modelica.Units.SI.HeatFlowRate Q_flow_solarthermal_pu=gain_SolarthermalProduction.y;

    TransiEnt.Basics.Tables.GenericDataTable DataTable_ElectricDemand(
      use_absolute_path=true,
      absolute_path=localElectricDemand_pathToTable,
      constantfactor=localElectricDemand_constantMultiplier) annotation (Placement(transformation(extent={{-102,-132},{-82,-112}})));

    TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load(useInputConnectorP=true, variability(
        kpf=localDemandRecord.loadVariability_kpf,
        kpu=localDemandRecord.loadVariability_kpu,
        kqf=localDemandRecord.loadVariability_kqf,
        kqu=localDemandRecord.loadVariability_kqu)) annotation (Placement(transformation(extent={{14,-146},{-6,-126}})));

    Modelica.Blocks.Math.Gain gain_HeatPump(k=if sum(Fraction) == 0 then 0 else -Fraction[3]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,72},{-40,82}})));
    Modelica.Blocks.Math.Gain gain_HeatPumpAndSolar(k=if sum(Fraction) == 0 then 0 else -Fraction[4]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,44},{-40,54}})));
    Modelica.Blocks.Math.Gain gain_GasboilerAndSolar(k=if sum(Fraction) == 0 then 0 else Fraction[2]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,100},{-40,110}})));
    Modelica.Blocks.Math.Gain gain_Gasboiler(k=if sum(Fraction) == 0 then 0 else Fraction[1]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,128},{-40,138}})));

    Modelica.Blocks.Sources.RealExpression Zero annotation (Placement(transformation(extent={{52,70},{72,90}})));

    Components.LocalHeatSupply.LocalHeatingDemand_Gasboiler_ConstantEfficiency localHeatingDemand_Gasboiler(eta_gasboiler=localDemandRecord.gasboiler_eta, tableBasedGasBurningConsumer_VariableGasComposition(medium=medium)) if Fraction[1] + Fraction[2] > 0 annotation (Placement(transformation(extent={{-6,118},{14,138}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_GasboilerAndSolar_ConstantEfficiency localHeatingDemand_GasboilerAndSolar(
      eta_gasboiler=localDemandRecord.gasboiler_eta,
      Q_annual_solarthermal=Q_demand_annual*Fraction[4]*0.2,
      Q_max_storage=Q_demand_annual*Fraction[4]*0.2/365*2,
      tableBasedGasBurningConsumer_VariableGasComposition(medium=medium)) if Fraction[2] > 0 annotation (Placement(transformation(extent={{-6,90},{14,110}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_HeatPump_simple localHeatingDemand_HeatPump(
      whichHeatPump=2,
      heatPumpElectricCharlineHeatPort_L1_1(
        COP_n=localDemandRecord.HeatPump_COP_n,
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort"),
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp) if Fraction[3] > 0 annotation (Placement(transformation(extent={{-6,62},{14,82}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_HeatPumpAndSolar_simple localHeatingDemand_HeatPumpAndSolar(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      heatPumpElectricCharlineHeatPort_L1_1(
        COP_n=localDemandRecord.HeatPumpAndSolar_COP_n,
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort"),
      whichHeatPump=2,
      Q_annual_solarthermal=Q_demand_annual*Fraction[4]*0.2,
      Q_max_storage=Q_demand_annual*Fraction[4]*0.2/365*2) if Fraction[4] > 0 annotation (Placement(transformation(extent={{-6,34},{14,54}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_HeatPump_simple localHeatingDemand_HeatPumpSole(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, heatPumpElectricCharlineHeatPort_L1_1(
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort",
        COP_n=localDemandRecord.HeatPumpSole_COP_n)) if Fraction[5] > 0 annotation (Placement(transformation(extent={{-6,6},{14,26}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_HeatPumpAndSolar_simple localHeatingDemand_HeatPumpAndSolarSole(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      heatPumpElectricCharlineHeatPort_L1_1(
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort",
        COP_n=localDemandRecord.HeatPumpAndSolarSole_COP_n),
      Q_annual_solarthermal=Q_demand_annual*Fraction[6]*0.2,
      Q_max_storage=Q_demand_annual*Fraction[6]*0.2/365*2) if Fraction[6] > 0 annotation (Placement(transformation(extent={{-6,-24},{14,-4}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_GasHeatPump_simple localHeatingDemand_GasHeatPump(whichHeatPump=2, heatPumpGasCharlineHeatPort_L1(mediumGas=medium)) if Fraction[7] > 0 annotation (Placement(transformation(extent={{-6,-56},{14,-36}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_GasHeatPumpAndSolar_simple localHeatingDemand_GasHeatPumpAndSolar(
      Q_annual_solarthermal=Q_demand_annual*Fraction[8]*0.2,
      Q_max_storage=Q_demand_annual*Fraction[8]*0.2/365*2,
      whichHeatPump=2,
      heatPumpGasCharlineHeatPort_L1(mediumGas=medium)) if Fraction[8] > 0 annotation (Placement(transformation(extent={{-6,-86},{14,-66}})));
    TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.LocalHeatingDemand_ElectricalHeater localHeatingDemand_ElectircalHeater(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, electricBoiler(
        redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
        redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort",
        eta=localDemandRecord.electricBoiler_eta)) if Fraction[9] > 0 annotation (Placement(transformation(extent={{-6,-116},{14,-96}})));

    TransiEnt.Consumer.Gas.GasConsumer_HFlow_NCV gasConsumer_HFlow(
      medium=medium,
      mode="Consumer",
      usePIDcontroller=false) if LocalGasDemandMaterialUse annotation (Placement(transformation(extent={{16,-174},{-4,-154}})));
    TransiEnt.Basics.Tables.GenericDataTable DataTable_GasDemandMaterialUse(
      use_absolute_path=true,
      absolute_path=localGasDemand_pathToTable,
      constantfactor=localGasDemand_constantMultiplier) if LocalGasDemandMaterialUse annotation (Placement(transformation(extent={{-102,-174},{-82,-154}})));
    Modelica.Blocks.Math.Gain gain_HeatPumpSole(k=if sum(Fraction) == 0 then 0 else -Fraction[5]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,18},{-40,28}})));
    Modelica.Blocks.Math.Gain gain_HeatPumpAndSolarSole(k=if sum(Fraction) == 0 then 0 else -Fraction[6]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,-12},{-40,-2}})));
    Modelica.Blocks.Math.Gain gain_GasHeatPump(k=if sum(Fraction) == 0 then 0 else -Fraction[7]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,-46},{-40,-36}})));
    Modelica.Blocks.Math.Gain gain_GasHeatPumpAndSolar(k=if sum(Fraction) == 0 then 0 else -Fraction[8]/sum(Fraction)) annotation (Placement(transformation(extent={{-50,-74},{-40,-64}})));

    TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts_isoth junction1(
      medium=medium,
      n_ports=NeededGasPortsForJunction,
      volume=volume_junction,
      m_flow_nom=ones(NeededGasPortsForJunction)*1000,
      Delta_p_nom=vector([{1}; zeros(NeededGasPortsForJunction - 1)])*1e4,
      p_start=p_gasGrid_desired) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=90,
          origin={56,40})));
    Modelica.Blocks.Math.Gain gain_SolarthermalProduction(k=1) annotation (Placement(transformation(extent={{-94,120},{-86,128}})));
    TransiEnt.Basics.Tables.GenericDataTable DataTable_SolarthermalProduction(
      use_absolute_path=true,
      absolute_path=localSolarthermalProduction_pathToTable,
      constantfactor=localSolarthermalProduction_constantMultiplier) annotation (Placement(transformation(extent={{-134,114},{-114,134}})));
    Modelica.Blocks.Math.Gain gain_ElectricalHeater(k=if sum(Fraction) == 0 then 0 else -Fraction[9]/sum(Fraction)) annotation (Placement(transformation(extent={{-52,-104},{-42,-94}})));
    Components.Controller.ControlGasPressure controlGasPressure(
      p_min=p_min,
      p_min_backin=p_min_backin,
      controllerType=Modelica.Blocks.Types.SimpleController.P,
      k=1e8,
      n_gasPortOut_split=n_gasPortOut_split,
      splitRatio=splitRatio) if LocalGasDemandMaterialUse annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
    Modelica.Blocks.Sources.RealExpression realExpression1[n_gasPortOut_split](y=gasPortOut.p) annotation (Placement(transformation(extent={{-90,-208},{-70,-188}})));

    Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{-24,-170},{-12,-158}})));
    Modelica.Blocks.Math.Product product5 annotation (Placement(transformation(extent={{-26,-76},{-14,-64}})));
    Modelica.Blocks.Math.Product product4 annotation (Placement(transformation(extent={{-26,-46},{-14,-34}})));
    Modelica.Blocks.Math.Product product3 annotation (Placement(transformation(extent={{-26,100},{-14,112}})));
    Modelica.Blocks.Math.Product product2 annotation (Placement(transformation(extent={{-26,128},{-14,140}})));

  equation

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________

    connect(load.P_el_set, DataTable_ElectricDemand.y1) annotation (Line(points={{4,-124.4},{4,-122},{-81,-122}}, color={0,0,127}));
    connect(load.epp, epp) annotation (Line(
        points={{13.8,-136},{36,-136},{36,-40},{100,-40}},
        color={0,135,135},
        thickness=0.5));
    connect(Q_flow, gain_HeatPump.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,77},{-51,77}}, color={0,0,127}));
    connect(Q_flow, gain_HeatPumpAndSolar.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,49},{-51,49}}, color={0,0,127}));
    connect(Q_flow, gain_GasboilerAndSolar.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,105},{-51,105}}, color={0,0,127}));
    connect(Q_flow, gain_Gasboiler.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,133},{-51,133}}, color={0,0,127}));
    connect(gain_HeatPumpSole.u, Q_flow) annotation (Line(points={{-51,23},{-68,23},{-68,-20},{-120,-20}}, color={0,0,127}));
    connect(gain_HeatPumpAndSolarSole.u, Q_flow) annotation (Line(points={{-51,-7},{-68,-7},{-68,-20},{-120,-20}}, color={0,0,127}));
    connect(Q_flow, gain_GasHeatPump.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,-41},{-51,-41}}, color={0,0,127}));
    connect(Q_flow, gain_GasHeatPumpAndSolar.u) annotation (Line(points={{-120,-20},{-68,-20},{-68,-69},{-51,-69}}, color={0,0,127}));

    if Fraction[1] >= 0 then
      connect(localHeatingDemand_Gasboiler.gasIn, junction1.gasPort[integer(2 + LocalGasDemandMaterialUse_real)]) annotation (Line(
          points={{14,128},{56,128},{56,40}},
          color={255,255,0},
          thickness=1.5));
    end if;

    if Fraction[2] > 0 then
      connect(localHeatingDemand_GasboilerAndSolar.gasIn, junction1.gasPort[integer(2 + LocalGasDemandMaterialUse_real + Fraction[1]/max(1, Fraction[1]))]) annotation (Line(
          points={{14,100},{56,100},{56,40}},
          color={255,255,0},
          thickness=1.5));
    end if;

    if Fraction[3] >= 0 then
      connect(gain_HeatPump.y, localHeatingDemand_HeatPump.Q_flow_set) annotation (Line(points={{-39.5,77},{-25.75,77},{-25.75,78},{-8,78}}, color={0,0,127}));
      connect(localHeatingDemand_HeatPump.epp, epp) annotation (Line(
          points={{13,79},{36,79},{36,-40},{100,-40}},
          color={0,135,135},
          thickness=0.5));
    end if;

    if Fraction[4] > 0 then
      connect(localHeatingDemand_HeatPumpAndSolar.epp, epp) annotation (Line(
          points={{13,51},{36,51},{36,-40},{100,-40}},
          color={0,135,135},
          thickness=0.5));
      connect(gain_HeatPumpAndSolar.y, localHeatingDemand_HeatPumpAndSolar.Q_flow_set) annotation (Line(points={{-39.5,49},{-22.75,49},{-22.75,50},{-8,50}}, color={0,0,127}));
    end if;

    if Fraction[5] > 0 then
      connect(gain_HeatPumpSole.y, localHeatingDemand_HeatPumpSole.Q_flow_set) annotation (Line(points={{-39.5,23},{-23.75,23},{-23.75,22},{-8,22}}, color={0,0,127}));
      connect(localHeatingDemand_HeatPumpSole.epp, epp) annotation (Line(
          points={{13,23},{36,23},{36,-40},{100,-40}},
          color={0,135,135},
          thickness=0.5));
    end if;

    if Fraction[6] > 0 then
      connect(localHeatingDemand_HeatPumpAndSolarSole.epp, epp) annotation (Line(
          points={{13,-7},{36,-7},{36,-40},{100,-40}},
          color={0,135,135},
          thickness=0.5));
      connect(gain_HeatPumpAndSolarSole.y, localHeatingDemand_HeatPumpAndSolarSole.Q_flow_set) annotation (Line(points={{-39.5,-7},{-23.75,-7},{-23.75,-8},{-8,-8}}, color={0,0,127}));
    end if;

    if Fraction[7] > 0 then
      connect(localHeatingDemand_GasHeatPump.gasIn, junction1.gasPort[integer(2 + LocalGasDemandMaterialUse_real + Fraction[1]/max(1, Fraction[1]) + Fraction[2]/max(1, Fraction[2]))]) annotation (Line(
          points={{14,-46},{56,-46},{56,40}},
          color={255,255,0},
          thickness=1.5));
    end if;

    if Fraction[8] > 0 then
      connect(localHeatingDemand_GasHeatPumpAndSolar.gasIn, junction1.gasPort[integer(2 + LocalGasDemandMaterialUse_real + Fraction[1]/max(1, Fraction[1]) + Fraction[2]/max(1, Fraction[2]) + Fraction[7]/max(1, Fraction[7]))]) annotation (Line(
          points={{14,-76},{56,-76},{56,40}},
          color={255,255,0},
          thickness=1.5));
    end if;

    if Fraction[9] > 0 then
      connect(localHeatingDemand_ElectircalHeater.epp, epp) annotation (Line(
          points={{13,-99},{36,-99},{36,-40},{100,-40}},
          color={0,135,135},
          thickness=0.5));
      connect(gain_ElectricalHeater.y, localHeatingDemand_ElectircalHeater.Q_flow_set) annotation (Line(points={{-41.5,-99},{-25.75,-99},{-25.75,-100},{-8,-100}}, color={0,0,127}));
    end if;

    if LocalGasDemandMaterialUse then
      connect(gasConsumer_HFlow.fluidPortIn, junction1.gasPort[2]) annotation (Line(
          points={{16,-164},{56,-164},{56,40}},
          color={255,255,0},
          thickness=1.5));
    end if;

    connect(junction1.gasPort[1], gasPortOut) annotation (Line(
        points={{56,40},{100,40}},
        color={255,255,0},
        thickness=1.5));
    connect(gain_SolarthermalProduction.u, DataTable_SolarthermalProduction.y1) annotation (Line(points={{-94.8,124},{-113,124}}, color={0,0,127}));
    connect(gain_ElectricalHeater.u, Q_flow) annotation (Line(points={{-53,-99},{-68,-99},{-68,-20},{-120,-20}}, color={0,0,127}));

    connect(realExpression1.y, controlGasPressure.p_gas) annotation (Line(points={{-69,-198},{-62,-198}}, color={0,0,127}));

    connect(gain_GasHeatPump.y, product4.u1) annotation (Line(points={{-39.5,-41},{-36,-41},{-36,-36.4},{-27.2,-36.4}}, color={0,0,127}));
    connect(gain_GasboilerAndSolar.y, product3.u1) annotation (Line(points={{-39.5,105},{-36,105},{-36,109.6},{-27.2,109.6}}, color={0,0,127}));
    connect(gain_Gasboiler.y, product2.u1) annotation (Line(points={{-39.5,133},{-36,133},{-36,137.6},{-27.2,137.6}}, color={0,0,127}));
    connect(gain_GasHeatPumpAndSolar.y, product5.u1) annotation (Line(points={{-39.5,-69},{-34,-69},{-34,-66.4},{-27.2,-66.4}}, color={0,0,127}));
    connect(DataTable_GasDemandMaterialUse.y1, product1.u1) annotation (Line(points={{-81,-164},{-38,-164},{-38,-160.4},{-25.2,-160.4}}, color={0,0,127}));
    connect(product2.u2, controlGasPressure.y) annotation (Line(points={{-27.2,130.4},{-32,130.4},{-32,-190},{-39,-190}}, color={0,0,127}));
    connect(product1.u2, controlGasPressure.y) annotation (Line(points={{-25.2,-167.6},{-32,-167.6},{-32,-190},{-39,-190}}, color={0,0,127}));
    connect(product5.u2, controlGasPressure.y) annotation (Line(points={{-27.2,-73.6},{-32,-73.6},{-32,-190},{-39,-190}}, color={0,0,127}));
    connect(product4.u2, controlGasPressure.y) annotation (Line(points={{-27.2,-43.6},{-32,-43.6},{-32,-190},{-39,-190}}, color={0,0,127}));
    connect(product3.u2, controlGasPressure.y) annotation (Line(points={{-27.2,102.4},{-32,102.4},{-32,-190},{-39,-190}}, color={0,0,127}));
    connect(product3.y, localHeatingDemand_GasboilerAndSolar.Q_flow_set) annotation (Line(points={{-13.4,106},{-8,106}}, color={0,0,127}));
    connect(product2.y, localHeatingDemand_Gasboiler.Q_flow_set) annotation (Line(points={{-13.4,134},{-8,134}}, color={0,0,127}));
    connect(product4.y, localHeatingDemand_GasHeatPump.Q_flow_set) annotation (Line(points={{-13.4,-40},{-8,-40}}, color={0,0,127}));
    connect(product5.y, localHeatingDemand_GasHeatPumpAndSolar.Q_flow_set) annotation (Line(points={{-13.4,-70},{-8,-70}}, color={0,0,127}));
    connect(product1.y, gasConsumer_HFlow.H_flow) annotation (Line(points={{-11.4,-164},{-5,-164}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the local demand to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Included are electric demand, direct gas demand and heat demand. Tables are used to set the demand profiles.</p>
<p>The heat demand is fulfilled by a variable mix of technologies:</p>
<ul>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_Gasboiler_ConstantEfficiency\">Gas boiler</a></li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_GasboilerAndSolar_ConstantEfficiency\">Gas boiler and solar</a></li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_HeatPump_simple\">Heat pump</a></li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_HeatPumpAndSolar_simple\">Heat pump and solar</a></li>
<li>Heat pump and sole</li>
<li>Heat pump and solar sole</li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_GasHeatPump_simple\">Gas heat pump</a></li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_GasHeatPumpAndSolar_simple\">Gas heat pump and solar</a></li>
<li><a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.LocalHeatSupply.LocalHeatingDemand_ElectricalHeater\">Electric heater</a></li>
</ul>
<p>The usage fraction of each technology is set in the parameter record.</p>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>Q_flow</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>Load</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end LocalDemand;

  redeclare model extends LocalRenewableProduction(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //        Constants and  Hidden Parameters
    // _____________________________________________

    final parameter String input_table_path=TransiEnt.SystemGeneration.Superstructure.Types.SUPERSTRUCTURE_TABLES annotation (
      Evaluate=true,
      HideResult=true,
      Dialog(enable=not use_absolute_path, group="Data location"));

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Gas model to be used";

    parameter Boolean useWindOffshoreInThisRegion;

    //outer parameter Integer Region;

    parameter Records.LocalRenewableProductionRecord localRenewableProductionRecord=Records.LocalRenewableProductionRecord() annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

    parameter String localBiogasProduction_pathToTable;
    parameter Real localBiogasProduction_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localWindOffshoreProduction_pathToTable;
    parameter Real localWindOffshoreProduction_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localBiomassProduction_pathToTable;
    parameter Real localBiomassProduction_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localPhotovoltaicProduction_pathToTable;
    parameter Real localPhotovoltaicProduction_constantMultiplier=1.0 "Multiply output with constant factor";
    parameter String localWindOnshoreProduction_pathToTable;
    parameter Real localWindOnshoreProduction_constantMultiplier=1.0 "Multiply output with constant factor";

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Basics.Tables.GenericDataTable WindOnshore_Profile(
      use_absolute_path=true,
      absolute_path=localWindOnshoreProduction_pathToTable,
      constantfactor=localWindOnshoreProduction_constantMultiplier) annotation (Placement(transformation(extent={{-100,68},{-80,88}})));

    TransiEnt.Basics.Tables.GenericDataTable PV_Profile(
      use_absolute_path=true,
      absolute_path=localPhotovoltaicProduction_pathToTable,
      constantfactor=localPhotovoltaicProduction_constantMultiplier) annotation (Placement(transformation(extent={{-100,26},{-80,46}})));
    TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant windOnshorePlant(
      P_el_n=1,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.InverterQcurve powerBoundary) annotation (Placement(transformation(extent={{40,60},{60,80}})));
    TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant PVPlant(
      P_el_n=1,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.InverterQcurve powerBoundary) annotation (Placement(transformation(extent={{40,20},{60,40}})));
    TransiEnt.Basics.Tables.GenericDataTable WindOffshore_Profile(
      use_absolute_path=true,
      absolute_path=localWindOffshoreProduction_pathToTable,
      constantfactor=localWindOffshoreProduction_constantMultiplier) if useWindOffshoreInThisRegion annotation (Placement(transformation(extent={{-100,-74},{-80,-54}})));

    TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOffshorePlant(
      P_el_n=1,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.InverterQcurve powerBoundary) if useWindOffshoreInThisRegion annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

    TransiEnt.Producer.Electrical.Conventional.Components.SimplePowerPlant BiomassPlant(
      typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable,
      typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Biomass,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
      redeclare TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex Generator,
      isSecondaryControlActive=false,
      isExternalSecondaryController=false,
      redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort Exciter,
      J=1e7,
      primaryBalancingController(useHomotopyVarSlewRateLim=false)) annotation (Placement(transformation(extent={{26,-32},{46,-12}})));

    TransiEnt.Basics.Tables.GenericDataTable Bio_Profile(
      use_absolute_path=true,
      absolute_path=localBiomassProduction_pathToTable,
      constantfactor=localBiomassProduction_constantMultiplier) annotation (Placement(transformation(extent={{-100,-24},{-80,-4}})));
    Modelica.Blocks.Math.MultiSum multiSum(nu=if useWindOffshoreInThisRegion then 4 else 3) annotation (Placement(transformation(extent={{-8,102},{4,114}})));

    Modelica.Blocks.Math.Add curtailmentMinusWindOffshore if useWindOffshoreInThisRegion annotation (Placement(transformation(extent={{-38,-68},{-18,-48}})));
    Modelica.Blocks.Nonlinear.Limiter curtailedWindOffshore(
      uMax=0,
      uMin=-1e99,
      strict=false) if useWindOffshoreInThisRegion annotation (Placement(transformation(extent={{-8,-64},{4,-52}})));
    Modelica.Blocks.Nonlinear.Limiter ResidualCurtailmentAfterBioMass(
      uMax=1e99,
      uMin=0,
      strict=false) annotation (Placement(transformation(extent={{-8,-36},{4,-24}})));
    Modelica.Blocks.Math.Add curtailmentMinusWindOnshore annotation (Placement(transformation(extent={{-38,74},{-18,94}})));
    Modelica.Blocks.Math.Add curtailmentMinusPV annotation (Placement(transformation(extent={{-38,32},{-18,52}})));
    Modelica.Blocks.Nonlinear.Limiter curtailedWindOnshore(
      uMax=0,
      uMin=-1e99,
      strict=false) annotation (Placement(transformation(extent={{-8,78},{4,90}})));
    Modelica.Blocks.Nonlinear.Limiter ResidualCurtailmentAfterWindOnshore(
      uMax=1e99,
      uMin=0,
      strict=false) annotation (Placement(transformation(extent={{-8,60},{4,72}})));
    Modelica.Blocks.Math.Add curtailmentMinusBioMass annotation (Placement(transformation(extent={{-38,-18},{-18,2}})));
    Modelica.Blocks.Nonlinear.Limiter ResidualCurtailmentAfterPV(
      uMax=1e99,
      uMin=0,
      strict=false) annotation (Placement(transformation(extent={{-8,18},{4,30}})));
    Modelica.Blocks.Nonlinear.Limiter curtailedPV(
      uMax=0,
      uMin=-1e99,
      strict=false) annotation (Placement(transformation(extent={{-8,36},{4,48}})));
    Modelica.Blocks.Nonlinear.Limiter curtailedBioMass(
      uMin=-1e99,
      uMax=-1e-4,
      strict=false) annotation (Placement(transformation(extent={{-8,-14},{4,-2}})));
    TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine1_2(
      HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
      p=350,
      ChooseVoltageLevel=4,
      r_custom=0,
      l(displayUnit="m") = 200) if not simCenter.idealSuperstructLocalGrid annotation (Placement(transformation(extent={{68,-22},{54,-8}})));
    TransiEnt.Consumer.Gas.GasConsumer_HFlow_NCV bioGas_HFlow(
      medium=medium,
      xi_const=if simCenter.gasModel1.nc == 1 then simCenter.gasModel1.xi_default elseif simCenter.gasModel1.nc == 2 then {1} else {0.874,0,0,0,0,1 - 0.874},
      mode="Producer",
      usePIDcontroller=false) annotation (Placement(transformation(extent={{60,-110},{40,-90}})));
    TransiEnt.Basics.Tables.GenericDataTable Biogas_Profile(
      use_absolute_path=true,
      absolute_path=localBiogasProduction_pathToTable,
      constantfactor=localBiogasProduction_constantMultiplier) annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
    TransiEnt.Components.Electrical.Grid.IdealCoupling transmissionLine if simCenter.idealSuperstructLocalGrid annotation (Placement(transformation(extent={{54,-40},{68,-26}})));

  equation

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________

    connect(P_RE_potential, multiSum.y) annotation (Line(points={{110,92},{70,92},{70,108},{5.02,108}}, color={0,0,127}));

    connect(WindOnshore_Profile.y1, curtailmentMinusWindOnshore.u2) annotation (Line(points={{-79,78},{-40,78}}, color={0,0,127}));
    connect(PV_Profile.y1, curtailmentMinusPV.u2) annotation (Line(points={{-79,36},{-40,36}}, color={0,0,127}));
    connect(curtailmentMinusWindOnshore.y, curtailedWindOnshore.u) annotation (Line(points={{-17,84},{-9.2,84}}, color={0,0,127}));
    connect(curtailedWindOnshore.y, windOnshorePlant.P_el_set) annotation (Line(points={{4.6,84},{48.5,84},{48.5,79.9}}, color={0,0,127}));
    connect(curtailmentMinusWindOnshore.y, ResidualCurtailmentAfterWindOnshore.u) annotation (Line(points={{-17,84},{-14,84},{-14,66},{-9.2,66}}, color={0,0,127}));
    connect(ResidualCurtailmentAfterWindOnshore.y, curtailmentMinusPV.u1) annotation (Line(points={{4.6,66},{12,66},{12,52},{-48,52},{-48,48},{-40,48}}, color={0,0,127}));
    connect(Bio_Profile.y1, curtailmentMinusBioMass.u2) annotation (Line(points={{-79,-14},{-40,-14}}, color={0,0,127}));
    connect(curtailmentMinusPV.y, curtailedPV.u) annotation (Line(points={{-17,42},{-9.2,42}}, color={0,0,127}));
    connect(curtailedPV.y, PVPlant.P_el_set) annotation (Line(points={{4.6,42},{48.5,42},{48.5,39.9}}, color={0,0,127}));
    connect(curtailmentMinusPV.y, ResidualCurtailmentAfterPV.u) annotation (Line(points={{-17,42},{-16,42},{-16,24},{-9.2,24}}, color={0,0,127}));
    connect(ResidualCurtailmentAfterPV.y, curtailmentMinusBioMass.u1) annotation (Line(points={{4.6,24},{10,24},{10,10},{-50,10},{-50,-2},{-40,-2}}, color={0,0,127}));
    connect(curtailmentMinusBioMass.y, curtailedBioMass.u) annotation (Line(points={{-17,-8},{-9.2,-8}}, color={0,0,127}));
    connect(curtailedBioMass.y, BiomassPlant.P_el_set) annotation (Line(points={{4.6,-8},{34.5,-8},{34.5,-12.1}}, color={0,0,127}));
    connect(P_curtailment, curtailmentMinusWindOnshore.u1) annotation (Line(points={{-120,96},{-40,96},{-40,90}}, color={0,0,127}));
    connect(curtailmentMinusBioMass.y, ResidualCurtailmentAfterBioMass.u) annotation (Line(points={{-17,-8},{-14,-8},{-14,-30},{-9.2,-30}}, color={0,0,127}));
    if useWindOffshoreInThisRegion then
      connect(WindOffshore_Profile.y1, curtailmentMinusWindOffshore.u2) annotation (Line(points={{-79,-64},{-40,-64}}, color={0,0,127}));
      connect(curtailmentMinusWindOffshore.y, curtailedWindOffshore.u) annotation (Line(points={{-17,-58},{-9.2,-58}}, color={0,0,127}));
      connect(ResidualCurtailmentAfterBioMass.y, curtailmentMinusWindOffshore.u1) annotation (Line(points={{4.6,-30},{8,-30},{8,-42},{-50,-42},{-50,-52},{-40,-52}}, color={0,0,127}));
      connect(curtailedWindOffshore.y, WindOffshorePlant.P_el_set) annotation (Line(points={{4.6,-58},{48,-58},{48,-60.1},{48.5,-60.1}}, color={0,0,127}));
      connect(WindOffshore_Profile.y1, multiSum.u[4]) annotation (Line(points={{-79,-64},{-72,-64},{-72,108},{-8,108}}, color={0,0,127}));
    end if;
    connect(WindOnshore_Profile.y1, multiSum.u[1]) annotation (Line(points={{-79,78},{-66,78},{-66,108},{-8,108}}, color={0,0,127}));
    connect(PV_Profile.y1, multiSum.u[2]) annotation (Line(points={{-79,36},{-68,36},{-68,108},{-8,108}}, color={0,0,127}));
    connect(Bio_Profile.y1, multiSum.u[3]) annotation (Line(points={{-79,-14},{-70,-14},{-70,108},{-8,108}}, color={0,0,127}));
    connect(WindOffshorePlant.epp, epp) annotation (Line(
        points={{59,-63},{76,-63},{76,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(PVPlant.epp, epp) annotation (Line(
        points={{59,37},{76,37},{76,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(windOnshorePlant.epp, epp) annotation (Line(
        points={{59,77},{76,77},{76,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(BiomassPlant.epp, TransmissionLine1_2.epp_n) annotation (Line(
        points={{45,-15},{54,-15}},
        color={28,108,200},
        thickness=0.5));
    connect(TransmissionLine1_2.epp_p, epp) annotation (Line(
        points={{68,-15},{76,-15},{76,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(Biogas_Profile.y1, bioGas_HFlow.H_flow) annotation (Line(points={{-79,-100},{39,-100}}, color={0,0,127}));
    connect(bioGas_HFlow.fluidPortIn, gasPortOut) annotation (Line(
        points={{60,-100},{80,-100},{80,-60},{100,-60}},
        color={255,255,0},
        thickness=1.5));
    connect(transmissionLine.epp_n, epp) annotation (Line(
        points={{68,-33},{72,-33},{72,-34},{76,-34},{76,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
    connect(transmissionLine.epp_p, BiomassPlant.epp) annotation (Line(
        points={{54,-33},{54,-22},{45,-22},{45,-15}},
        color={28,108,200},
        thickness=0.5));

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the local renewable production to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Included are electrical production by</p>
<ul>
<li>Wind onshore</li>
<li>Photovoltaics</li>
<li>Biomass plants</li>
<li>Wind offshore</li>
</ul>
<p>and biogas production. Tables are used to set the production profiles.</p>
<p><br>The electrical power feed-in can be curtailed with input P_curtailment. The curtailment order corresponds to the list above.</p><p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>P_curtailment</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>P_RE_potential</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end LocalRenewableProduction;

  redeclare model extends CO2System(redeclare package Config = Portfolio_Example)

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter SI.Mass m_start_CO2_storage=cO2SystemRecord.m_start_CO2_storage;
    final parameter Integer idx_CO2=Modelica.Math.BooleanVectors.firstTrueIndex(Modelica.Utilities.Strings.isEqual(fill("Carbon_Dioxide", medium.nc), TransiEnt.Basics.Functions.GasProperties.shortenCompName(medium.vleFluidNames)));
    parameter Records.CO2SystemRecord cO2SystemRecord=Records.CO2SystemRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Storage.Gas.GasStorage_constXi_L1 gasStorage_CO2(
      medium=medium,
      m_gas_start=m_start_CO2_storage,
      useXiConstParameter=true,
      xi_const=cat(
                1,
                zeros(idx_CO2 - 1),
                {1},
                zeros(medium.nc - 1 - idx_CO2))) if CO2StorageNeeded > 0 annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(
      medium=medium,
      m_flow_const=-simCenter.m_flow_small,
      xi_const=cat(
                1,
                zeros(idx_CO2 - 1),
                {1},
                zeros(medium.nc - 1 - idx_CO2))) if CO2StorageNeeded > 0 annotation (Placement(transformation(extent={{-26,10},{-16,20}})));

    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow6(
      medium=medium,
      m_flow_const=simCenter.m_flow_small,
      xi_const=cat(
                1,
                zeros(idx_CO2 - 1),
                {1},
                zeros(medium.nc - 1 - idx_CO2))) if CO2StorageNeeded > 0 annotation (Placement(transformation(extent={{-26,-16},{-16,-6}})));

    Modelica.Blocks.Sources.RealExpression expression_m_gas_storage(y=gasStorage_CO2.m_gas) if CO2StorageNeeded > 0 annotation (Placement(transformation(rotation=0, extent={{-28,-38},{-48,-18}})));

    TransiEnt.Producer.Gas.MethanatorSystem.DirectAirCapture_L1 cO2CaptureFromAir_2_1(
      medium=medium,
      redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1),
      EnergyDemandThermal=cO2SystemRecord.DirectAirCapture_EnergyDemandThermal,
      EnergyDemandElectrical=cO2SystemRecord.DirectAirCapture_EnergyDemandElectrical,
      redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-8,38},{8,54}})));

    Modelica.Blocks.Sources.RealExpression expression_co2Capture(y=cO2CaptureFromAir_2_1.product1.y) if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{-28,-10},{-48,10}})));

    TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor(medium=medium, xiNumber=0)
                                                                                      annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=0,
          origin={60,-14})));
    TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor1(medium=medium, xiNumber=0)
                                                                                      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={60,16})));

  equation
    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________
    connect(boundary_Txim_flow.gasPort, gasStorage_CO2.gasPortIn) annotation (Line(
        points={{-16,15},{-16,6.9},{-2,6.9}},
        color={215,215,215},
        thickness=1.5));
    connect(boundary_Txim_flow6.gasPort, gasStorage_CO2.gasPortOut) annotation (Line(
        points={{-16,-11},{-16,-4.3},{-2,-4.3}},
        color={215,215,215},
        thickness=1.5));

    for i in 1:nPowerPlants loop
      connect(gasPortIn[i], massFlowSensor1.gasPortIn) annotation (Line(
          points={{102,60},{100,60},{100,6},{70,6},{70,6}},
          thickness=1,
          color={215,215,215}));
    end for;

    connect(massFlowSensor1.gasPortOut, gasStorage_CO2.gasPortIn) annotation (Line(
        points={{50,6},{-2,6},{-2,6.9}},
        color={215,215,215},
        thickness=1.5));

    connect(gasStorage_CO2.gasPortOut, massFlowSensor.gasPortIn) annotation (Line(
        points={{-2,-4.3},{24,-4.3},{24,-4},{50,-4}},
        color={215,215,215},
        thickness=1.5));
    connect(massFlowSensor.gasPortOut, gasPortOut) annotation (Line(
        points={{70,-4},{100,-4},{100,-40}},
        color={215,215,215},
        thickness=1.5));

    connect(controlBus.co2System_m_gasStorage, expression_m_gas_storage.y) annotation (Line(
        points={{-100,0},{-72,0},{-72,-28},{-49,-28}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(cO2CaptureFromAir_2_1.gasPortOut_CO2, gasStorage_CO2.gasPortIn) annotation (Line(
        points={{8,46},{20,46},{20,6},{-2,6},{-2,6.9}},
        color={215,215,215},
        thickness=1.5));
    connect(epp, cO2CaptureFromAir_2_1.epp) annotation (Line(points={{60,102},{60,51.6},{7.2,51.6}}, color={28,108,200}));
    connect(port_a, cO2CaptureFromAir_2_1.port_a) annotation (Line(points={{-60,100},{-60,46},{-8,46}}, color={191,0,0}));
    connect(controlBus.co2System_mCO2FromAir, cO2CaptureFromAir_2_1.mCO2FromAir) annotation (Line(
        points={{-100,0},{-72,0},{-72,52.4},{-9.6,52.4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(controlBus.co2System_CaptureFromAir_Q, expression_co2Capture.y) annotation (Line(
        points={{-100,0},{-49,0}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(P_el, expression_co2Capture.y) annotation (Line(
        points={{-104,-20},{-54,-20},{-54,0},{-49,0}},
        color={0,135,135},
        pattern=LinePattern.Dash));

    connect(massFlowSensor.m_flow, m_flow_toPtG) annotation (Line(points={{71,-14},{86,-14},{86,-88},{110,-88}}, color={0,0,127}));
    connect(massFlowSensor1.m_flow, m_flow_fromPowerplants) annotation (Line(points={{49,16},{42,16},{42,-68},{110,-68}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of CO2 storage and direct air capture to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Storage and DAC are L1 components </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>heat port for DAC</li>
<li>gasPortIn</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>P_el for DAC</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end CO2System;

  redeclare model extends HeatingGrid

  // _____________________________________________
    //
    //        Constants and  Hidden Parameters
    // _____________________________________________

    parameter Modelica.Units.NonSI.Temperature_degC T_wasteHeat=68;
    parameter Modelica.Units.NonSI.Temperature_degC T_supply_max_districtHeating=149;
    parameter Modelica.Units.NonSI.Temperature_degC T_return_min_districtHeating=49;
    parameter Integer controlPeakBoiler=heatingGridSystemStorageRecord.controlPeakBoiler "heat flow control of peak boiler" annotation (choices(
        __Dymola_radioButtons=true,
        choice=1 "Electric Boiler first",
        choice=2 "Gas Boiler first"));

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________
    parameter Records.HeatingGridSystemStorageRecord heatingGridSystemStorageRecord=Records.HeatingGridSystemStorageRecord() annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

    inner parameter Integer QuantityOfCHPPlantType[:]={0,0,0,0,0} "Choose CHP plant type 1" annotation (Dialog(
        tab="CHPPlants",
        group="Quantity of CHP plants",
        enable=if DifferentTypesOfCHPPlants >= 1 then true else false));
    inner parameter Integer QuantityOfElectricHeaterType[:]={0,0,0,0,0} "Choose PowerToGas-Plant type 1" annotation (Dialog(
        tab="PowerToGas-Plants",
        group="Quantity of PowerToGas-Plants",
        enable=if DifferentTypesOfPowerToGasPlants >= 1 then true else false));

    parameter Boolean CHPPlantsInThisRegion;
    parameter Boolean ElectricalHeaterInThisRegion;

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_water=simCenter.fluid1;
    parameter Real gridLosses=heatingGridSystemStorageRecord.gridLosses_districtHeating;
    inner parameter Modelica.Units.SI.HeatFlowRate Q_flow_max=heatingGridSystemStorageRecord.Q_flow_max;
    //final outer parameter Real InformationRegion_CHPPlants[:,:];
    final parameter Integer DifferentTypesOfCHPPlants;
    //final outer parameter Real InformationRegion_ElectricHeater[:,:];
    final parameter Integer DifferentTypesOfElectricHeater;
    final parameter Boolean UseHeatStorage=false;

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary(
      useInputConnectorP=false,
      P_el_set_const=0,
      useInputConnectorQ=false,
      useCosPhi=true)                                                             annotation (Placement(transformation(extent={{80,-60},{60,-40}})));

    TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
    TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatflow_L1_1(
      Medium=medium_water,
      Q_flow_const=0,
      use_Q_flow_in=false) annotation (Placement(transformation(extent={{-8,-60},{12,-40}})));
    Modelica.Blocks.Sources.RealExpression realExpression_zero annotation (Placement(transformation(extent={{60,64},{80,84}})));

  equation
    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________

    if useExternalHeatSource then
    end if;

    connect(epp, pQBoundary.epp) annotation (Line(
        points={{100,-50},{80,-50}},
        color={28,108,200},
        thickness=0.5));
    connect(boundary_Txim_flow.gasPort, gasPortIn) annotation (Line(
        points={{80,-90},{100,-90}},
        color={255,255,0},
        thickness=1.5));
    connect(heatflow_L1_1.fluidPortIn, WaterPortIn_ExternalHeatSource) annotation (Line(
        points={{-4,-60},{-4,-92},{-40,-92},{-40,-102}},
        color={175,0,0},
        thickness=0.5));
    connect(heatflow_L1_1.fluidPortOut, WaterPortOut_ExternalHeatSource) annotation (Line(
        points={{8,-60},{8,-92},{40,-92},{40,-102}},
        color={175,0,0},
        thickness=0.5));
  connect(P_ElectricalHeater_max, realExpression_zero.y) annotation (Line(points={{114,90},{90,90},{90,74},{81,74}}, color={0,0,127}));
  connect(P_el_CHP, realExpression_zero.y) annotation (Line(points={{114,60},{90,60},{90,74},{81,74}}, color={0,0,127}));
  connect(m_flow_gas, realExpression_zero.y) annotation (Line(points={{114,30},{90,30},{90,74},{81,74}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of a local heating grid to be used inside a superstructure.  Model is in developement and not usable</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end HeatingGrid;
end Portfolio_Example;
