*
* Modele de production d'electricite
*
* Version 6: nous ajoutons les émissions de CO2, tarifs de rachat dans fonction de coûts
* version mars 2013
*
* Power plant
*
Set    iunit  power plant
        /NPP Nuclear power plant,
         THC Coal Thermal power plant,
         THF Fuel oil Thermal Power plant,
         CTP Combustion turbine Power Plant,
         CCG Combined Cycle Gas turbine Power plant,
         COG Cogeneration Gas: Combined heat and power plant,
         COC Cogeneration Coal: combined heat and power plant,
         COF Cogeneration Fuel: combined heat and power plant,
         COB Cogeneration Biogaz: combined heat and power plant,
         COO1 Cogeneration Wood waste: combined heat and power plant,
         COO2 Cogeneration Others: combined heat and power plant,
         COT Cogeneration Torrefied Biomass: combined heat and power plant,
         WPO windpower
         PVP photovoltaic with subsidies,
         HYW Hydraulic water-flow station,
         HLA Hydraulic lake station,
         HWP Hydraulic pumping station
         IPO  Imports/;

Set TT1 time period /t1/;
* t1= 2010, t2=2015, t3=2020, t4=2025, t5=2030
*Set TT1(T) /t1/;

Set iufatal(iunit) /COG,COC,COF,COB,COO1,COO2,HYW/;
set iurenew(iunit)/WPO,PVP,HYW,HLA,HWP/;
*renew= fuel free
*Set iufatal1(iunit)/COG,COC,COF,COO1/;
Set iunit2(iunit);
iunit2(iunit) = iunit(iunit)-iufatal(iunit);
Set iunit3(iunit);
iunit3(iunit) = iunit(iunit)-iurenew(iunit) ;


*Regarder le coût du biogaz #à mettre à jour
Set ifuel / OU    Uranium 233,
            COAL  Hard coal,
            HFO   Heating Fuel Oil,
            HTO   Heating Fuel Domestic,
            GAS   Gas,
            WI    Wind,
            SU    Sun,
            WA    Water
            TOP1  Biomass 1
            TOP2  Biomass 2
            BIG   Biogas
            OTH1  Others
            OTH2  Others 2/;

Set ifuel1(ifuel)/
            OU    Uranium 233,
            COAL  Hard coal,
            HFO   Heating Fuel Oil,
            HTO   Heating Fuel Domestic,
            GAS   Gas,
            WI    Wind,
            SU    Sun,
            TOP1  Biomass  1
            TOP2  Biomass  2
            BIG   Biogas
            OTH1  Others
            OTH2  Others 2/;

Set ifuel2(ifuel)/
            SU   Sun,
            WA   Water/;

set ifuel3(ifuel1)/
COAL
HFO
HTO
GAS
/;

set ifuel4(ifuel1)/
TOP1
TOP2
/;

Set    season /s1 winter,
               s2 spring fall,
               s3 summer,
               s4 july august/;

*Set   ss1(season)/s2,s3,s4/;

Set    ph /p0  sous-période de pointe,
           p1  pointe,
           p2  semi-base,
           p3  base/;

set ph1(ph)/p0,p1,p2/;

Set alea /a1,a2,a3/;

set alea1(alea) / a1,a2,a3 /;

Parameter  probalea(alea) alea probabilities season /
* travailler sur la distribution aléatoire
a1  0.6
a2  0.2
a3  0.2
/;


Parameter   capini(iunit)/
* unité :  GW par an
* CHP electric power only
* COO has the same characteristics as COC
*
* To be redesigned for 2019 ou 2020
*
            NPP  63.26
            THC   7.07
            THF   5.70
            CTP   1.63
            CCG   6.740
            COG   4.661
            COC   0.443
            COF   0.186
            COB   0.020
            COO1  0.455
            COO2  0.924
            COT   0.
            WPO   3.400
            PVP   .048
            HYW   7.600
            HLA   13.60
            HWP   4.200
            IPO  999./;



