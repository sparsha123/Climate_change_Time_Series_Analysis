%let nhold=24;
%include "C:\Users\admin\Desktop\Husky\sem2\dataset\macros2.sas" / source2;


%accuracy_prep(indsn=STSM.'GLOBALFULL'n,series='LandAndOceanAverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);


ods noproctitle;
ods graphics / imagemap=on;
ods select none;


proc arima data=Work.preProcessedData plots
     (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecast) );
	identify var=LandAndOceanAverageTemperature(12);
	estimate p=(1 2) q=(1) (12) method=ML outstat=work.outstat;
	forecast lead=960 back=12 alpha=0.05 id=dt interval=month  out=work.out;
	estimate p=(1 2) (12) q=(1 2) (12) method=ML;
	forecast lead=960 back=12 alpha=0.05 id=dt interval=month  out=work.model2;
	estimate p=(1 2) (12 24) q=(1 2) (12 24) method=ML outstat=work.outstat;
	forecast lead=960 back=12 alpha=0.05 id=dt interval=month  out=work.model3;
	outlier;
	run;
quit;

ods select all;

%accuracy(indsn=work.out,series='LandAndOceanAverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);
%accuracy(indsn=work.model2,series='LandAndOceanAverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);
%accuracy(indsn=work.model3,series='LandAndOceanAverageTemperature'n,timeid='dt'n,
 numholdback=&nhold);

 
data work.allmodels;
 set work.out
 set work.model2
 set work.model3
run;

proc print data=work.allmodels label;
 id series model;
run;