﻿within BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones;
model ZoneLiving

  // Choice of RT (French building regulation)
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group="Choice of RT"));

  // Orientation of the apartment
parameter Integer EmplacementAppartement=5
    "From 1 to 9, define the position of the apartment : 1 to 3 last floor - 4 à 6 intermediate floor - 7 à 9 : ground floor (from west to east)";

  // Thermal flows
parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"                         annotation(Dialog(tab="Thermal flows"));
parameter Boolean CLOintPlancher=true
    "True : solar fluxes are absorbed by the floor; False : solar fluxes are absorbed by all the walls and partition walls in proportion of surfaces"
                                                                                                        annotation(Dialog(tab="Thermal flows"));
parameter Boolean QVin=false
    "True : controlled air change rate; False : constant air change rate"                       annotation(Dialog(tab="Thermal flows"));

  // Walls
parameter Modelica.SIunits.Temperature Tp=293.15 "Initial temperature of walls"
    annotation(Dialog(tab="Walls"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Walls"));

  // Windows
parameter Boolean useVolet=false "True if shutter, false if not" annotation(Dialog(tab="Windows"));
parameter Boolean useOuverture=false "True if controlled opening, false if not"
                                               annotation(Dialog(tab="Windows"));
parameter Boolean useReduction=false
    "True if solar reduction factors (masking, frame), false if not"
    annotation (Dialog(tab="Windows"));
parameter Integer TypeFenetrePF=1 "Choice of type of window or French window"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"),
    choices( choice= 1 "I do not know - no frame",
             choice= 2 "Wood window sashes",
             choice= 3 "Metal window sashes",
             choice= 4 "French window sashes with wood bedrock",
             choice= 5 "French window sashes without wood bedrock",
             choice= 6 "French window sashes without metal bedrock",
             choice= 7 "Wood sliding window",
             choice= 8 "Metal sliding window",
             choice= 9 "Sliding French window with wood bedrock",
             choice= 10 "Sliding French window without wood bedrock",
             choice= 11 "Sliding French window without metal bedrock"));
parameter Real voilage=0.95
    "Presence of net curtains : = 0.95 if yes and = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
parameter Real position=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
parameter Real rideaux=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
parameter Real ombrages=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
parameter Real r1=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for direct radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Reduction factor if useReduction = false"));
parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Reduction factor if useReduction = false"));

  // Thermal bridges
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsSejour,
      TauPonts=paraMaisonRT.TauPonts)
    annotation (Dialog(tab="Thermal bridges"));

 // Protected parameters
protected
  parameter Boolean EmplacementEst= if EmplacementAppartement==3 or EmplacementAppartement==6 or EmplacementAppartement==9 then true else false;
  parameter Boolean EmplacementOuest= if EmplacementAppartement==1 or EmplacementAppartement==4 or EmplacementAppartement==7 then true else false;
  parameter Boolean EmplacementHaut= if EmplacementAppartement<=3 then true else false;
  parameter Boolean EmplacementBas= if EmplacementAppartement>=7 then true else false;

// Weighting coefficients
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauLNC(b=
        paraMaisonRT.bLNC)
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));

