data hbsc2_m;
set hbsc_s1;
if m1 = 2 then delete;
if m1 = . then delete;
run;

data hbsc2_f;
set hbsc_s1;
if m1 = 1 then delete;
if m1 = . then delete;
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
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug =  sports eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = logit dist = binomial solution;
random intercept /subject = id2;
run;


*Total girls hard drug;
proc genmod data = hbsc2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=exch;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat harddrug(ref=first);
model harddrug = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = logit dist = binomial solution;
random intercept /subject = id2;
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
model tobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp boys cannabis;
proc genmod data = hbsccomp_m descending;
title "Cannabis M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model cannabis =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp boys chew;
proc genmod data = hbsccomp_m descending;
title "Chew M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model chewingtobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

data hbsccomp_m2;
set hbsccomp_m;
if eth = "South Asian" then eth = "East/South Asian";
if eth = "East/Southeast Asian" then eth = "East/South Asian";
run;

*Comp boys meds;
proc genmod data = hbsccomp_m1 descending;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model meds =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp boys hard drugs;
proc genmod data = hbsccomp_m2 descending;
title "Drug M";
class id2 eth(ref = "Caucasian") grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model harddrug = bskt m2 eth family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson dscale;
repeated subject = id2/type=exch;
run;

*Creating new competitive sport variable for girls with lower sport participation;
data hbsccomp_f1;
set hbsccomp_f;
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
if Q18 < 6 AND Q18 >= 1 then PA = 0;
else if Q18 >= 6 AND Q18 <= 8 then PA = 1;
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

*Comp girls binge;
proc genmod data = hbsccomp_f1 descending;
title "Binge F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model binge =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp girls tobacco;
proc genmod data = hbsccomp_f1 descending;
title "Tobacco F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model tobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp girls cannabis;
proc glimmix data = hbsccomp_f1 method = quadrature(qpoints=7) empirical=classical;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model cannabis =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = logit dist = binomial solution;
random intercept /subject = id2;
run;

*Comp girls chew;
proc glimmix data = hbsccomp_f1 method = quadrature(qpoints=7) empirical=classical;
title "Meds M";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model chewingtobacco =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = logit dist = binomial solution;
random intercept /subject = id2;
run;

*Comp girls meds;
proc genmod data = hbsccomp_f1 descending;
title "Meds F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model meds =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Comp girls hard drugs;
proc genmod data = hbsccomp_f1 descending;
title "hard drugs F";
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat bskt(ref = first);
model harddrug =  bskt eth m2 family siblings m132 id1 StatsCanCode supportcat _TEMG002/link = log dist = poisson;
repeated subject = id2/type=exch;
run;

*Attaining case (substance abuse) exposure (team sport participation) prevalence for PAR estimates;