* we transform the initial capacity in MW
LOOP(iunit,
capini(iunit)=1000*capini(iunit);
);


Table dispo(iunit,season)

        S1     S2     S3     S4

NPP     0.90   0.90   0.90   0.90
THC     0.9    0.9    0.8    0.8
THF     0.9    0.9    0.9    0.9
CTP     0.95   0.95   0.95   0.95
CCG     0.949  0.949  0.943  0.949
COG     0.95   0.95   0.95   0.3
COC     0.95   0.95   0.95   0.3
COF     0.95   0.95   0.95   0.3
COB     0.45   0.45   0.47   0.3
COO1    0.48   0.48   0.48   0.3
COO2    0.48   0.48   0.48   0.3
COT     0.85   0.85   0.85   0.3
WPO     0.24   0.24   0.2    0.2
PVP     0.13   0.13   0.13   0.13
HYW     1.     1.     1.     1.
HLA     1.     1.     1.     1.
HWP     1.     1.     1.     1.
IPO     1.     1.     1.     1.
;

*coefficient d'usage de la puissance des lacs; on utilise 8760*0.21 h la puissance totale des lacs.
*set eta /0.23*8760/;

*quantité d'eau tombée dans l'année: on l'obtient en supposant que la quantité turbinée est égale à la quantité d'eau tombée. Pour la calculer, nous prenons
* la production hydro-électrique française que nous divisons par 8760. Nous obtenons la quantité par heure que nous multiplierons par la durée turbinée.
*set RAIN /3184.93 /;

set interunitfuel(iunit,ifuel1)/
NPP.OU,THC.(COAL,TOP1,TOP2),CTP.(HTO,GAS),CCG.GAS,COG.(GAS),COC.(COAL,TOP1,TOP2),COF.(HFO,HTO),
COB.(BIG),COO1.(OTH1),COO2.(OTH2),COT.(TOP1,TOP2),WPO.WI, PVP.SU,IPO.COAL/;

Table alpha(iunit,ifuel1)

             OU         COAL          HFO          HTO          TOP1          GAS       TOP2          BIG         OTH1    OTH2
NPP        0.360        0.000        0.000        0.000        0.000        0.000      0.000        0.000        0.000    0.
THC        0.000        0.400        0.000        0.000        0.380        0.000      0.380        0.000        0.000    0.
THF        0.000        0.000        0.380        0.000        0.000        0.000      0.000        0.000        0.000    0.
CTP        0.000        0.000        0.000        0.330        0.000        0.330      0.000        0.000        0.000    0.
CCG        0.000        0.000        0.000        0.000        0.000        0.550      0.00         0.300        0.000    0.
COG        0.000        0.000        0.000        0.000        0.000        0.330      0.000        0.000        0.000    0.
COC        0.000        0.400        0.000        0.000        0.380        0.000      0.380        0.000        0.000    0.
COF        0.000        0.000        0.380        0.330        0.000        0.000      0.000        0.000        0.000    0.
COB        0.0          0.0          0.0          0.0          0.0          0.0        0.0          1.00         0.000    0.0
COO1       0.000        0.000        0.000        0.000        0.000        0.000      0.000        0.000        1.00     0.0
COO2       0.000        0.000        0.000        0.000        0.000        0.000      0.000        0.000        0.000    1.
COT        0.000        0.000        0.000        0.000        0.200        0.000      0.200        0.000        0.000    0.0
IPO        0.           0.4          0.           0.           0.           0.         0.           0.           0.       0.
;

alpha('WPO','WI')=1.0;
alpha('PVP','SU')=1.0;


Parameter co2cost(TT1) / t1 50/
*unit euro/t CO2
;


