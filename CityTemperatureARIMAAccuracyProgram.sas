%let nhold=24;
%include "C:\Users\admin\Desktop\Husky\sem2\dataset\macros2.sas" / source2;


%accuracy_prep(indsn=STSM.'GTBYCITYMONTH'n,series='AverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);


ods noproctitle;
ods graphics / imagemap=on;
ods select none;


proc arima data=Work.preProcessedData plots
     (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecast) );
	identify var=AverageTemperature(12);
	estimate p=(1 2) q=(1 2) (12) method=ML outstat=work.outstat;
	forecast lead=960 back=12 alpha=0.05 id=dt interval=month  out=work.CityModel1;
	estimate p=(1 2 3) q=(1 2) (12) method=ML outstat=work.outstat;
	forecast lead=960 back=12 alpha=0.05 id=dt interval=month  out=work.CityModel2
	outlier;
	run;
quit;

ods select all;

%accuracy(indsn=work.CityModel1,series='AverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);
%accuracy(indsn=work.CityModel2,series='AverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);

 
data work.allmodels;
 set work.CityModel1
 set work.CityModel2
run;

proc print data=work.allmodels label;
 id series model;
run;