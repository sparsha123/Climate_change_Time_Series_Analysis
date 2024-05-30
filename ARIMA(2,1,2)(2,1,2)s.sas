/*
 *
 * Task code generated by SAS Studio 3.8 
 *
 * Generated on '2/26/23, 12:15 PM' 
 * Generated by 'Asus' 
 * Generated on server 'SHUBHAM' 
 * Generated on SAS platform 'X64_10HOME WIN' 
 * Generated on SAS version '9.04.01M6P11152018' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.56' 
 * Generated on web client 'http://localhost:59671/main?locale=en_US&zone=GMT-05%253A00&sutoken=%257B17536304-6A05-423B-9814-78203DE143A8%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=STSM.GLOBALTEMPERATURE out=Work.preProcessedData;
	by dt;
run;

proc arima data=Work.preProcessedData plots
    (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecastonly)) out=work.out;
	identify var=LandAndOceanAverageTemperature(1 12);
	estimate p=(1 2) (12 24) q=(1 2) (12 24) method=ML outest=work.outest 
		outstat=work.outstat;
	forecast lead=1032 back=12 alpha=0.05 id=dt interval=month;
	outlier;
	run;
quit;

proc delete data=Work.preProcessedData;
run;