Parameter fuelcost1(ifuel1)/
*we want to convert $/t in $/MWh
*coal (dollars/t hors taxe 2007), HFO (dollars/t hors taxe fioul 1% en 2007), HTO (dollars/t hors taxe 2007), GA (dollars/MBtu hors taxe en 2007), TOP (euro/t)
*ou  (euro/MWh valeur en 2008 DGEMP)       BIG (euro/MWh: tarif moyen de production: SOLAGRO)
* source: BP statistical review 2009
* prix du biogaz à vérifier
OU      4.4
*COAL   81.60
*HFO   348.66
*HTO   626.08
COAL   56.9
HFO    383.7
HTO    610.0
GAS    8.1
TOP1   185.
TOP2   610.00
BIG    37.00
OTH1   1.0
OTH2   1.0
/;


* currency unit :
* 1 US dollar
* 1 EUR = 1,06 USD (0603/2023)
*
set convdollar(ifuel1) currency unit for fuel is in US dollar
/
COAL  yes
HFO   yes
HTO   yes
GAS   yes
/;


set conveuro(ifuel1) currency unit for fuel is in Euro
/
TOP1 yes
TOP2 yes
BIG  yes
OTH1 yes
OTH2 yes
/;

Parameter factconv(ifuel1)  ;
LOOP(ifuel1,
factconv(ifuel1)=1
);

*Parameter factconv2(ifuel)
* Unit of factconv : MWh
* Gaz Naturel en MBtu
*coal: autralia 0.689 toe/tonne
* HFO: 40 GJ/t
*HTO: 42 GJ/t
*TOP:  22.5 MJ/kg

Factconv('OU')= 1;
Factconv('COAL')= 8.01  ;
Factconv('HFO') = 11.11  ;
Factconv('HTO') = 11.66  ;
Factconv('GAS') = 0.293  ;
Factconv('TOP1')= 6.25   ;
Factconv('TOP2')= 6.25  ;
Factconv('BIG')= 1  ;
Factconv('OTH1')=1;
Factconv('OTH2')=1;

scalar exchrate / 1.1/;

Parameter fuelcost2(ifuel1);
LOOP(IFUEL1$convdollar(ifuel1),
fuelcost2(ifuel1)=fuelcost1(ifuel1)/exchrate;
);
LOOP(ifuel1,
fuelcost2(ifuel1)=fuelcost2(ifuel1)/factconv(ifuel1);
);

Parameter fuelcost3(ifuel1);
LOOP(ifuel1$conveuro(ifuel1),
fuelcost3(ifuel1)=fuelcost1(ifuel1)/factconv(ifuel1);
);

Parameter fuelcost4(ifuel1);
LOOP(ifuel1,
fuelcost4(ifuel1)= fuelcost3(ifuel1)+fuelcost2(ifuel1);
);


Parameter em(ifuel1)/
*emissions per fuel in tCO2/MWh produced with fuel i

OU      0.
COAL    0.361
HFO     0.281
HTO     0.270
GAS     0.206
TOP1    0.00
TOP2    0.00
*BIG     0.270
BIG     0.0
/;

Table dispf1(ifuel1,season)
* je cale ma disponibilité en biogaz, wood waste et oth2 en fonction de la dispo pour l'usage elec uniquement sachant que pour 1t de biomasse utilisée seule 0.2t sert à la prod de MWh

             s1                s2               s3            s4
OU         1E+30           1.00E+31        1.00E+31        1.00E+31
COAL       1.00E+31        1.00E+31        1.00E+31        1.00E+31
HFO        1.00E+31        1.00E+31        1.00E+31        1.00E+31
HTO        1.00E+31        1.00E+31        1.00E+31        1.00E+31
GAS        1.00E+31        1.00E+31        1.00E+31        1.00E+31
TOP1       0.              0.              0.              0.
TOP2       0.00            0.00            0.00            0.00
BIG        20465.75        13871.23        34564.38        14098.63
OTH1       471945.21       319873.97       797063.01       325117.81
OTH2       959424.66       650276.71       1620361.64      660936.998
;


Parameter dispf2(ifuel2,season)
LOOP(ifuel2,LOOP(season,
dispf2(ifuel2,season)=9999999999999999000000000.;
));

