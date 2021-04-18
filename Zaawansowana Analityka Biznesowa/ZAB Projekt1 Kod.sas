**************** DATA IMPORT;
PROC IMPORT OUT= data
            DATAFILE= "C:\Users\Bartosz Baszniak\Desktop\melb.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
	 delimiter=',';
RUN;

**************** DATA CLEANING;
	* Missing -> Car, BuildingArea, YearBuilt;
	* Price -> H1: not normal;
proc univariate data=data normal;
	histogram;
run;

data data; set data; run;

***** DATA TRANSFORMATION;
data dataWork;
	set data;
	if Price > 0 then Price = log(Price);
	if Distance > 0 then Distance = log(Distance);
	if Landsize> 0 then Landsize = log( Landsize);
	*BuildingArea = log( BuildingArea);
	 	
	drop Postcode Date;
run;

***** is Price normal?;
	* Price not normal, NIE WIEM CO Z TYM ZROBIÆ PO PROSTU POMIN¥£EM;
proc univariate data=dataWork normal;
	histogram;
run;
*****;


****************;


**************** DATA EXPLORATION;
***** correlation;
	* biggest corr BuildingArea = 0.64;
	* smallest corr Propertycount = -0.08;
proc corr data = dataWork;
run;

***** linearity;
	* raw model wtih all var;
proc reg data = datawork; 
	model Price = Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount / tol vif;
run; 

	* drop Rooms (tol < 0.4);
proc reg data = datawork; 
	model Price = Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount / tol vif;
run; 	

	* drop Bedroom2 (tol <0.4);
proc reg data = datawork; 
	model Price = Distance Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount / tol vif;
run; 
****************;


**************** MODEL BEFORE IMPUTATION;
 	* zmienne klasyfikujace dobrane tak zeby sie w miarê któtko liczy³o;
	* AIC = 229.9;
proc mixed data=dataWork;
	class  Type CouncilArea;
	model Price =  Distance Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount Type CouncilArea  / solution;
	ods output SOLUTIONF = WynikiPrzedImpu;
run;
****;


**************** IMPUTATION;
	*Check pattern;
	* tutaj za³o¿y³em ¿e wzór nie jest monotoniczny, nie wiem czy sama ta tabelka wystarczy;
	* inna grupa robi³a jeszcze testy za pomoc¹ procedury PROC TTEST i PROC FREQ;
proc mi data=dataWork nimpute=0 ;
	class Type CouncilArea ;
	var Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount Type CouncilArea ;
	fcs nbiter=10 discrim(/CLASSEFFECTS=INCLUDE);
run;

** FCS;
	* no. of input = 100;
	* discrim param to include class variables;
	* nbiter - deafult value;
proc mi data=dataWork out=imputOut nimpute=100 round=0.001;
	class Type CouncilArea ;
	var Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount Type CouncilArea ;
	fcs nbiter=10 reg(/details) discrim(/CLASSEFFECTS=INCLUDE);
run;


data imputOut;
set imputOut;
rename _imputacja_=_imputation_;
run;
** MCMC;
	*cant use because of class variables;
/* proc mi data=dataWork out=imputOut nimpute=100 seed = 1234; */
/* 	var Price Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount; */
/* 	mcmc initial=em; */
/* run; */


****;


**************** MODEL AFTER IMPUTATION;
	* solution parameter to output estimates;
	* AIC = 211.4;
proc mixed data=imputOut;
	class Type CouncilArea ;
	model Price = Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount Type CouncilArea / solution;
	by _Imputation_;
	ods output  SOLUTIONF=wyniki;
run;
****;


**************** IMPUTATION SUMMARY;
proc mianalyze parms=wyniki;
	class Type CouncilArea;
 	modeleffects Intercept Rooms Distance Bedroom2 Bathroom Car Landsize Yearbuilt BuildingArea Lattitude Longtitude  Propertycount Type CouncilArea;
	ods output parameterestimates = po;
run;
****************;

