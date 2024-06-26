/*
 *
 * Task code generated by SAS Studio 3.8 
 *
 * Generated on '2/26/23, 12:21 PM' 
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

proc esm data=Work.preProcessedData back=12 lead=12 seasonality=12 plot=(corr 
		errors modelforecasts) out=work.out outest=work.outest outstat=work.outstat;
	id dt interval=month;
	forecast LandAndOceanAverageTemperature / alpha=0.05 model=winters 
		transform=none;
run;

proc delete data=Work.preProcessedData;
run;