Table demelec(ph,season,alea)
*GW
*on subdivise la période de pointe en PO et P1 pour prendre en compte les demandes extrêmes de la période de pointe
*
* Il faut redefinir les valeurs pour 2019 - 2020
*
               A1            A2             A3
P0.S1        81.57         83.70           87.87
P1.S1        78.41         77.97           82.55
P2.S1        73.07         71.38           74.43
P2.S2        66.39         65.40           66.32
P3.S1        61.58         60.39           61.03
P3.S2        57.90         57.08           57.41
P2.S3        53.61         53.36           53.30
P3.S3        46.83         46.89           46.89
P3.S4        39.71         39.71           39.57
;

*we transform the demand in electricity in MW
LOOP(ph,
LOOP(season,
LOOP(alea,
demelec(ph,season,alea)=1000*demelec(ph,season,alea);
)));

Parameter inc(TT1)/ t1 0 /;



Table duree(ph,season)

         S1         S2      S3      S4
P0       62.        0.       0.      0.
P1      187.        0.       0.      0.
P2      872.      745.    1870.      0.
P3     1039.      719.    1778.   1488.
;

*Hydro-power modelization
*postes horaires cumulés: z4 correspond au cumul des 4 postes à la saison 1
set g/g4,g3,g2,g1/;
set q/q4,q3/;
set c/c4,c3/;

*production cumulée max pour le nombre de postes j par saison i : pcs_ij
set pcs1/ pcs14, pcs13, pcs12, pcs11/ ;
set pcs2/ pcs24, pcs23/;
set pcs3/ pcs34, pcs33/;

*tables of sub-period length per season
*season1
Table A1(g,PH)
     P0     P1   P2    P3
g4   62    187   872  1039
g3   62    187   872   0
g2   62    187   0     0
g1   62    0     0     0
;

*season2
Table A2(q,PH)
     P0     P1   P2      P3
q4   0      0    745   719
q3   0      0    745    0
;

*season3
Table A3(c,PH)
     P0     P1    P2     P3
c4   0      0    1870   1778
c3   0      0    1870    0
;


*production maximale pour la saison 1 cumulée décroissante en fonction du nombre de postes restant dans la saison¨en MWh
Parameters
 RHS1(pcs1) /pcs14 6174000,pcs13 4760960,pcs12 3386400, pcs11 843200/
 RHS2(pcs2) /pcs24 4181180,pcs23 3203340/
 RHS3(pcs3)/ pcs34 10418688 , pcs33 8000608/
* nombre d'heure max dans la saison 4 où les turbines peuvent tourner
 HS4 /312.48  /;

set PS(PH,season)/
    P0.S1, P1.S1, P2.(S1,S2,S3), P3.(S1,S2,S3,S4)/
;

set interTOPunit(ifuel4,iunit)/
    TOP1.(THC,COC,COT),TOP2.(THC,COC,COT)/
;

* Annual Fixed cost euro/MWh incluant le coût du capital
Parameter fcost(iunit) /
* we get the data from CTP for COG and THC for COC and COF

NPP   5.365
THC   2.283
THF   2.283
CTP   1.180
CCG   1.203
COG   1.180
COC   2.283
COF   2.283
COB   2.283
COO1  2.283
COO2  2.283
COT   2.283
WPO   4.852
PVP   4.756
HYW   6.34
HLA   0.
HWP   0.
IPO   0.0
/;

* variable cost euro/MWh
Parameter vcost(iunit)  /

NPP    3.5
THC    29.75
THF    29.75
CTP    30.0
CCG    3.42
COG    30.0
COC    29.75
COF    29.75
COB    29.75
COO1   29.75
COO2   29.75
COT    29.75
WPO    1.40
PVP    3.482
HYW    0.01
HLA    0.01
HWP    0.01
IPO    50.
/;


Parameter invcost(iunit)  /
*euro/MWh

