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
if q68 = . then binge = .;
*Create cannabis variable;
if rb216c > 2  then cannabis = 1;
if rb216c <= 2 then cannabis = 0;
if rb216c = . then cannabis = .;
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
							if (q70a = . AND q70b = . AND q70c = . AND q70d = . AND q70e = . AND q70f = . AND q70g = .) then harddrug = .;
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
				if (q70h = . AND q70i = . AND q70j = . AND q70k = .) then meds = .;
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
*if family = . then family = 1;
famsupport = mm82 + mm83 + mm84 + mm85;
if mm82 <= 2 && mm83 <= 2 && mm84 <= 2 && mm85 <= 2 then supportcat = 1;
else if mm82 >= 3 && mm83 >= 3 && mm84 >= 3 && mm85 >= 3 then supportcat = 2;
else if mm82 <= 3 && mm83 <= 3 && mm84 <= 3 && mm85 <= 3 then do;
	if mm82 >= 2 && mm83 >= 2 && mm84 >= 2 && mm85 >= 2 then supportcat = 3;
end;
else supportcat = 4;
run;

proc freq data = hbsc2;
tables meds/missing;
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

data hbsc2_m;
set hbsc3;
if m1 = 2 then delete;
if m1 = . then delete;
run;

data hbsc2_f;
set hbsc3;
if m1 = 1 then delete;
if m1 = . then delete;
run;

*Creating new competitive sport variable for girls with lower sport participation;
data hbsccomp_f1;
set hbsccomp_f;
if Q18 < 6 AND Q18 >= 1 then PA = 0;
else if Q18 >= 6 AND Q18 <= 8 then PA = 1;
if social = 0 and PA = 0 then bskt = 0; 
if social = 1 and PA = 0 then bskt = 1; 
if social = 0 and PA = 1 then bskt = 2; 
if social = 1 and PA = 1 then bskt = 3; 
run;

data hbsc2_m2;
set hbsc2_m;
if eth = "South Asian" then eth = "East/South Asian";
if eth = "East/Southeast Asian" then eth = "East/South Asian";
run;

data hbsccomp_m2;
set hbsccomp_m;
if eth = "South Asian" then eth = "East/South Asian";
if eth = "East/Southeast Asian" then eth = "East/South Asian";
run;

data hbsccomp_f_la_cm;
set hbsccomp_f1;
if eth = "Latin American" then eth = "Caucasian Mixed";
if id1 = 10 then id1 = 8;
run;

*Total boys Binge;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls Binge;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total boys Tobacco;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls Tobacco;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total boys Chewing Tobacco;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls Chewing Tobacco;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total boys Cannabis;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls Cannabis;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total boys hard drug;
proc genmod data = hbsc2_m2 desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls hard drug;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total boys meds;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Total girls meds;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

*Comp boys binge;
proc genmod data = hbsccomp_m descending;
title "Binge M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model binge =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp boys tobacco;
proc genmod data = hbsccomp_m descending;
title "Tobacco M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model tobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp boys cannabis;
proc genmod data = hbsccomp_m descending;
title "Cannabis M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model cannabis =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp boys chew;
proc genmod data = hbsccomp_m descending;
title "Chew M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model chewingtobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp boys meds;
proc genmod data = hbsccomp_m2 descending;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model meds =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp boys hard drugs;
proc genmod data = hbsccomp_m2 descending;
title "Drug M";
class id2 eth(ref = "Caucasian") grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model harddrug = bskt m2 eth family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls binge;
proc genmod data = hbsccomp_f1 descending;
title "Binge F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model binge =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls tobacco;
proc genmod data = hbsccomp_f1 descending;
title "Tobacco F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model tobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls cannabis;
proc genmod data = hbsccomp_f_la_cm descending;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model cannabis =  bskt eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls chew;
proc genmod data = hbsccomp_f_la_cm descending;
title "Chew M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model chewingtobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls meds;
proc genmod data = hbsccomp_f1 descending;
title "Meds F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model meds =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Comp girls hard drugs;
proc genmod data = hbsccomp_f1 descending;
title "hard drugs F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model harddrug =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;
