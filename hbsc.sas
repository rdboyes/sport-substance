proc import datafile= "D:\HBSC2014_Dylan.sav" out=hbsc
        dbms= sav REPLACE;
run;

proc contents data = hbsc;
run;

data hbsc2;
set hbsc;
sport = (Q72A-1) + (Q72B-1)*2;
team = 0;
if sport = 2 then team = .;
if Q72A = 1 then team = 1;
if RB216C = 1 then weed = 0;
else if RB216C > 1 then weed = 1;
chew = Q61B - 1;
run;

proc freq data = hbsc2;
tables Q59F*sport*m18;
run;

proc freq data = hbsc;
tables RB216C;
run;

proc freq data = hbsc;
tables Q72A*Q72C;
run;

proc freq data = hbsc;
tables StatsCanCode;
run;

proc sort data = hbsc2;
by m1;
run;

proc logistic data = hbsc2;
model weed = team;
by m1;
run;

proc freq data = hbsc2;
tables m1*team*weed/cmh;
run;
*/
ODS HTML CLOSE;
ODS HTML;

proc contents data = hbsc;
run;

data hbsc3;
set hbsc2;
*Family structure classification. 1 = Both parents, 2 = Reconstituted Fam (Step parent) 3 = Single parent 4 = foster/other;
if M63 = 1 then do;
    if M64 = 1 then do;
        if M65 = 2 AND M66 = 2 then family = 1;
        else family = 2;
    end;
    else do;
        if M65 = 2 AND M66 = 2 then family = 3;
        else family = 2;
    end;
end;
else do;
    if M64 = 1 then do;
        if M65 = 2 AND M66 = 2 then family = 3;
        else family = 2;
    end;
    else do;
        if M65 = 1 AND M66 = 1 then family = 2;
        else if M65 = 1 OR M66 = 1 then family = 3;
        else family = 4;
    end;
end;
*siblings = 1 if they have any siblings, 0 if not;
siblings = sum(m71,m72);
if siblings > 1 then siblings = 1;
*Exclude grades lower than 9, 10+ in the 10 categotry;
if m2 < 9 then delete;
if m2 > 10 then m2 = 10;
*Ethnicity classification loosely based on Census categories;
length eth $ 50;
if q8m_1 = 1 then do;
    if q8m_2 = . then eth = "Caucasian";
    else eth = "Caucasian Mixed";
end;
else if q8m_1 = 9 OR q8m_1 = 10 OR q8m_1 = 11 OR q8m_2 = 9 OR q8m_2 = 10 OR q8m_2 = 11 then eth = "Aboriginal";
else if q8m_2 NE . then eth = "Mixed";
else if q8m_1 = 3 then eth = "South Asian";
else if q8m_1 = 2 OR q8m_1 = 5 OR q8m_1 = 7 OR q8m_1 = 12 OR q8m_1 = 13 then eth = "East/Southeast Asian";
else if q8m_1 = 4 then eth = "Black";
else if q8m_1 = 8 OR q8m_1 = 14 then eth = "Arab/West Asian";
else if q8m_1 = 6 then eth = "Latin American";
else if q8m_1 = 15 then eth = "Mixed";
*Create the drinking variable;
if q68 > 5 then binge = 0;
if q68 <= 5 then binge = 1;
*Create cannabis variable;
if rb216c > 2  then cannabis = 1;
if rb216c <= 2 then cannabis = 0;
*Smoking;
if q60 = 1 then tobacco = 1;
if q60 = 2 then tobacco = 0;
*Chewing T;
if q61b = 1 then chewingtobacco = 1;
if q61b = 2 then chewingtobacco = 0;
*hard drugs;
if q70a > 1 then harddrug = 1;
else if q70b > 1 then harddrug = 1;
else if q70c > 1 then harddrug = 1;
else if q70d > 1 then harddrug = 1;
else if q70e > 1 then harddrug = 1;
else if q70f > 1 then harddrug = 1;
else if q70g > 1 then harddrug = 1;
if q70a = 1 OR q70a = . then do;
    if q70b = 1 OR q70b = . then do;
        if q70c = 1 OR q70c = . then do;
            if q70d = 1 OR q70d = . then do;
                if q70e = 1 OR q70e = . then do;
                    if q70f = 1 OR q70f = . then do;
                        if q70g = 1 OR q70g = . then do;
                            harddrug = 0;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
