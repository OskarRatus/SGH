* IMPORT DATA;
FILENAME REFFILE '/folders/myfolders/main/dane.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.DATA;
	GETNAMES=YES;
RUN;


*******************************************;
* Metoda aktuarialna;
*******************************************;
* model czysty;
proc lifetest data=work.data method=act plots=(s,p);
time survival*status(0);
run;

*zmienne warstwujące;
proc lifetest data=work.data method=act plots=(s,h,p);
time survival*status(0);
strata call_type /diff=all;
run;




*******************************************;
* Metoda Kaplan Meiera;
*******************************************;
* model czysty;
ods graphics on;
proc lifetest data=work.data method=km
	plots=(s h ls lls);
	time survival*status(0);
run;

* zmienna warstwująca;
proc lifetest data=work.data method=km;
time survival*status(0);
strata cell_type;
run;

* poprawka Tukeya;
proc lifetest data=work.data method=km;
time survival*status(0);
strata cell_type /ADJUST=TUKEY;
run;


proc lifetest data=work.data method=km;
	time survival*status(0);
	*strata treatment;
run;



proc means data=work.data;
run;


ods graphics on;
proc univariate data=work.data;
class treatment;
histogram / kernel overlay;
run;