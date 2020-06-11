LIBNAME khanproj "C:\Users\usman\Desktop\sas_proj_2";
data khanproj.project1;
 set khanproj.project4;
 run;

* create pie chart for buyers vs nonbuyers;



PROC SGRENDER DATA = khanproj.project1
            TEMPLATE = pie;
RUN;

* create pie chart for males & females from buyer segment;

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Males & Females in Buyer Segment"; 
         LAYOUT REGION;
            PIECHART CATEGORY = sex /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Male & Female Distribution (Nobuyer)';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.buyer
            TEMPLATE = pie;
RUN;



* create pie chart for males & females from nobuyer segment;

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Males & Females in Nobuyer Segment"; 
         LAYOUT REGION;
            PIECHART CATEGORY = sex /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Male & Female Distribution (Buyer)';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.nobuyer
            TEMPLATE = pie;
RUN;

* martial_status variable against purchase (y/m) variable; 

proc freq data = khanproj.marriedbuyer;
tables PURCHASE*MARITAL
/chisq 
;
run;


* create pie chart for married & nomarried from dataset;


PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Married & Unmarried in dataset"; 
         LAYOUT REGION;
            PIECHART CATEGORY = Marital /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Unmarried & Married Distribution';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.project1
            TEMPLATE = pie;
RUN;


* create pie chart for married & nomarried from buyers;


PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Married & Unmarried in Buyers"; 
         LAYOUT REGION;
            PIECHART CATEGORY = Marital /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Unmarried & Married in Buyers';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.buyer
            TEMPLATE = pie;
RUN;


* create pie chart for married & nomarried from nobuyers;


PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Married & Unmarried in Nobuyer"; 
         LAYOUT REGION;
            PIECHART CATEGORY = Marital /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Unmarried & Married Distribution';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.nobuyer
            TEMPLATE = pie;
RUN;




* Getting a snapshot about the data;

ODS pdf FILE = "C:\users\usman\desktop\sas_proj\data_contents.pdf"; 

 PROC CONTENTS DATA = khanproj.project1;
RUN;
ODS pdf close; 



* Separating the femaleonly;

PROC SQL; 

CREATE table femaleonly  AS
select * from khanproj.project1 where SEX='female';
quit;



* Separating the maleonly ;

PROC SQL; 

CREATE table maleonly AS
select * from khanproj.project1 where SEX='male';
quit;


* Separating the marriedbuyer;

PROC SQL; 

CREATE table marriedbuyer AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE, SEX    from khanproj.project1 where marital=1 AND PURCHASE=1;
quit;



* Separating the nomarriedbuyer;

PROC SQL; 

CREATE table marriednobuyer AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE, SEX from khanproj.project1 where marital=0 AND PURCHASE=1;
quit;




* Separating the nomarriedbuyer;

PROC SQL; 

CREATE table nomarriedbuyer AS
select * from khanproj.project1 where marital=0 AND PURCHASE=1;
quit;




* Separating the nomarriednobuyer;

PROC SQL; 

CREATE table nomarriednobuyer AS
select * from khanproj.project1 where marital=0 AND PURCHASE=0;
quit;

* CHi-square test for PUrchase vs Marital; 

proc freq data = khanproj.marriedbuyer;
tables PURCHASE*MARITAL
/chisq 
;
run;


proc univariate data = khanproj.marriedbuyer noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 6000 to 12000 by 4000;
run;



proc univariate data = khanproj.nomarriedbuyer noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 6000 to 12000 by 4000;
run;

PROC UNIVARIATE DATA = marriedbuyer;
 VAR INCOME;
RUN;


PROC UNIVARIATE DATA = nomarriedbuyer;
 VAR INCOME;
RUN;





* Separating the femalebuyermarried;

PROC SQL; 

CREATE table femalebuyermarried  AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE     from khanproj.project1 where SEX='female' AND Purchase=1 AND marital=1;
quit;


* Separating the femalenobuyermarried;

PROC SQL; 

CREATE table femalenobuyermarried  AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE     from khanproj.project1 where SEX='female' AND Purchase=0 AND marital=1;
quit;



proc univariate data = khanproj.femalebuyermarried noprint;
histogram AMOUNt
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 300 to 2000 by 300;
run;



proc univariate data = khanproj.femalenobuyermarried noprint;
histogram AMOUNT
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 30 to 2000 by 300;
run;



proc univariate data = khanproj.femalebuyermarried noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 2000 to 6000 by 3000;
run;



proc univariate data = khanproj.femalenobuyermarried noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 2000 to 6000 by 3000;
run;


* create pie chart for married & unmarried from nobuyer;

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Married & Unmarried in Nobuyer Segment"; 
         LAYOUT REGION;
            PIECHART CATEGORY = Marital/
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Married & Unmarried Distribution (Nobuyer)';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.nobuyer
            TEMPLATE = pie;
RUN;

* for those who are not buying;

PROC SQL; 

CREATE table khanproj.nobuyermarried  AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE,SEX     from khanproj.nobuyer where marital=1;
quit;


PROC SQL; 

CREATE table khanproj.nobuyerunmarried  AS
select AMOUNT, INCOME, HOMEVAL,AGE,EDLEVEL, RACE,SEX     from khanproj.nobuyer where marital=0;
quit;