NPP    31.9
THC    29.43
THF    29.43
CTP    15.10
CCG     8.02
COG     6.10
COC    19.43
COF    19.43
COB    19.43
COO1   19.43
COO2   19.43
COT    19.43
WPO    45.97
PVP    69.09
HYW    0.
HLA    0.
HWP    0.
IPO    0.
/;

Parameter sub(iunit)/

NPP    0.
THC    0.
THF    0.
CTP    0.
CCG    0.
COG    61.
COC    0.
COF    0.
COB    75.
COO1   45.
COO2   0.
COT    0.
WPO    100.
*WPO    82.
PVP    580
HYW    0.
HLA    0.
HWP    0.
IPO    0.
/;



Parameter DEMNET(PH,SEASON,ALEA,TT1);

LOOP(PH,
LOOP(SEASON,
LOOP(ALEA,
DEMNET(PH,SEASON,ALEA,TT1)=DEMELEC(PH,SEASON,ALEA)*power((1+ 0.02),inc(TT1))*1000-DISPO('HYW',SEASON)*CAPINI('HYW')
-dispo('COG',season)*capini('COG')-dispo('COC',season)*capini('COC')
-dispo('COF',season)*capini('COF')-dispo('COB',season)*capini('COB')-dispo('COO1',season)*capini('COO1')
-dispo('COO2',season)*capini('COO2')) ;
));



Variables
       Puiss(iunit,ph,season,alea1,TT1)         Power loaded on the grid
       PRODMAX(iunit,ph,season,alea1,TT1)      Max of energy needed to pump water
       Inv(iunit,TT1)                          Investment
       CAPAVAIBLE(iunit,season,TT1)            Available capacity
       Capro(iunit,TT1)                        Capacity of production
       Emiss(ifuel3,iunit,PH,season,alea1,TT1) Emissions per unit
       z                                       Cost
       fuel1(ifuel1,iunit,PH,season,alea1,TT1)  Fossil Feedstock to supply the unit
       fuel2(ifuel2,iunit,PH,season,alea1,TT1)  Free Renewable Feedstock to supply the unit
       demHWP(ph,season,alea1,TT1)             Demand of power in p3 to produce electricity in p1 by hydraulic pumping station

Positive Variables Puiss,inv,capavaible,capro,Emiss,fuel1,fuel2 ;

Equations

cost
fuelneed(iunit,PH,season,alea1,TT1)
*fuelneed2(PH,season,alea1,TT1)
emission(ifuel1,iunit,PH,season,alea1,TT1)
*dispfuel1(ifuel1,season,alea,TT1)
*dispfuel2(ifuel2,season,alea,TT1)
capa(iunit,TT1)
capacity(iunit,PH,season,TT1)
invest1(TT1)
invest2(TT1)
invest3(TT1)
invest4(TT1)
invest5(TT1)
invest6(TT1)
invest7(TT1)
supply(iunit,PH,season,alea1,TT1)
supplyC(PH,season,alea1,TT1)
supplyG(PH,season,alea1,TT1)
supplyF(PH,season,alea1,TT1)
supplyB(PH,season,alea1,TT1)
supplyO1(PH,season,alea1,TT1)
supplyH(PH,season,alea1,TT1)
supplyO2(PH,season,alea1,TT1)
supplyH14(alea1,TT1)
supplyH13(alea1,TT1)
supplyH12(alea1,TT1)
supplyH11(alea1,TT1)
supplyH24(alea1,TT1)
supplyH23(alea1,TT1)
supplyH34(alea1,TT1)
supplyH33(alea1,TT1)
supplyH44(alea1,TT1)
pump11(ph1,alea1,TT1)
pump12(ph1,alea1,TT1)
pump13(alea1,TT1)
pump21(alea1,TT1)
pump22(alea1,TT1)
pump23(alea1,TT1)
pump31(alea1,TT1)
pump32(alea1,TT1)
pump33(alea1,TT1)
pump14(alea1,TT1)
pump24(alea1,TT1)
pump34(alea1,TT1)
demand(PH,season,alea1,TT1)
*renewcons(alea1)
;
*
*Objective function
*
cost.. z=e=sum((TT1,alea1,season),probalea(alea1)*(sum((iunit,PH),vcost(iunit)*PUISS(iunit,PH,season,alea1,TT1)*duree(PH,season))
+ sum((ifuel1,iunit3,PH)$interunitfuel(iunit3,ifuel1),fuelcost4(ifuel1)*fuel1(ifuel1,iunit3,PH,season,alea1,TT1))
+ sum((ifuel3,iunit3,PH)$interunitfuel(iunit3,ifuel3), co2cost(TT1)*Emiss(ifuel3,iunit3,PH,season,alea1,TT1))))
+ sum((TT1,iunit),(8760*(fcost(iunit)*capro(iunit,TT1)+ invcost(iunit)*inv(iunit,TT1))))
-sum(iunit,(sum((PH,season,alea1,TT1)$PS(PH,season),probalea(alea1)*sub(iunit)*PUISS(iunit,PH,season,alea1,TT1)*duree(PH,season))));

