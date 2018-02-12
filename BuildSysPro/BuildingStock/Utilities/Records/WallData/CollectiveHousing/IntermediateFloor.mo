within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing;
record IntermediateFloor =
   BuildSysPro.Utilities.Icons.HorizontalInternalWall (
    n=1,
    m={5},
    e={0.18},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={0}) "Intermediate floor collective housing"
  annotation (Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