*Meds;
if q70h > 1 then meds = 1;
else if q70i > 1 then meds = 1;
else if q70j > 1 then meds = 1;
else if q70k > 1 then meds = 1;
if q70h = 1 OR q70h = . then do;
    if q70i = 1 OR q70i = . then do;
        if q70j = 1 OR q70j = . then do;
            if q70k = 1 OR q70k = . then do;
                meds = 0;
            end;
        end;
    end;
end;
if sport = 0 then sports = 3;
if sport = 1 then sports = 1;
if sport = 2 then sports = 2;
if sport = 3 then sports = 0;
run;
/*
proc freq data = hbsc3;
tables m1*sport /norow nopercent missing;
proc freq data = hbsc3;
tables m2*sport /norow nopercent missing;
proc freq data = hbsc3;
tables fam*sport /norow nopercent missing;
proc freq data = hbsc3;
tables siblings*sport /norow nopercent missing;
run;

proc freq data = hbsc3;
tables sport;
run;

proc freq data = hbsc3;
tables sport*eth/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables sport*m132/missing nocol nopercent;
run;

proc freq data = hbsc3;;
tables family*m63 family*m64 family*m65 family*M66;
run;

proc freq data = hbsc3;
tables sport*family/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables family*m63*m64/missing;
run;
/*
proc freq data = hbsc3;
tables m63*m64*m65*m66;
run;
*/
/*
proc freq data = hbsc3;
tables sport*family/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables sport*siblings/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables id1;
run;

proc freq data = hbsc3;
tables q68*m42;
run;

proc freq data = hbsc3;
tables q70a q70b q70c q70d q70e q70f q70g q70h q70i q70j q70k;
run;

proc freq data = hbsc3;
tables meds;
run;

ods html close;
ods html;

*Empty Models;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 binge;
model binge = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 cannabis;
model cannabis = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 tobacco;
model tobacco = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 chewingtobacco;
model chewingtobacco = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 harddrug;
model harddrug = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 meds;
model meds = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

*Models;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2;
model binge = sports eth m1 m2 family siblings m132/dist = binomial link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model binge = sports eth m1 m2 family siblings m132 StatsCanCode/dist = binomial link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 cannabis sports(ref = first) id2;
model cannabis = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = exch;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model cannabis = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 tobacco sports(ref = first) id2;
model tobacco = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = exch;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model tobacco = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;


proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model chewingtobacco = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model harddrug = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model cannabis = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

*Interactions by Sex;
proc sort data=hbsc3;
by m1;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
by m1;
model binge = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 cannabis sports(ref = first) id2 StatsCanCode;
by m1;
model cannabis = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 tobacco sports(ref = first) id2 StatsCanCode;
by m1;
model tobacco = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 chewingtobacco sports(ref = first) id2 StatsCanCode;
by m1;
model chewingtobacco = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 harddrug sports(ref = first) id2 StatsCanCode;
by m1;
model harddrug = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 meds sports(ref = first) id2 StatsCanCode;
by m1;
model meds = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;


*Analyses of competitive involvement in sport;
data hbsc4;
set hbsc3;
group = Q72C + Q72D + Q72E + Q72F + Q72G;
if group = 10 then otheract = 1;
else if group < 10 then otheract = 0;
run;

proc freq data = hbsc4;
tables sports*otheract;
run;

proc sort data=hbsc4;
by otheract;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
by otheract;
model binge = sports otheract eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;
proc import datafile= "D:\HBSC2014_Dylan.sav" out=hbsc
		dbms= sav REPLACE; 
run;

proc contents data = hbsc;
run;

data hbsc2;
set hbsc;
sport = (Q72A-1) + (Q72B-1)*2;
team = 0;
if sport = 2 then team = .;
if Q72A = 1 then team = 1;
if RB216C = 1 then weed = 0;
else if RB216C > 1 then weed = 1;
chew = Q61B - 1;
run;

proc freq data = hbsc2;
tables Q59F*sport*m18;
run;

proc freq data = hbsc;
tables RB216C;
run;

proc freq data = hbsc;
tables Q72A*Q72C;
run;

proc freq data = hbsc;
tables StatsCanCode;
run;

proc sort data = hbsc2;
by m1;
run;

proc logistic data = hbsc2;
model weed = team;
by m1;
run;

proc freq data = hbsc2;
tables m1*team*weed/cmh;
run;
*/
ODS HTML CLOSE;
ODS HTML;

proc contents data = hbsc;
run;