fuelneed(iunit3,PH,season,alea1,TT1)$PS(PH,season)..sum(ifuel1$interunitfuel(iunit3,ifuel1),alpha(iunit3,ifuel1)*fuel1(ifuel1,iunit3,PH,season,alea1,TT1))
                                                =e=PUISS(iunit3,PH,season,alea1,TT1)*duree(PH,season);
* + alpha('COO2','TOP1')*fuel1('TOP1','COO2',PH,season,alea1,TT1)
*MWh de fuel

*fuelneed2(PH,season,alea1,TT1)$PS(PH,season).. alpha('COO2','TOP1')*fuel1('TOP1','COO2',PH,season,alea1,TT1) =e=PUISS('COO2',PH,season,alea1,TT1)*duree(PH,season);

emission(ifuel3,iunit,PH, season,alea1,TT1)$PS(PH,season).. fuel1(ifuel3,iunit,PH,season,alea1,TT1)*em(ifuel3)- Emiss(ifuel3,iunit,PH,season,alea1,TT1) =e= 0;
*dispfuel1(ifuel1,season,alea,TT1) .. sum((iunit,PH),fuel1(ifuel1,iunit,PH,season,alea,TT1))=l= dispf1(ifuel1,season);
*dispfuel2(ifuel2,season,alea,TT1) .. sum((iunit,PH),fuel2(ifuel2,iunit,PH,season,alea,TT1))=l= dispf2(ifuel2,season);

*
*Capacity of production
*
capa(iunit,TT1) .. capini(iunit)+ inv(iunit,TT1)-capro(iunit,TT1)=e= 0. ;
capacity(iunit,PH,season,TT1) .. CAPAVAIBLE(iunit,season,TT1)- capro(iunit,TT1)*dispo(iunit,season) =e= 0.;
invest1(TT1)..  inv('HYW',TT1)=e= 0.;
invest2(TT1)..  inv('HLA',TT1)=e= 0.;
invest3(TT1)..  inv('HWP',TT1)=e= 0.;
invest4(TT1)..  inv('WPO',TT1)=l= 20000;
invest5(TT1)..  inv('PVP',TT1)=l= 600;
invest6(TT1)..  inv('NPP',TT1)=l= 21000;
invest7(TT1)..  inv('COB',TT1)=l= 0;

*
*Production of electricity
*

