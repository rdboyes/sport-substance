proc import datafile= "D:\HBSC2014_Dylan2.sav" out=hbsc
        dbms= sav REPLACE;
run;

proc contents data = hbsc2;
run;

data hbsc2;
set hbsc;
team = .;
ind = .;
if q72a = 1 then team = 1;
if q72a = 2 then team = 0;
if q72b = 1 then ind = 1;
if q72b = 2 then ind = 0;
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
if m2 = . then grade = .;
else if m2 < 9 then delete;
if m2 = 9 then grade = 9;
else if m2 >= 10 then grade = 10;
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
else if q61c = 1 then chewingtobacco = 1;
else if q61b = 2 AND q61c = 2 then chewingtobacco = 0; 
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
sport = (Q72A-1) + (Q72B-1)*2;
if sport = 0 then sports = 3;
if sport = 1 then sports = 1;
if sport = 2 then sports = 2;
if sport = 3 then sports = 0;
if m1 = 1 then sex = 1;
if m1 = 2 then sex = 0;
if siblings = . then siblings = 0;
*if family = . then family = 1;
famsupport = mm82 + mm83 + mm84 + mm85;
if mm82 <= 2 && mm83 <= 2 && mm84 <= 2 && mm85 <= 2 then supportcat = 1;
else if mm82 >= 3 && mm83 >= 3 && mm84 >= 3 && mm85 >= 3 then supportcat = 2;
else if mm82 <= 3 && mm83 <= 3 && mm84 <= 3 && mm85 <= 3 then do;
	if mm82 >= 2 && mm83 >= 2 && mm84 >= 2 && mm85 >= 2 then supportcat = 3;
end;
else supportcat = 4;
*Missing Counts;
if m1 = . then do;
	missingm1 = 1;
	if eth = "" then missingm1 = 2;
	if siblings = . then missingm1 = 2;
	if family = . then missingm1 = 2;
	if supportcat = . then missingm1 = 2;
	if m132 = . then missingm1 = 2;
end;
if eth = "" then do;
	missingeth = 1;
	if m1 = . then missingeth = 2;
	if siblings = . then missingeth = 2;
	if family = . then missingeth = 2;
	if supportcat = . then missingeth = 2;
	if m132 = . then missingeth = 2;
end;
if siblings = . then do;
	missingsib = 1;
	if eth = "" then missingsib = 2;
	if m1 = . then missingsib = 2;
	if family = . then missingsib = 2;
	if supportcat = . then missingsib = 2;
	if m132 = . then missingsib = 2;
end;
if family = . then do;
	missingfam = 1;
	if eth = "" then missingfam = 2;
	if siblings = . then missingfam = 2;
	if m1 = . then missingfam = 2;
	if supportcat = . then missingfam = 2;
	if m132 = . then missingfam = 2;
end;
if supportcat = . then do;
	missingsup = 1;
	if eth = "" then missingfam = 2;
	if siblings = . then missingfam = 2;
	if family = . then missingfam = 2;
	if m1 = . then missingfam = 2;
	if m132 = . then missingfam = 2;
end;
if m132 = . then do;
	missingm132 = 1;
	if eth = "" then missingm132 = 2;
	if siblings = . then missingm132 = 2;
	if family = . then missingm132 = 2;
	if supportcat = . then missingm132 = 2;
	if m1 = . then missingm132 = 2;
end;
run;

proc sql;
  create table meanSES as
   select id2, count(m132),mean(m132)
    from hbsc2
    group by id2;
quit;

proc sort data = hbsc2;
by id2;
run;

data hbsc2;
merge hbsc2 meanSES;
by id2;
run;

data hbsc3;
set hbsc2;
if _TEMG001 < 5 then delete;
run;

proc freq data = hbsc2;
tables eth/missing;
run;

proc print data = meanSES;
run;


proc freq data = hbsc2;
tables sports m1 sports*m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
run;

data hbsccomp;
set hbsc2;
if Q72A NE 1 then delete;
if Q59F = 3 then friends = 1;
if Q59F = 2 then friends = 0;
if Q59F = 1 then friends = 0;
if Q59F = 4 then friends = 0;
otheract = .;
if Q72C = 1 OR Q72D = 1 OR Q72D = 1 OR Q72E = 1 OR Q72F = 1 OR Q72G = 1 then otheract = 1;
if Q72C = 2 then do;
	if Q72D = 2 then do;
		if Q72E = 2 then do;
			if Q72F = 2 then do;
				if Q72G = 2 then do;
					otheract = 0;
				end;
			end;
		end;
	end;
end;
if Q18 < 7 AND Q18 >= 1 then PA = 0;
else if Q18 >= 7 AND Q18 <= 8 then PA = 1;
if otheract = 0 AND friends = 1 AND PA = 1 then supercomp = 1;
else supercomp = 0; 
if friends = 1 and otheract = 0 then social = 1;
else social = 0;
*Create Dylan's BS KT variable;
if social = 0 and PA = 0 then bskt = 0; 
if social = 1 and PA = 0 then bskt = 1; 
if social = 0 and PA = 1 then bskt = 2; 
if social = 1 and PA = 1 then bskt = 3; 
run;