data hbsc3;
set hbsc2;
*Family structure classification. 1 = Both parents, 2 = Reconstituted Fam (Step parent) 3 = Single parent;
if M63 = 1 then do;
	if M64 = 1 then do;
		if M65 = 2 AND M66 = 2 then family = 1;
		else family = 2;
	end;
	else do;
		if M65 = 2 AND M66 = 2 then family = 3;
		else family = 2;
	end;
end;
else do;
	if M64 = 1 then do;
		if M65 = 2 AND M66 = 2 then family = 3;
		else family = 2;
	end;
	else do;
		if M65 = 1 AND M66 = 1 then family = 2;
		else if M65 = 1 OR M66 = 1 then family = 3;
		else family = 4;
	end;
end; 
*siblings = 1 if they have any siblings, 0 if not;
siblings = sum(m71,m72);
if siblings > 1 then siblings = 1;
*Exclude grades lower than 9, 10+ in the 10 categotry;
if m2 < 9 then delete;
if m2 > 10 then m2 = 10;
*Ethnicity classification loosely based on Census categories;
length eth $ 50;
if q8m_1 = 1 then do;
	if q8m_2 = . then eth = "Caucasian";
	else eth = "Caucasian Mixed";
end;
else if q8m_1 = 9 OR q8m_1 = 10 OR q8m_1 = 11 OR q8m_2 = 9 OR q8m_2 = 10 OR q8m_2 = 11 then eth = "Aboriginal";
else if q8m_2 NE . then eth = "Mixed";
else if q8m_1 = 3 then eth = "South Asian";
else if q8m_1 = 2 OR q8m_1 = 5 OR q8m_1 = 7 OR q8m_1 = 12 OR q8m_1 = 13 then eth = "East/Southeast Asian";
else if q8m_1 = 4 then eth = "Black";
else if q8m_1 = 8 OR q8m_1 = 14 then eth = "Arab/West Asian";
else if q8m_1 = 6 then eth = "Latin American";
else if q8m_1 = 15 then eth = "Mixed";
*Create the drinking variable;
if q68 > 5 then binge = 0;
if q68 <= 5 then binge = 1;
if q68 = . then cannabis = .;
*Create cannabis variable;
if rb216c > 2  then cannabis = 1;
if rb216c <= 2 then cannabis = 0;
if rb216c = . then cannabis = .;
*Smoking;
if q60 = 1 then tobacco = 1;
if q60 = 2 then tobacco = 0;
*Chewing T;
if q61b = 1 then chewingtobacco = 1;
if q61b = 2 then chewingtobacco = 0;
*hard drugs;
if q70a > 1 then harddrug = 1;
else if q70b > 1 then harddrug = 1;
else if q70c > 1 then harddrug = 1;
else if q70d > 1 then harddrug = 1;
else if q70e > 1 then harddrug = 1;
else if q70f > 1 then harddrug = 1;
else if q70g > 1 then harddrug = 1;
if q70a = 1 OR q70a = . then do; 
	if q70b = 1 OR q70b = . then do; 
		if q70c = 1 OR q70c = . then do; 
			if q70d = 1 OR q70d = . then do; 
				if q70e = 1 OR q70e = . then do; 
					if q70f = 1 OR q70f = . then do; 
						if q70g = 1 OR q70g = . then do; 
							harddrug = 0;
						end;
					end;
				end;
			end;
		end;
	end;
end;
*Meds;
if q70h > 1 then meds = 1;
else if q70i > 1 then meds = 1;
else if q70j > 1 then meds = 1;
else if q70k > 1 then meds = 1;
if q70h = 1 OR q70h = . then do; 
	if q70i = 1 OR q70i = . then do; 
		if q70j = 1 OR q70j = . then do; 
			if q70k = 1 OR q70k = . then do; 
				meds = 0;
			end;
		end;
	end;
end;
if sport = 0 then sports = 3;
if sport = 1 then sports = 1;
if sport = 2 then sports = 2;
if sport = 3 then sports = 0;
run;

proc freq data = hbsc3;
tables m1*sport /norow nopercent missing;
proc freq data = hbsc3;
tables m2*sport /norow nopercent missing;
proc freq data = hbsc3;
tables fam*sport /norow nopercent missing;
proc freq data = hbsc3;
tables siblings*sport /norow nopercent missing;
run;

proc freq data = hbsc3;
tables sport;
run;

proc freq data = hbsc3;
tables sport*eth/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables sport*m132/missing nocol nopercent;
run;