// Horizontal walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Plafond(
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.PlafondMitoyen.n,
      m=paraMaisonRT.PlafondMitoyen.m,
      e=paraMaisonRT.PlafondMitoyen.e,
      mat=paraMaisonRT.PlafondMitoyen.mat,
      positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour) if not
    EmplacementHaut
    annotation (Placement(transformation(extent={{-7,87},{7,101}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlafondImmeuble(
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.PlafondImmeuble.n,
      m=paraMaisonRT.PlafondImmeuble.m,
      e=paraMaisonRT.PlafondImmeuble.e,
      mat=paraMaisonRT.PlafondImmeuble.mat,
      positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
    GLOext=GLOEXT,
    ParoiInterne=false,
    hs_ext=paraMaisonRT.hsExtHor,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour) if
    EmplacementHaut
    annotation (Placement(transformation(extent={{-7,70},{7,84}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherMitoyen.n,
      m=paraMaisonRT.PlancherMitoyen.m,
      e=paraMaisonRT.PlancherMitoyen.e,
      mat=paraMaisonRT.PlancherMitoyen.mat,
      positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour) if not
    EmplacementBas        annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBasImmeuble(
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherImmeuble.n,
      m=paraMaisonRT.PlancherImmeuble.m,
      e=paraMaisonRT.PlancherImmeuble.e,
      mat=paraMaisonRT.PlancherImmeuble.mat,
      positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour) if
    EmplacementBas    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={71,-92})));

// Exterior vertical walls

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNordSejour)
    annotation (Placement(transformation(extent={{-7,16},{7,30}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuestExt(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuestSejour) if
    EmplacementOuest
    annotation (Placement(transformation(extent={{-7,-20},{7,-6}})));

// Internal vertical walls

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSudLNC(
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurPalier.n,
      m=paraMaisonRT.MurPalier.m,
      e=paraMaisonRT.MurPalier.e,
      mat=paraMaisonRT.MurPalier.mat,
      positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurSudSejour)
    annotation (Placement(transformation(extent={{-7,-38},{7,-24}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurMitoyen.n,
      m=paraMaisonRT.MurMitoyen.m,
      e=paraMaisonRT.MurMitoyen.e,
      mat=paraMaisonRT.MurMitoyen.mat,
      positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuestSejour) if not
    EmplacementOuest
    annotation (Placement(transformation(extent={{-7,-2},{7,12}})));

// Glazings

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    useVolet=useVolet,
    useOuverture=useOuverture,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    DifDirOut=false,
    useReduction=useReduction,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNordSejour,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.H_VitrageNordSejour)
    annotation (Placement(transformation(extent={{-37,16},{-23,30}})));

// Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{60,100},{80,120}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    nf=1,
    np=7,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNordSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurSudSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegSejourCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuestSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour},
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNordSejour}) if not
    CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));

// Base components

public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.HauteurMatisse, Tair=
        293.15) annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{20,100},{40,120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_living
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-11,-64},{9,-44}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondSejour
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.HauteurMatisse)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{-54,-30},{-40,-16}})));

  Modelica.Blocks.Interfaces.RealInput VENTNord if
                                               useOuverture annotation (
      Placement(transformation(extent={{-114,-28},{-86,0}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,110})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverture
    "Opening of north windows"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-13,67})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "Closing of north shutters"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={19,67})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_common
    "Temperature of adjacent housings" annotation (Placement(transformation(
          extent={{-64,88},{-56,96}}), iconTransformation(extent={{92,106},{100,
            114}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtNorth[3]
    annotation (Placement(transformation(extent={{-112,68},{-88,92}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-66,109})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtRoof[3]
    annotation (Placement(transformation(extent={{-112,84},{-88,108}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-90,109})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtWest[3]
    annotation (Placement(transformation(extent={{-112,52},{-88,76}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-46,109})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonCuisine if
                                                             not CLOintPlancher
    annotation (Placement(transformation(extent={{80,70},{100,90}}),
        iconTransformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{80,50},{100,70}}),
        iconTransformation(extent={{60,-70},{80,-50}})));
equation
  if CLOintPlancher == false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageNord.FluxAbsInt) annotation (
      Line(
      points={{19,-80},{32,-80},{32,24.4},{-27.9,24.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
      points={{19,-84.5714},{36,-84.5714},{36,26.5},{2.1,26.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[3], MurSudLNC.FluxAbsInt) annotation (Line(
      points={{19,-84.2857},{36,-84.2857},{36,-27.5},{2.1,-27.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[4], FLUXcloisonCuisine) annotation (Line(
      points={{19,-84},{36,-84},{36,80},{90,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[5], FLUXcloisonEntree) annotation (Line(
      points={{19,-83.7143},{36,-83.7143},{36,60},{90,60}},
      color={0,0,127},
      smooth=Smooth.None));

    if EmplacementBas==true then
connect(PintdistriRad.FLUXParois[7], PlancherBasImmeuble.FluxAbsInt)
    annotation (Line(
      points={{19,-83.1429},{67.5,-83.1429},{67.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    else
connect(PintdistriRad.FLUXParois[7], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.1429},{47.5,-83.1429},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
      connect(PintdistriRad.FLUXParois[1], PlafondImmeuble.FluxAbsInt)
        annotation (
      Line(
      points={{19,-84.8571},{36,-84.8571},{36,80.5},{2.1,80.5}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(PintdistriRad.FLUXParois[1], Plafond.FluxAbsInt)
        annotation (Line(
      points={{19,-84.8571},{36,-84.8571},{36,97.5},{2.1,97.5}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if EmplacementOuest==true then
      connect(PintdistriRad.FLUXParois[6], MurOuestExt.FluxAbsInt)
        annotation (Line(
      points={{19,-83.4286},{36,-83.4286},{36,-9.5},{2.1,-9.5}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(PintdistriRad.FLUXParois[6], MurOuest.FluxAbsInt)
        annotation (Line(
      points={{19,-83.4286},{36,-83.4286},{36,8.5},{2.1,8.5}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  else
    if EmplacementBas==true then
        connect(multiSum.y, PlancherBasImmeuble.FluxAbsInt) annotation (Line(
            points={{-14,-73.02},{68,-73.02},{68,-89.9},{67.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
            points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
  end if;

  if GLOEXT==true then
    connect(T_sky, VitrageNord.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,16.7},{-36.3,16.7}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(T_sky, MurNord.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,16.7},{-6.3,16.7}},
        color={191,0,0},
        smooth=Smooth.None));
    if EmplacementOuest==true then
      connect(T_sky, MurOuestExt.T_sky) annotation (Line(
          points={{-90,10},{-64,10},{-64,-19.3},{-6.3,-19.3}},
          color={191,0,0},
          smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
      connect(T_sky, PlafondImmeuble.T_sky) annotation (Line(
          points={{-90,10},{-64,10},{-64,70.7},{-6.3,70.7}},
          color={191,0,0},
          smooth=Smooth.None));
    end if;
  end if;

  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVolet then
   connect(fermetureVolets[1], VitrageNord.fermeture_volet) annotation (
      Line(
      points={{-100,-80},{-76,-80},{-76,27.9},{-36.3,27.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;
  if useOuverture then
   connect(ouvertureFenetres[1], VitrageNord.ouverture_fenetre) annotation (Line(
        points={{-100,-48},{-74,-48},{-74,23},{-32.1,23}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

  connect(T_ext, MurNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-6.3,20.9}},
      color={191,0,0},
      smooth=Smooth.None));
if EmplacementOuest==true then
    connect(T_ext, MurOuestExt.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,-15.1},{-6.3,-15.1}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(MurOuestExt.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,-15.1},{40,-15.1},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else
    connect(T_int_common, MurOuest.T_ext) annotation (Line(
        points={{-60,92},{-20,92},{-20,2.9},{-6.3,2.9}},
        color={128,0,255},
        smooth=Smooth.None));
      connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,2.9},{40,2.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
end if;
if EmplacementHaut==true then
    connect(T_ext, PlafondImmeuble.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,74.9},{-6.3,74.9}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(PlafondImmeuble.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,74.9},{40,74.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,91.9},{40,91.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
    connect(T_int_common, Plafond.T_ext) annotation (Line(
        points={{-60,92},{-34,92},{-34,91.9},{-6.3,91.9}},
        color={128,0,255},
        smooth=Smooth.None));
end if;
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,20.9},{40,20.9},{40,40},{80,40},{80,22}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(MurSudLNC.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,-33.1},{40,-33.1},{40,40},{80,40},{80,22}},
        color={255,0,0},
        smooth=Smooth.None));
if EmplacementBas==true then
      connect(PlancherBasImmeuble.T_int, noeudAir.port_a) annotation (Line(
          points={{73.1,-85.7},{73.1,-68},{53,-68},{53,-60},{40,-60},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));

      connect(TauPlancher.Tponder, PlancherBasImmeuble.T_ext) annotation (Line(
          points={{-43,-90.2},{28,-90.2},{28,-104},{73.1,-104},{73.1,-98.3}},
          color={191,0,0},
          smooth=Smooth.None));
else  connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
          points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
    connect(T_int_common, PlancherBas.T_ext) annotation (Line(
        points={{-60,92},{-20,92},{-20,-100},{54,-100},{54,-98.3},{53.1,-98.3}},
        color={128,0,255},
        smooth=Smooth.None));

end if;
    connect(TauLNC.Tponder, MurSudLNC.T_ext) annotation (Line(
        points={{-43,-50.2},{-24.5,-50.2},{-24.5,-33.1},{-6.3,-33.1}},
        color={191,0,0},
        smooth=Smooth.None));

  connect(T_ext, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-36.3,20.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauLNC.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-47},{-57,-47}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,26.5},{-14,26.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(noeudAir.port_a, T_int_living) annotation (Line(
      points={{80,22},{80,-19},{90,-19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, PontsThermiques.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-72.5},{-57.25,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{71,-39.1},{71,-30},{40,-30},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TauPlancher.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-93},{-60,-93},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-53},{-60,-53},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,20.9},{40,20.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxIncExtRoof, PlafondImmeuble.FluxIncExt) annotation (Line(
      points={{-100,96},{-80,96},{-80,83.3},{-2.1,83.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtNorth, VitrageNord.FluxIncExt) annotation (Line(
      points={{-100,80},{-80,80},{-80,26.5},{-32.1,26.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtNorth, MurNord.FluxIncExt) annotation (Line(
      points={{-100,80},{-80,80},{-80,29.3},{-2.1,29.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtWest, MurOuestExt.FluxIncExt) annotation (Line(
      points={{-100,64},{-80,64},{-80,-6.7},{-2.1,-6.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VENTNord, VitrageNord.V) annotation (Line(
      points={{-100,-14},{-68,-14},{-68,23},{-36.3,23}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}}),
graphics={
        Bitmap(extent={{-90,60},{92,-92}}, fileName=
              "modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Matisse/Sejour.png"),
        Ellipse(extent={{-38,-10},{-10,-38}},
                                            lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-24,6},
          rotation=360),
        Ellipse(
          extent={{-26,-22},{-22,-26}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-62,-80},
          rotation=180),
        Line(
          points={{-40,-14},{-24,-6},{-10,-14}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-10,-12},{-8,-16},{-12,-14},{-10,-12}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-54,-24},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-24,-54},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={6,-24},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-39,-34},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Zone living Matisse</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paraMaisonRT</code> allows the user to chose a specific French building regulation for the building, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from the choosen record.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneLiving;
