data hbsc;
set out.Hbsc2010oaed1_0_f4;
if countryno NE 124000 then delete;
run;

proc freq data = hbsc;
tables grade;
run;

data subset;
set hbsc;
if agecat NE 3 then delete;
drunkdi = 1;
if drunk > 1 then drunkdi = 2;
aldi = 1;
if alcopops > 1 then aldi = 2;
alagedi = 1;
if agealco > 1 then alagedi = 2;
d30di = 1;
if drunk30d > 1 then d30di = 2;
cltmdi = 1;
if cannabisltm > 1 then cltmdi = 2;
c30di = 1;
if cannabis30d > 1 then c30di = 2;
ftdi = 1;
if fight12m > 1 then ftdi = 2;
sexadi = 1;
if agesex > 1 then sexadi = 2;
if agesex > 4 then sexadi = 3;
cnevdi = contraceptnever;
smokedi = triedsmoke;
smoke2di = 1;
if smoking > 1 then smoke2di = 2;
smoke3di = 1;
if agecigarette > 1 then smoke3di = 2;
smoke4di = 1;
if smoke30d > 1 then smoke4di = 2;
run;
/*
proc freq data = subset;
tables drunk alcopops agealco drunk30d 
cannabisltm cannabis30d 
fight12m 
hadsex agesex contraceptnever 
triedsmoke smoking agecigarette smoke30d;
run;
*/
proc lca data = subset;
nclass 7;
items 
sexadi 
/*drunkdi*/ 
aldi 
/*d30di*/
/*alagedi*/ 
/*cltmdi*/ 
c30di
/*ftdi*/ 
/*cnevdi*/
smokedi 
/*smoke2di*/
/*smoke3di*/ 
/*smoke4di*/
;
categories 
3 2 2 2
;
seed 10000;
rho prior = 1;
run;
/*
proc lca data = subset;
nclass 2;
items 
drunk alcopops agealco drunk30d 
cannabisltm cannabis30d 
fight12m 
hadsex agesex contraceptnever 
triedsmoke smoking agecigarette smoke30d
;
categories 
5 5 7 7 
7 7 
5 
2 8 2 
2 4 7 7
;
seed 10000;
rho prior = 1;
run;

proc lca data = subset;
nclass 2;
items 
drunk alcopops
;
categories 
5 5 
;
seed 10000;
rho prior = 1;
run;

DATA test;
INPUT it1 it2 it3 it4 count;
DATALINES;
1  1  1  1  5
1  1  1  2  5
1  1  2  1  9
1  1  2  2  8
1  2  1  2  5
1  2  2  1  8
1  2  2  2  4
2  1  1  1  5
2  1  1  2  3
2  1  2  1  6
2  1  2  2  8
2  2  1  1  3
2  2  1  2  7
2  2  2  1  5
2  2  2  2  10
;
RUN;
PROC LCA DATA=test;
NCLASS 2;
ITEMS it1 it2 it3 it4;
CATEGORIES 2 2 2 2;
FREQ count;
SEED 100000;
RHO PRIOR=1;
RUN;