proc freq data = hbsc3;;
tables family*m63 family*m64 family*m65 family*M66;
run;

proc freq data = hbsc3;
tables sport*family/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables family*m63*m64/missing;
run;
/*
proc freq data = hbsc3;
tables m63*m64*m65*m66;
run;
*/
proc freq data = hbsc3;
tables sport*family/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables sport*siblings/missing nocol nopercent;
run;

proc freq data = hbsc3;
tables id1;
run;

proc freq data = hbsc3;
tables q68*m42;
run;

proc freq data = hbsc3;
tables q70a q70b q70c q70d q70e q70f q70g q70h q70i q70j q70k;
run;

proc freq data = hbsc3;
tables meds;
run;

ods html close;
ods html;

*Empty Models;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 binge;
model binge = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 cannabis;
model cannabis = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 tobacco;
model tobacco = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 chewingtobacco;
model chewingtobacco = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 harddrug;
model harddrug = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

proc mixed data = hbsc3 covtest noclprint method=ML;
class id2 meds;
model meds = /solution ddfm=Satterthwaite;
random intercept /subject = id2 type = vc;
run;

*Models;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model binge = sports eth m1 m2 family siblings m132 StatsCanCode/dist = binomial link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model cannabis = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model tobacco = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model chewingtobacco = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model harddrug = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model cannabis = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = exch;
estimate 'Beta' sports 1 -1/exp;
run;

*Interactions by Sex;
proc sort data=hbsc3;
by m1;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
by m1;
model binge = sports eth m1 m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model binge = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 cannabis sports(ref = first) id2 StatsCanCode;
by m1;
model cannabis = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model cannabis = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 tobacco sports(ref = first) id2 StatsCanCode;
by m1;
model tobacco = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model tobbaco = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 chewingtobacco sports(ref = first) id2 StatsCanCode;
by m1;
model chewingtobacco = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model chewingtobacco = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 harddrug sports(ref = first) id2 StatsCanCode;
by m1;
model harddrug = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model harddrug = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 meds sports(ref = first) id2 StatsCanCode;
by m1;
model meds = sports eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc3 descending;
class eth m2 family siblings m132 binge sports(ref = first) id2;
by m1;
model meds = sports eth m1 m2 family siblings m132/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

*Analyses of competitive involvement in sport;
data hbsc4;
set hbsc3;
group = Q72C + Q72D + Q72E + Q72F + Q72G;
if group = 10 then nootheract = 1;
else if group < 10 then nootheract = 0;
run;

proc freq data = hbsc4;
tables sports*nootheract;
run;

proc sort data=hbsc4;
by m1 sports;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
by m1 sports;
model binge = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 tobacco sports(ref = first) id2 StatsCanCode;
by m1 sports;
model tobacco = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 chewingtobacco sports(ref = first) id2 StatsCanCode;
by m1 sports;
model chewingtobacco = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 cannabis sports(ref = first) id2 StatsCanCode;
by m1 sports;
model cannabis = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 harddrug sports(ref = first) id2 StatsCanCode;
by m1 sports;
model harddrug = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

proc genmod data = hbsc4 descending;
class eth m1 m2 family siblings m132 meds sports(ref = first) id2 StatsCanCode;
by m1 sports;
model meds = nootheract eth m2 family siblings m132 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
run;

*For multilevel analysis class;
proc glimmix data=hbsc3;
class binge id2;
model binge =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data = hbsc3;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2;
model binge = sports eth m1 m2 family siblings m132/dist = binary link = log ddfm=bw solution;
random intercept/ subject= id2 solution;
run;

proc glimmix data = hbsc3 method=laplace noclprint;
class eth m1 m2 family siblings m132 binge sports id2;
model binge = sports eth m1 m2 family siblings m132/cl dist = binary link = log ddfm=bw solution;
random intercept/ subject= id2 solution cl type=vc;
covtest/wald;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2;
model binge = sports eth m1 m2 family siblings m132/dist = binomial link = log;
repeated subject = id2/type = exch;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2;
model binge = sports eth m1 m2 family siblings m132/dist = binomial link = log;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model binge = sports eth m1 m2 family siblings m132 StatsCanCode/dist = binomial link = log;
repeated subject = id2/type = exch;
run;

proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 StatsCanCode;
model binge = sports*StatsCanCode eth m1 m2 family siblings m132 StatsCanCode/dist = binomial link = log;
repeated subject = id2/type = exch;
run;