* create pie chart for married & unmarried from nobuyer;

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Mael & Female in Nobuyer + Married Segment"; 
         LAYOUT REGION;
            PIECHART CATEGORY = SEX/
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Male & Female Distribution from Nobuyer & Married';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.nobuyermarried
            TEMPLATE = pie;
RUN;


* create pie chart for married & unmarried from nobuyer;

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
	  entrytitle "Number of Mael & Female in Nobuyer + Unmarried Segment"; 
         LAYOUT REGION;
            PIECHART CATEGORY = SEX/
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = ALL
            CATEGORYDIRECTION = CLOCKWISE
            DATASKIN = SHEEN 
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Male & Female Distribution from Nobuyer & Unmarried';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = khanproj.nobuyerunmarried
            TEMPLATE = pie;
RUN;














* Separating the buyer ;

PROC SQL; 

CREATE table buyer AS
select * from khanproj.project1 where Purchase=1;
quit;

* Separating the non-buyer;

PROC SQL;
CREATE table nobuyer AS
select * from khanproj.project1 where Purchase=0;
quit;

* Separating buyer  males;
PROC SQL;
CREATE table buyermale AS
select * from khanproj.buyer where SEX = 'male';
quit;

* Separating buyer females;
PROC SQL;
CREATE table buyerfemale AS
select * from khanproj.buyer where SEX='female';
quit;

* Separating nobuyer  males;
PROC SQL;
CREATE table nobuyermale AS
select * from khanproj.nobuyer where SEX='male';
quit;

* Separating nobuyer females;

PROC SQL;
CREATE table nobuyerfemale AS
select * from khanproj.nobuyer where SEX='female';
quit;





PROC UNIVARIATE DATA = khanproj.nobuyerfemale;
 VAR INCOME;
RUN;


PROC UNIVARIATE DATA = khanproj.buyermale;
 VAR INCOME;
RUN;

PROC UNIVARIATE DATA = khanproj.nobuyermale;
 VAR INCOME;
RUN;



proc univariate data = khanproj.nobuyermale noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 0 to 16000 by 1000;
run;






proc univariate data = khanproj.marriedbuyer noprint;
histogram INCOME
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent
midpoints = 0 to 16000 by 2000;
run;

proc univariate data = khanproj.buyermale ;
   histogram Amount
   / midpoints = 15000 to 16000 by 1000;
run;




PROC SGPLOT  DATA = khanproj.project1;
   VBOX AMOUNT 
   / category = Age;

   title 'Horsepower of cars by types';
RUN; 





* Box  plot code;

PROC SGPANEL  DATA = khanproj.project1;
PANELBY PURCHASE / columns = 1 novarname;

   VBOX amount   / category = RACE;

   title 'Horsepower of cars by types';
RUN; 






* Box plot code;

PROC SGPANEL  DATA = khanproj.marriedbuyer;
PANELBY PURCHASE/ columns = 1 novarname;

   VBOX AGE / category = RACE;

   title 'Horsepower of cars by types';
RUN; 



PROC SGPANEL  DATA = khanproj.nomarriedbuyer;
PANELBY PURCHASE/ columns = 1 novarname;

   VBOX AGE / category = RACE;

   title 'Horsepower of cars by types';
RUN; 



PROC SGPANEL  DATA = khanproj.marriednobuyer;
PANELBY PURCHASE/ columns = 1 novarname;

   VBOX JOB / category = RACE;

   title 'Horsepower of cars by types';
RUN; 



PROC SGPANEL  DATA = khanproj.nomarriednobuyer;
PANELBY PURCHASE/ columns = 1 novarname;

   VBOX JOB / category = RACE;

   title 'Horsepower of cars by types';
RUN; 




proc FREQ data = khanproj.nobuyermarried ;
tables SEX RACE EDLEVEL ;
run;


proc FREQ data = buyermale ;
tables JOB RACE ;
run;

proc FREQ data = nobuyerfemale ;
tables JOB RACE ;
run;


proc FREQ data = buyerfemale ;
tables JOB RACE ;
run;

proc reg data = nobuyermale;
model AMOUNT = INCOME, HOMEVAL ;
run;

proc corr data = khanproj.nobuyermale rank plots(only) = scatter(elipse=none);
	VAR INCOME HOMEVAL;
with AMOUNT;
title 'Age of Account vs Other Selected Variables';
run;



proc template;
   edit Base.Corr.StackedMatrix;
      column (RowName RowLabel) (Matrix);
      header 'Pearson Correlation Coefficients';
      edit matrix;format=5.2 style={foreground=paintfmt8. font_weight=bold};end;
   end;
quit;

ods select none;
proc corr data=khanproj.nobuyermale noprob;
   ods output PearsonCorr=p;
run;

proc FREQ data = khanproj.project1;
tables race; 
by PURCHASE;
run;

PROC FREQ DATA = khanproj.nobuyer;
 TABLE RACE /MISSING;
 FORMAT RACE PURCHASE;
RUN;

PROC FREQ DATA = khanproj.buyer;
 TABLE RACE /MISSING;
 FORMAT RACE PURCHASE;
RUN;


proc freq data = khanproj.marriedbuyer;
tables EDLEVEL*RACE
/chisq 
;
run;

PROC FREQ DATA = khanproj.marriedbuyer;
 TABLE SEX race EDLEVEL;
 
RUN;


PROC FREQ DATA = khanproj.nomarriedbuyer;
 TABLE SEX race EDLEVEL;
 
RUN;


data intelli;
a = 32,
b='hello',

run;

proc print;
run;