supply(iunit2,PH,season,alea1,TT1) .. PUISS(iunit2,PH,season,alea1,TT1) =l= CAPAVAIBLE(iunit2,season,TT1);
supplyC(PH,season,alea1,TT1) ..  PUISS('COC',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COC',season,TT1) ;
supplyG(PH,season,alea1,TT1) ..  PUISS('COG',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COG',season,TT1) ;
supplyF(PH,season,alea1,TT1) ..  PUISS('COF',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COF',season,TT1) ;
supplyB(PH,season,alea1,TT1) ..  PUISS('COB',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COB',season,TT1) ;
supplyO1(PH,season,alea1,TT1) .. PUISS('COO1',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COO1',season,TT1) ;
supplyH(PH,season,alea1,TT1)..   PUISS('HYW',PH,season,alea1,TT1)=e=  CAPAVAIBLE('HYW',season,TT1) ;
*supplyP1(PH,season,alea1,TT1)..  PUISS('PVP',PH,season,alea1,TT1)=e=  CAPAVAIBLE('PVP1',season,TT1) ;
*supplyW1(PH,season,alea1,TT1)..  PUISS('WPO',PH,season,alea1,TT1)=e=  CAPAVAIBLE('WPO1',season,TT1) ;
supplyO2(PH,season,alea1,TT1) .. PUISS('COO2',PH,season,alea1,TT1)=e=  CAPAVAIBLE('COO2',season,TT1) ;

*
*Modelization of the hydro-storage capacity
*
supplyH14(alea1,TT1)..sum(PH, A1('g4',PH)*PUISS('HLA',PH,'s1',alea1,TT1))=l=RHS1('pcs14');
supplyH13(alea1,TT1)..sum(PH, A1('g3',PH)*PUISS('HLA',PH,'s1',alea1,TT1))=l=RHS1('pcs13');
supplyH12(alea1,TT1)..sum(PH, A1('g2',PH)*PUISS('HLA',PH,'s1',alea1,TT1))=l=RHS1('pcs12');
supplyH11(alea1,TT1)..sum(PH, A1('g1',PH)*PUISS('HLA',PH,'s1',alea1,TT1))=l=RHS1('pcs11');
supplyH24(alea1,TT1)..sum(PH, A2('q4',PH)*PUISS('HLA',PH,'s2',alea1,TT1))=l=RHS2('pcs24');
supplyH23(alea1,TT1)..sum(PH, A2('q3',PH)*PUISS('HLA',PH,'s2',alea1,TT1))=l=RHS2('pcs23');
supplyH34(alea1,TT1)..sum(PH, A3('c4',PH)*PUISS('HLA',PH,'s3',alea1,TT1))=l=RHS3('pcs34');
supplyH33(alea1,TT1)..sum(PH, A3('c3',PH)*PUISS('HLA',PH,'s3',alea1,TT1))=l=RHS3('pcs33');
supplyH44(alea1,TT1)..duree('p3','s4')*PUISS('HLA','p3','s4',alea1,TT1)=l=capini('HLA')*HS4;
*
*Modelization of the hydro-storage and pumping capacity
*
*season1
pump11(ph1,alea1,TT1)..duree(ph1,'s1')*PUISS('HWP',ph1,'s1',alea1,TT1)=l=PRODMAX('HWP',ph1,'s1',alea1,TT1);
pump12(ph1,alea1,TT1)..PRODMAX('HWP',ph1,'s1',alea1,TT1)=l=duree(ph1,'s1')*capini('HWP');
pump13(alea1,TT1)..sum(ph1,(1.33*PRODMAX('HWP',ph1,'s1',alea1,TT1)))/duree('p3','s1')=e=demHWP('p3','s1',alea1,TT1);
*season2
pump21(alea1,TT1)..duree('p2','s2')*PUISS('HWP','p2','s2',alea1,TT1)=l=PRODMAX('HWP','p2','s2',alea1,TT1);
pump22(alea1,TT1)..PRODMAX('HWP','p2','s2',alea1,TT1)=l=duree('p2','s2')*capini('HWP');
pump23(alea1,TT1)..(1.33*PRODMAX('HWP','p2','s2',alea1,TT1))/duree('p3','s2')=e=demHWP('p3','s2',alea1,TT1);
*season3
pump31(alea1,TT1)..duree('p2','s3')*PUISS('HWP','p2','s3',alea1,TT1)=l=PRODMAX('HWP','p2','s3',alea1,TT1);
pump32(alea1,TT1)..PRODMAX('HWP','p2','s3',alea1,TT1)=l=duree('p2','s3')*capini('HWP');
pump33(alea1,TT1)..(1.33*PRODMAX('HWP','p2','s3',alea1,TT1))/duree('p3','s3')=e=demHWP('p3','s3',alea1,TT1);
*period 3: power produced from hydro-storage and pumping capacity  is always produced during the high period.
pump14(alea1,TT1)..PUISS('HWP','p3','s1',alea1,TT1)=e=0;
pump24(alea1,TT1)..PUISS('HWP','p3','s2',alea1,TT1)=e=0;
pump34(alea1,TT1)..PUISS('HWP','p3','s3',alea1,TT1)=e=0;
*
*Function of production
*
demand(PH,season,ALEA1,TT1)$PS(PH,season) .. sum(iunit2,PUISS(iunit2,PH,season,alea1,TT1))
*                                            + CAPAVAIBLE('COO2',season,TT1)
*                                            + CAPAVAIBLE('PVP2',season,TT1)
*                                            + CAPAVAIBLE('WPO2',season,TT1)
                                            =g=DEMNET(PH,season,alea1,TT1)
                                            + demHWP('p3','s1',alea1,TT1)+ demHWP('p3','s2',alea1,TT1)+ demHWP('p3','s3',alea1,TT1) ;


*renewcons(alea1).. sum(season, (DISPO('HYW',SEASON)*CAPINI('HYW')+ dispo('WPO1',season)*capini('WPO1')+dispo('WPO2',season)*capini('WPO2')
*                   + dispo('PVP1',season)*capini('PVP1') + dispo('PVP2',season)*capini('PVP2'))*(sum(PH,duree(PH,season))))
*                   + sum((iunit,PH,season,TT1),alpha(iunit,'TOP1')*fuel1('TOP1',iunit,PH,season,alea1,TT1))
*                   + sum((iunit,PH,season,TT1),alpha(iunit,'TOP2')*fuel1('TOP2',iunit,PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COG','BIG')*fuel1('BIG','COG',PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COO1','BIG')*fuel1('BIG','COO1',PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COO1','OTH1')*fuel1('OTH1','COO1',PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COO1','OTH2')*fuel1('OTH2','COO1',PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COO2','TOP1')*fuel1('TOP1','COO2',PH,season,alea1,TT1))
*                   + sum((PH,season,TT1),alpha('COO2','TOP2')*fuel1('TOP2','COO2',PH,season,alea1,TT1))
*                   =g= 0.1* sum((PH,season),DEMELEC(PH,SEASON,ALEA1)*duree(PH,season))*1000;


Model Elec /all/;


Solve Elec using lp minimizing z ;

Parameter cm1(TT1);
Loop(TT1,
cm1(TT1)=demand.m('P0','S1','A1',TT1)/duree('P0','S1')/probalea('A1') ;
);
display cm1;
*
* utilisation du cout marginal comme prix de vente de electricite des batteries
*
* modele de maximisation de profit pour definir la production des batteries
*


*
*file ELEC8 /'puiss.txt'/;
*PUT  ELEC8;
*ELEC8.PC= 5;
*ELEC8.ND= 3;
*ELEC8.PW= 255;
*PUT " Called power by sub-period",PUT/
*PUT "alea1", PUT "PH", PUT "season" ,;
*Loop(iunit, PUT  iunit.TL );
*PUT /;
*LOOP(TT1,
*LOOP(alea1,
*LOOP(PH,
*LOOP(season$PS(PH,season),
*PUT ALEA1.TL, PUT PH.TL, PUT season.TL;
*LOOP(iunit,
*PUT Puiss.L(iunit,PH,season,alea1,TT1);
*);
*PUT /;
*))));
*PUT/;
