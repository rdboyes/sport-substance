/*
proc mi data = hbsc2 out=miout1 nimpute = 20;
class  m132 m126 m127 m128 m131;
var m132 m126 m127 m128 m131;
fcs discrim(m132=m126 m127 m128 m131/classeffects = include);
fcs discrim(m126=m127 m128 m131 m132/classeffects = include);
fcs discrim(m127=m126 m128 m131 m132/classeffects = include);
fcs discrim(m128=m126 m127 m131 m132/classeffects = include);
fcs discrim(m131=m126 m127 m128 m132/classeffects = include);
run;
*/
proc mi data = hbsc2 out=miout1 nimpute = 20;
class  mm82 mm83 mm84 mm85;
var mm82 mm83 mm84 mm85;
*Family Support;
fcs discrim(mm82=mm83 mm84 mm85/classeffects = include);
fcs discrim(mm83=mm82 mm84 mm85/classeffects = include);
fcs discrim(mm84=mm82 mm83 mm85/classeffects = include);
fcs discrim(mm85=mm83 mm84 mm82/classeffects = include);
run;

data miout1;
set miout1;
if mm82 <= 2 && mm83 <= 2 && mm84 <= 2 && mm85 <= 2 then supportcat = 1;
else if mm82 >= 3 && mm83 >= 3 && mm84 >= 3 && mm85 >= 3 then supportcat = 2;
else if mm82 <= 3 && mm83 <= 3 && mm84 <= 3 && mm85 <= 3 then do;
	if mm82 >= 2 && mm83 >= 2 && mm84 >= 2 && mm85 >= 2 then supportcat = 3;
end;
else supportcat = 4;
run;

data miout1_m;
set miout1;
if m1 = 1 then output;
run;

data miout1_f;
set miout1;
if m1 = 2 then output;
run;

*Total boys Binge;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_mb;
run;

*Total girls Binge;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_fb;
run;

*Total boys Tobacco;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_mt;
run;

*Total girls Tobacco;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_ft;
run;

*Total boys Chewing Tobacco;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_mct;
run;

*Total girls Chewing Tobacco;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_fct;
run;

*Total boys Cannabis;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_mc;
run;

*Total girls Cannabis;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_fc;
run;

*Total boys hard drug;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_md;
run;

*Total girls hard drug;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_fd;
run;

*Total boys meds;
proc genmod data = miout1_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_mm;
run;

*Total girls meds;
proc genmod data = miout1_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output GEEEmpPEst = gm_fm;
run;     

proc mianalyze parms(classvar=level)=gm_mb;
title "Binge M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

proc mianalyze parms(classvar=level)=gm_fb;
title "Binge F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;  

proc mianalyze parms(classvar=level)=gm_mt;
title "Tobacco M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;    

proc mianalyze parms(classvar=level)=gm_ft;
title "Tobacco F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;    

proc mianalyze parms(classvar=level)=gm_mct;
title "CTobacco M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;   

proc mianalyze parms(classvar=level)=gm_fct;
title "CTobacco F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;    

proc mianalyze parms(classvar=level)=gm_mc;
title "Cannabis M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;   

proc mianalyze parms(classvar=level)=gm_fc;
title "Cannabis F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

proc mianalyze parms(classvar=level)=gm_md;
title "Drug M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

proc mianalyze parms(classvar=level)=gm_fd;
title "Drug F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;
   
proc mianalyze parms(classvar=level)=gm_mm;
title "Meds M";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;  

proc mianalyze parms(classvar=level)=gm_fm;
title "Meds F";
class sports id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

/* Family imputation models */
/*
proc mi data = hbsc2 out=miout2 nimpute = 20;
class  mm82 mm83 mm84 mm85;
var mm82 mm83 mm84 mm85;
*Family Support;
fcs discrim(mm82=mm83 mm84 mm85/classeffects = include);
fcs discrim(mm83=mm82 mm84 mm85/classeffects = include);
fcs discrim(mm84=mm82 mm83 mm85/classeffects = include);
fcs discrim(mm85=mm83 mm84 mm82/classeffects = include);
run;

data miout2;
set miout2;
if mm82 <= 2 && mm83 <= 2 && mm84 <= 2 && mm85 <= 2 then supportcat = 1;
else if mm82 >= 3 && mm83 >= 3 && mm84 >= 3 && mm85 >= 3 then supportcat = 2;
else if mm82 <= 3 && mm83 <= 3 && mm84 <= 3 && mm85 <= 3 then do;
	if mm82 >= 2 && mm83 >= 2 && mm84 >= 2 && mm85 >= 2 then supportcat = 3;
end;
else supportcat = 4;
run;

data miout2_m;
set miout2;
if m1 = 1 then output;
run;

data miout2_f;
set miout2;
if m1 = 2 then output;
run;

*Total boys Binge;
proc genmod data = miout2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_mb2;
run;

data gm_mb2;
set gm_mb2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_mb2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls Binge;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model binge = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_fb2;
run;

data gm_fb2;
set gm_fb2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fb2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total boys Tobacco;
proc genmod data = miout2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_mt2;
run;

data gm_mt2;
set gm_mt2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_mt2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls Tobacco;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model tobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_ft2;
run;

data gm_ft2;
set gm_ft2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_ft2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total boys Chewing Tobacco;
proc genmod data = miout2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_mct2;
run;

data gm_mct2;
set gm_mct2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_mct2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls Chewing Tobacco;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model chewingtobacco = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_fct2;
run;

data gm_fct2;
set gm_fct2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fct2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total boys Cannabis;
proc genmod data = miout1_2 desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_mc2;
run;

data gm_mc2;
set gm_mc2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_mc2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls Cannabis;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model cannabis = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_fc2;
run;

data gm_fc2;
set gm_fc2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fc2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total boys hard drug;
proc genmod data = miout2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_md2;
run;

data gm_md2;
set gm_md2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_md2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls hard drug;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model harddrug = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_fd2;
run;

data gm_fd2;
set gm_fd2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fd2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total boys meds;
proc genmod data = miout2_m desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_mm2;
run;

data gm_mm2;
set gm_mm2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_mm2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;

*Total girls meds;
proc genmod data = miout2_f desc;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
model meds = sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002 /link = log dist = poisson dscale;
repeated subject=id2/type=cs;
by _imputation_;
ods output ParameterEstimates = gm_fm2;
run;

data gm_fm2;
set gm_fm2;
Level1 = sports;
run;      

proc mianalyze parms(classvar=level)=gm_fm2;
class sports(ref=first) id2 eth grade family siblings id1 m132 StatsCanCode supportcat;
modeleffects sports eth grade family siblings m132 id1 StatsCanCode supportcat _TEMG002;
run;