proc genmod data = hbsc3 descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 rural(ref=first);
model binge = sports sports*rural rural eth m1 m2 family siblings m132/dist = binomial link = log;
repeated subject = id2/type = exch;
run;

proc format; 
value StatsCanCode 1='Metropolitan Centre (500,000 or more)' 2='Large Center (100,000 or 499,999)' 3='Medium Centre (30,000 to 99,999)' 4='Small Centre (1000 to 29,999)' 5='Rural (<1000)';
run; 

data mle;
set hbsc3;
if StatsCanCode > 2 then rural = 0;
if StatsCanCode =< 2 then rural =1;
run; 

proc freq data = mle;
tables rural;
run;

proc genmod data = mle descending;
class eth m1 m2 family siblings m132 binge sports(ref = first) id2 rural(ref=first);
model binge = sports sports eth m1 m2 family siblings m132 rural/dist = binomial link = log;
repeated subject = id2/type = exch;
run;

proc freq data = hbsc3;
tables id2;
run;

proc freq data = hbsc3;
tables q68/missing;
tables cannabis/missing;
tables tobacco/missing;
tables chewingtobacco/missing;
tables meds/missing;
tables harddrug/missing;
tables rb216c/missing;
run;

data hbscmissing;
set hbsc3;
missing = 0;
missingsports = 0;
missingeth = 0;
missinggrade = 0;
missingfamily = 0;
missingsiblings = 0;
missingm132 = 0;
missingid1 = 0;
missingStatsCanCode = 0;
missingsupportcat = 0;
missing_TEMG002 = 0;
if sports = . then do;
	missing = missing + 1;
	missingsports = 1;
END;
if eth = "" then do;
	missing = missing + 1;
	missingeth = 1;
end;
if grade = . then do;
	missing = missing + 1;
	missinggrade = 1;
end;
if family = . then do;
	missing = missing + 1;
	missingfamily = 1;
end;
if siblings = . then do;
	missing = missing + 1;
	missingsiblings = 1;
end;
if m132 = . then do;
	missing = missing + 1;
	missingm132 = 1;
end;
if id1 = . then do;
	missing = missing + 1;
	missingid1 = 1;
end;
if StatsCanCode = . then do;
	missing = missing + 1;
	missingStatsCanCode = 1;
end;
if supportcat = . then do;
	missing = missing + 1;
	missingsupportcat = 1;
end;
if _TEMG002 = . then do;
	missing = missing + 1;
	missing_TEMG002 = 1;
end;
run;

proc freq data = hbscmissing;
tables m1*missing*missingsports;
tables m1*missing*missingeth;
tables m1*missing*missinggrade;
tables m1*missing*missingfamily;
tables m1*missing*missingsiblings;
tables m1*missing*missingm132;
tables m1*missing*missingid1;
tables m1*missing*missingStatsCanCode;
tables m1*missing*missingsupportcat;
tables m1*missing*missing_TEMG002;
run;

proc freq data = hbscmissing;
TABLES m1*missing;
run;

data hbsccompmissing;
set hbsccomp;
missingbskt = 0;
missingeth = 0;
missingm2 = 0;
missingfamily = 0;
missingsiblings = 0;
missingm132 = 0;
missingStatsCanCode = 0;
missingsupportcat = 0;
missing_TEMG002= 0;
if bskt  = . then do;
	missing = missing + 1;
	missingbskt = 1;
end;
if eth = "" then do;
	missing = missing + 1;
	missingeth = 1;
end;
if family = . then do;
	missing = missing + 1;
	missingfamily = 1;
end;
if siblings = . then do;
	missing = missing + 1;
	missingsiblings = 1;
end;
if m132 = . then do;
	missing = missing + 1;
	missingm132 = 1;
end;
if StatsCanCode = . then do;
	missing = missing + 1;
	missingStatsCanCode = 1;
end;
if supportcat = . then do;
	missing = missing + 1;
	missingsupportcat = 1;
end;
run;

proc freq data = hbsccompmissing;
tables m1*missing*missingsports;
tables m1*missing*missingeth;
tables m1*missing*missinggrade;
tables m1*missing*missingfamily;
tables m1*missing*missingsiblings;
tables m1*missing*missingm132;
tables m1*missing*missingid1;
tables m1*missing*missingStatsCanCode;
tables m1*missing*missingsupportcat;
tables m1*missing*missing_TEMG002;
run;

proc freq data = hbsccompmissing;
tables m1*missing;
run;
