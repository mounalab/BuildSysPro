﻿within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2012_STD;
record Door =
    BuildSysPro.Utilities.Icons.Door (
    n=1,
    m={2},
    e={0.05},
    mat={BuildSysPro.Utilities.Data.Solids.MetalComplexDoor9()},
    positionIsolant={1}) "Exterior door Mozart standard RT2012"
                                               annotation (Icon(graphics),
                           Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