data hbsccomp_m;
set hbsccomp;
if m1 = 1 then output;
run;

data hbsccomp_f;
set hbsccomp;
if m1 = 2 then output;
run;
/*
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
run;
*/
*Binge;
proc genmod data = hbsccomp_m descending;
title "Binge M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model binge =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=cs;
run;

proc genmod data = hbsccomp_f descending;
title "Binge F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model binge =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=cs;
run;

*Cannabis;
proc glimmix data = hbsccomp_m method = quadrature(qpoints=7) empirical=classical;
title "Cannabis M";
class id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat bskt(ref = first);
model cannabis =  bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsccomp_f method = quadrature(qpoints=7) empirical=classical;
title "Cannabis F";
class bskt(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model cannabis = bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*Tobacco;
proc glimmix data = hbsccomp_m method = quadrature(qpoints=7) empirical=classical;
title "Tobacco M";
class id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat bskt(ref = first);
model tobacco =  bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsccomp_f method = quadrature(qpoints=7) empirical=classical;
title "Tobacco F";
class bskt(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model tobacco = bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*Chewing Tobacco;
proc glimmix data = hbsccomp_m method = quadrature(qpoints=7) empirical=classical;
title "CT M";
class id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat bskt(ref = first);
model chewingtobacco =  bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsccomp_f method = quadrature(qpoints=7) empirical=classical;
title "CT F";
class bskt(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model chewingtobacco = bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*Drugs;
proc glimmix data = hbsccomp_m method = quadrature(qpoints=7) empirical=classical;
title "Drugs M";
class id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat bskt(ref = first);
model harddrug =  bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsccomp_f method = quadrature(qpoints=7) empirical=classical;
title "Drugs F";
class bskt(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model harddrug = bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*Meds;
proc glimmix data = hbsccomp_m method = quadrature(qpoints=7) empirical=classical;
title "Meds M";
class id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat bskt(ref = first);
model meds =  bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsccomp_f method = quadrature(qpoints=7) empirical=classical;
title "Meds F";
class bskt(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model meds = bskt eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

/*
proc mi data = hbsc2 seed = 8730 nimpute = 10 out=hbscimp;
class eth m2 family siblings m132 binge id2 StatsCanCode sports(ref=first);
*/
/*
proc sort data = hbsc2;
by m1;
run;

proc genmod data = hbsc2 descending;
class id1 eth m1 m2 mm84 family siblings m132 binge id2 StatsCanCode sports(ref=first);
model binge = sports m1 sports*m1 eth m2 family siblings m132 id1 mm84 StatsCanCode/dist = poisson link = log;
repeated subject = id2/type = unstr;
weight wtcan;
run;
*/


proc mi data = hbsc2_m out=miout nimpute = 10;
class  m132 m126 m127 m128 m131;
var m132 m126 m127 m128 m131;
fcs discrim(m132=m126 m127 m128 m131/classeffects = include);
fcs discrim(m126=m127 m128 m131 m132/classeffects = include);
fcs discrim(m127=m126  m128 m131 m132/classeffects = include);
fcs discrim(m128=m126 m127  m131 m132/classeffects = include);
fcs discrim(m131=m126 m127 m128  m132/classeffects = include);
run;

proc glimmix data = miout method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
model binge = sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
by _imputation_;
ods output ParameterEstimates = gm_fcs;
run;

data gm_fcs2;
set gm_fcs;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fcs2;
class sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
modeleffects intercept sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
run;

proc mi data = hbsc2_m out=miout nimpute = 10;
class  mm82 mm83 mm84 mm85;
var mm82 mm83 mm84 mm85;
*Family Support;
fcs discrim(mm82=mm83 mm84 mm85/classeffects = include);
fcs discrim(mm83=mm82 mm84 mm85/classeffects = include);
fcs discrim(mm84=mm82 mm83 mm85/classeffects = include);
fcs discrim(mm85=mm83 mm84 mm82/classeffects = include);
run;
data miout;
set miout;
if mm82 <= 2 && mm83 <= 2 && mm84 <= 2 && mm85 <= 2 then supportcat = 1;
else if mm82 >= 3 && mm83 >= 3 && mm84 >= 3 && mm85 >= 3 then supportcat = 2;
else if mm82 <= 3 && mm83 <= 3 && mm84 <= 3 && mm85 <= 3 then do;
	if mm82 >= 2 && mm83 >= 2 && mm84 >= 2 && mm85 >= 2 then supportcat = 3;
end;
else supportcat = 4;
run;
proc glimmix data = miout method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
model binge = sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
by _imputation_;
ods output ParameterEstimates = gm_fcs;
run;

data gm_fcs2;
set gm_fcs;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fcs2;
class sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
modeleffects intercept sports m1 eth m2 family siblings m132 id1 mm84 StatsCanCode;
run;
/*
proc sort data = hbsc2;
by supportcat;
run;

proc univariate data = hbsc2;
var famsupport;
by supportcat;
histogram;
run;

proc freq data = hbsc2;
tables missingm1 missingm132 missingsib missingfam missingsup missingeth;
run;

proc univariate data = hbsc2;
var mm82-mm85;
histogram;
run;
/*
proc univariate data = hbsc2;
class id2;
var m132;
histogram;
run;
*/

