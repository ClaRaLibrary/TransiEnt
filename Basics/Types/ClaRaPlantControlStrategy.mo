within TransiEnt.Basics.Types;
type ClaRaPlantControlStrategy = enumeration(
    FP "Fixed pressure operation",
    NSP "Natural sliding pressure operation",
    MSP "Modified sliding pressure operation (y=const)") "Control strategy for steam plants with clausius rankine process" annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Ellipse(
        extent={{-20,22},{22,-20}},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None)}));
