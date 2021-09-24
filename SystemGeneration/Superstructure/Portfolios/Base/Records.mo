within TransiEnt.SystemGeneration.Superstructure.Portfolios.Base;
partial package Records "These Records contains parameters that are different for each region or for different instances in a single region"


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


  replaceable partial record ElectricalStorageRecord

  end ElectricalStorageRecord;

  replaceable partial record GasStorageRecord

  end GasStorageRecord;

  replaceable partial record PowerPlantRecord

  end PowerPlantRecord;

  replaceable partial record LocalDemandRecord

  end LocalDemandRecord;

  replaceable partial record LocalRenewableProductionRecord

  end LocalRenewableProductionRecord;

  replaceable partial record CO2SystemRecord

  end CO2SystemRecord;

  replaceable partial record PowerToGasRecord

  end PowerToGasRecord;

  replaceable partial record HeatingGridSystemStorageRecord

  end HeatingGridSystemStorageRecord;

  replaceable partial package InstancesRecords "These records contain definitions of a system type and parametrization for each region "
    replaceable partial record ElectricalStorageInstancesRecord

    end ElectricalStorageInstancesRecord;

    replaceable partial record GasStorageInstancesRecord

    end GasStorageInstancesRecord;

    replaceable partial record PowerPlantInstancesRecord

    end PowerPlantInstancesRecord;

    replaceable partial record LocalDemandInstancesRecord

    end LocalDemandInstancesRecord;

    replaceable partial record LocalRenewableProductionInstancesRecord

    end LocalRenewableProductionInstancesRecord;

    replaceable partial record CO2SystemInstancesRecord

    end CO2SystemInstancesRecord;

    replaceable partial record PowerToGasInstancesRecord

    end PowerToGasInstancesRecord;

    replaceable partial record HeatingGridSystemStorageInstancesRecord

    end HeatingGridSystemStorageInstancesRecord;
    annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          fillPattern=FillPattern.None,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,-72}},
          radius=25,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,-72},{100,-86}},
          fillColor={0,122,122},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
                       Line(points={{-100,38},{100,38}},       color={64,64,64}),
            Line(
            origin={0,-12},
            points={{-100.0,0.0},{100.0,0.0}},
            color={64,64,64}),Line(
            origin={0,25},
            points={{0,75},{0,-97}},
            color={64,64,64})}));
  end InstancesRecords;
  annotation (Icon(graphics={
      Rectangle(
        lineColor={200,200,200},
        fillColor={248,248,248},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100,-100},{100,100}},
        radius=25.0),
      Rectangle(
        lineColor={128,128,128},
        fillPattern=FillPattern.None,
        extent={{-100,-100},{100,100}},
        radius=25.0),
      Rectangle(
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid,
        extent={{-100,-100},{100,-72}},
        radius=25,
        pattern=LinePattern.None),
      Rectangle(
        extent={{-100,-72},{100,-86}},
        fillColor={0,122,122},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
                     Line(points={{-100,38},{100,38}},       color={64,64,64}),
          Line(
          origin={0,-12},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),Line(
          origin={0,25},
          points={{0,75},{0,-97}},
          color={64,64,64})}));
end Records;
