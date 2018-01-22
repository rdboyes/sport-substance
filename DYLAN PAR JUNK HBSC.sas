*Split dataset into male and female datasets;
data hbsc2_m;
set hbsc2;
if (m1=1) then output;
run;

data hbsc2_f;
set hbsc2;
if (m1=2) then output;
run;

data hbsc3_m;
set hbsc3;
if (m1=1) then output;
run;

data hbsc3_f;
set hbsc3;
if (m1=2) then output;
run;

data hbsc2_mhs;
set hbsc2_f;
if (heavysmoke=0) then output;
run;

proc surveyfreq data = hbsc2_mhs;
tables sports;
weight wtcan;
run;

*empty model binge drinking;
proc glimmix data=hbsc2_m;
class binge id2;
model binge =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2;
class binge id2;
model binge =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class binge id2;
model binge =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*empty model tobacco;
proc glimmix data=hbsc2_m;
class tobacco id2;
model tobacco =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class tobacco id2;
model tobacco =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*empty model chewing tobacco;
proc glimmix data=hbsc2_m;
class chewingtobacco id2;
model chewingtobacco =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class chewingtobacco id2;
model chewingtobacco =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*empty model cannabis;
proc glimmix data=hbsc2_m;
class cannabis id2;
model cannabis =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class cannabis id2;
model cannabis =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*empty model hard drugs;
proc glimmix data=hbsc2_m;
class harddrug id2;
model harddrug =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class harddrug id2;
model harddrug =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*empty model meds;
proc glimmix data=hbsc2_m;
class meds id2;
model meds =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

proc glimmix data=hbsc2_f;
class meds id2;
model meds =/ dist=binary link=logit ddfm=bw solution;
random intercept/sub=id2 solution;
run;

*prevalence binge drinking;
proc sort data=hbsc2_m;
by binge;
run;

proc surveyfreq data=hbsc2_m;
tables binge*sports;
weight wtcan;
run;

proc sort data=hbsc2_f;
by binge;
run;

proc surveyfreq data=hbsc2_f;
tables binge;
weight wtcan;
run;

*prevalence smoking;
proc sort data=hbsc2_m;
by tobacco;
run;

proc surveyfreq data=hbsc2_m;
tables tobacco;
weight wtcan;
run;

proc sort data=hbsc2_f;
by tobacco;
run;

proc surveyfreq data=hbsc2_f;
tables tobacco;
weight wtcan;
run;

*prevalence cannabis;
proc sort data=hbsc2_m;
by cannabis;
run;

proc surveyfreq data=hbsc2_m;
tables cannabis;
weight wtcan;
run;

proc sort data=hbsc2_f;
by cannabis;
run;

proc surveyfreq data=hbsc2_f;
tables cannabis;
weight wtcan;
run;

*prevalence chewing tobacco;
proc sort data=hbsc2_m;
by chewingtobacco;
run;

proc surveyfreq data=hbsc2_m;
tables chewingtobacco;
weight wtcan;
run;

proc sort data=hbsc2_f;
by chewingtobacco;
run;

proc surveyfreq data=hbsc2_f;
tables chewingtobacco;
weight wtcan;
run;

*prevalence meds;
proc sort data=hbsc2_m;
by meds;
run;

proc surveyfreq data=hbsc2_m;
tables meds;
weight wtcan;
run;

proc sort data=hbsc2_f;
by meds;
run;

proc surveyfreq data=hbsc2_f;
tables meds;
weight wtcan;
run;

*prevalence hard drugs;
proc sort data=hbsc2_m;
by harddrug;
run;

proc surveyfreq data=hbsc2_m;
tables harddrug;
weight wtcan;
run;

proc sort data=hbsc2_f;
by harddrug;
run;

proc surveyfreq data=hbsc2_f;
tables harddrug;
weight wtcan;
run;


*log binomial test;
proc genmod data = hbsc2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
run;

proc genmod data = hbsc3_m descending;
class sports(ref=first) id2 eth grade family siblings m132 id1 mm84 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002 /link = log dist = binomial;
repeated subject=id2/type=cs;
run;

proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model binge = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model binge = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*tobacco smoking;
proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model tobacco = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model tobacco = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*chewing tobacco;
proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model chewingtobacco = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model chewingtobacco = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*cannabis;
proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model cannabis = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model cannabis = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*hard drugs;
proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model harddrug = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model harddrug = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

*meds;
proc glimmix data = hbsc2_m method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model meds = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;

proc glimmix data = hbsc2_f method = quadrature(qpoints=7) empirical=classical;
class sports(ref=first) id2 eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat;
model meds = sports eth m2 family siblings m132 id1 mm84 StatsCanCode supportcat _TEMG002/link = log dist = poisson solution;
random intercept /subject = id2;
run;
