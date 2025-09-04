/*******************************************************************************

*	 S C R I P T   T O   A T T A C H   E C O N O M I C   R I S K   V A L U E S
*	 			 	T O   T H E   E S S   R O U N D S  6 - 9

********************************************************************************

** Hanna Schwander, Dominik Flügel
** October 2019 (last updated June 2020)
** Table of Contents
	* 1 Short Description & Preliminaries ..............................Line  29
	* 2 Class Groups ...................................................Line  76
	* 3 Age & Gender ...................................................Line 133
	* 4 Combined Reference Groups ......................................Line 202
	* 5 Attach LMV Values ..............................................Line 480
** Cite as
	* Schwander, Hanna & Silja Häusermann (2013): Who is in and who is out? A risk-based conceptualization
	  of insiders and outsiders", in: Journal of European Social Policy (23) 3: pp. 248-269.
** References
	* Kitschelt, Herbert & Philip Rehm (2005): "Work, Family and Politics: Foundations of Electoral Partisan Alignments in
	  Postindustrial Democracies", paper presented at the Annual Meeting of the American Political Science Association.
	* Oesch, Daniel (2006) "Redrawing the Class Map. Stratification and Institutions in Britain, Germany, Sweden and
	  Switzerland", Basingstoke: Palgrave Macmillan.
** For questions or annotations, please contact us at dominik.fluegel@hu-berlin.de.

	  

********************************************************************************
* 1 SHORT DESCRIPTION & PRELIMINARIES
********************************************************************************
This do-file connects ESS data with respondents' economic risk or labor market 
vulnerability (lmv), based on Schwander & Häusermann (2013).
First, using 2-digit ISCO codes, the class schema by Oesch (2006) will be applied 
in the collapsed version of Kitschelt and Rehm (2005) with five class groups.
These five groups will then be disaggregated with binary gender and age variables 
to arrive at 20 reference groups. 
Second, the csv sheet based on EU SILC data of the desired year is imported and 
merged with the ESS dataset so that each respondent is attributed one lmv value
according to his or her respective reference group.
You have to specify a directory in line 68, the dataset in line 71, and the desired
years in line 72. Your directory has to contain the dataset and one or more of the
csv sheets downloaded at schwander-hanna.ch/data.

5 Class groups (Kitschelt & Rehm 2005)
  * 1 Capital Accumulators
  * 2 Mixed Service Functionaries
  * 3 Blue or Lower White Collar Workers
  * 4 Socio-Cultural (Semi-)Professionals
  * 5 Lower Service Functionaries
  
Note 1: In the following do-file, missing values are expected to be coded as such,
		i.e. ".a" instaed of "999". In previous editions of ESS data, missings had
		to be recoded manually.
Note 2: If you have a cumulation of more than one ESS round between 6 and 9, this
		do-file works fine. If you have an ESS cumulation that spans both one of
		rounds 6-9 and one of rounds 1-5, please use the do-file "Cumulation 1-9". 
Note 3: The execution of this do-file might issue some error codes. This is normal
		and accounts for the fact that not all years are available for all countries.
		For more information, see the help file of the "capture" command.
Note 4: This do-file is encoded in UTF-8.
Note 5: Respondents are coded into a class group based on their 2-digit ISCO code.
		We use 2-digit codes because the SILC data only provides 2-digit codes. 
		The association between 2- and 4-digit coding amounts to .89 (Cramer's V).

		
		*/
		
*clear all
version 14
cd "/Users/nastianedjai/Desktop/RiskVal" // Please specify your working directory
set more off
*log using ess_lmv, replace
*use "/Users/nastianedjai/Downloads/ESS7e02_3-ESS8e02_3-ESS9e03_2-subset/ESS7e02_3-ESS8e02_3-ESS9e03_2-subset.dta", clear // Please specify the ESS dataset you want this do-file to be executed on
local years 2016 2014 2018 //Please indicate (wihout quotes) the years for which you wish to obtain risk values, e.g.: 2007 2012 2015


********************************************************************************
* 2 Class Groups
********************************************************************************
** 2.1 Obtain two-digit ISCO values
gen isco08_2d = int(isco08/100)
tab isco08 isco08_2d in 1/5, nol //Check for errors in procedure

** 2.2 Assign class groups according to 2d ISCO08 values
gen groups=.

replace groups=1 if inlist(isco08_2d, 10, 11, 12, 13, 14, 20, 21, 24, 25, 33)
replace groups=2 if inlist(isco08_2d, 30, 31, 35, 40, 41, 42, 43, 44, 45)
replace groups=3 if inlist(isco08_2d, 60, 61, 62, 63, 70, 71, 72, 73, 74, 75, 80, 81, 82, 83, 92, 93, 96)
replace groups=4 if inlist(isco08_2d, 22, 23, 24, 26, 32, 34)
replace groups=5 if inlist(isco08_2d, 50, 51, 52, 53, 54, 91, 94, 95)

tab isco08_2d if groups==. //Check whether all ISCO groups are used 

** 2.3 Generate Variable for the Self-Employed
recode emplrel (6 7 8 9=9), copyrest gen(emplrel_4c)
label define emplrel_4c 1 "Employee" 2 "Self-employed" ///
						3 "Working for own family business" 9 "Missing"
label value emplrel_4c emplrel_4c

recode emplno (1/9=1)(10/10000=2), gen(emplno_3c)
label define emplno_3c 0 "0 employees" 1 "1-9 employees" 2 "10+ employees"
label value emplno_3c emplno_3c

gen selfem=. 
replace selfem=1 if emplrel_4c==1 | emplrel_4c==9
replace selfem=2 if emplrel_4c==2 & emplno_3c==0
replace selfem=2 if emplrel_4c==3
replace selfem=3 if emplrel_4c==2 & emplno_3c==1
replace selfem=3 if emplrel_4c==2 & emplno_3c==2
label variable selfem "Employment status for respondants"
label define selfem 1 "Not self-employed" 2 "Self-empl without employees" ///
					3 "Self-empl with employees" 
label value selfem selfem

replace groups=1 if selfem==3
replace groups=1 if selfem==2 & (isco08_2d>=20 & isco08_2d<=26)
replace groups=2 if selfem==2 & (isco08_2d>=10 & isco08_2d<=14)
replace groups=2 if selfem==2 & (isco08_2d>=30 & isco08_2d<=96)
label var groups "Respondent's socio-economic group"

#delimit ;
label define groups 
1 "Capital accumulators" 
2 "Mixed service functionaires" 
3 "Blue and lower white collar" 
4 "Socio-cultural (semi-)professionals" 
5 "Low service functionaires", modify;
#delimit cr
label values groups groups



********************************************************************************
* 3 Age and Gender Groups
********************************************************************************
* Gender
gen gender=.
replace gender=1 if gndr==2
replace gender=0 if gndr==1
label var gender "Gender"

label def gender 1 "Female" 0 "Male", modify
label values gender gender

* Age
gen year2 = inwyys
gen age = year2-yrbrn

gen young=.
replace young=1 if age<40
replace young=0 if age>=40

label var year2 "Year of Interview"
label var young "Young, under 40"

label def young 1 "Below 40" 0 "40+", modify
label val young young

* Combined Groups
** Young Women
gen youngfemale=.
label var youngfemale "Young Women "

replace youngfemale=1 if gender==1 & young==1
replace youngfemale=0 if gender==0 | young==0

label define youngfemale 1 "Young Female" 0 "Else", modify
label val youngfemale youngfemale

** Young Men 
gen youngmale =.
label var youngmale "Young Men"

replace youngmale =1 if gender==0 & young==1
replace youngmale =0 if gender==1 | young==0

label define youngmale 1 "Young Male" 0 "Else", modify
label val youngmale youngmale

** Old Women 
gen oldfemale=.
label var oldfemale "Old Women"

replace oldfemale =1 if gender==1 & young==0
replace oldfemale =0 if gender==0 | young==1

label define oldfemale 1 "Old Female" 0 "Else", modify
label val oldfemale oldfemale

** Old Men 
gen oldmale=.
label var oldmale "Old Men"

replace oldmale=1 if gender==0 & young==0
replace oldmale=0 if gender==1 | young==1

label define oldmale 1 "Old Male" 0 "Else", modify
la val oldmale oldmale



********************************************************************************
* 4 Combined Reference Groups
********************************************************************************
* LSF Young Female
gen LSF_youngfemale=.
label var LSF_youngfemale "LSF Young Women"

replace LSF_youngfemale=1 if youngfemale==1 & groups==5 
replace LSF_youngfemale=0 if youngfemale==1 & groups!=5
replace LSF_youngfemale=0 if youngfemale==0

label def LSF_youngfemale 1 "LSF Young Female" 0 "Else", modify
label val LSF_youngfemale LSF_youngfemale 

* LSF Young Male
gen LSF_youngmale=.
label var LSF_youngmale "LSF Young Men"

replace LSF_youngmale=1 if youngmale==1 & groups==5 
replace LSF_youngmale=0 if youngmale==1 & groups!=5
replace LSF_youngmale=0 if youngmale==0

label de LSF_youngmale 1 "LSF Young Male" 0 "Else", modify
label val LSF_youngmale LSF_youngmale

tab LSF_youngmale LSF_youngfemale

* LSF Old Female
gen LSF_oldfemale=.
la var LSF_oldfemale "LSF Old Women"

replace LSF_oldfemale=1 if oldfemale==1 & groups==5
replace LSF_oldfemale=0 if oldfemale==1 & groups!=5
replace LSF_oldfemale=0 if oldfemale==0

label def LSF_oldfemale 1 "LSF Old Female" 0 "Else", modify
label val LSF_oldfemale LSF_oldfemale

* LSF Old Male
gen LSF_oldmale=.
la var LSF_oldmale "LSF Old Men"
replace LSF_oldmale=1 if oldmale==1 & groups==5
replace LSF_oldmale=0 if oldmale==1 & groups!=5
replace LSF_oldmale=0 if oldmale==0

label def LSF_oldmale 1 "LSF Old Male" 0 "Else", modify
label val LSF_oldmale LSF_oldmale

* SCP Young Female
gen SCP_youngfemale=.
la var SCP_youngfemale "SCP Young Women"

replace SCP_youngfemale=1 if youngfemale==1 & groups==4 
replace SCP_youngfemale=0 if youngfemale==1 & groups!=4
replace SCP_youngfemale=0 if youngfemale==0

label def SCP_youngfemale 1 "SCP Young Female" 0 "Else", modify
label val SCP_youngfemale SCP_youngfemale

* SCP Young Male
gen SCP_youngmale=.
la var SCP_youngmale "SCP Young Men"

replace SCP_youngmale=1 if youngmale==1 & groups==4
replace SCP_youngmale=0 if youngmale==1 & groups!=4
replace SCP_youngmale=0 if youngmale==0

label def SCP_youngmale 1 "SCP Young Male" 0 "Else", modify
label val SCP_youngmale SCP_youngmale 

* SCP Old Female
gen SCP_oldfemale=.
label var SCP_oldfemale "SCP Old Women"

replace SCP_oldfemale=1 if oldfemale==1 & groups==4
replace SCP_oldfemale=0 if oldfemale==1 & groups!=4
replace SCP_oldfemale=0 if oldfemale==0

label def SCP_oldfemale 1 "SCP Old Female" 0 "Else", modify
label val SCP_oldfemale SCP_oldfemale

* SCP Old Male
gen SCP_oldmale=.
la var SCP_oldmale "SCP Old Men"
replace SCP_oldmale=1 if oldmale==1 & groups==4
replace SCP_oldmale=0 if oldmale==1 & groups!=4
replace SCP_oldmale=0 if oldmale==0

la de SCP_oldmale 1 "SCP Old Male" 0 "Else", modify
la val SCP_oldmale SCP_oldmale

* BC Young Female
gen BC_youngfemale=.
label var BC_youngfemale "BC Young Women"

replace BC_youngfemale=1 if youngfemale==1 & groups==3 
replace BC_youngfemale=0 if youngfemale==1 & groups!=3
replace BC_youngfemale=0 if youngfemale==0

label def BC_youngfemale 1 "BC Young Female" 0 "Else", modify
label val BC_youngfemale BC_youngfemale

* BC Young Male
gen BC_youngmale=.
label var BC_youngmale "BC Young Men"

replace BC_youngmale=1 if youngmale==1 & groups==3
replace BC_youngmale=0 if youngmale==1 & groups!=3
replace BC_youngmale=0 if youngmale==0

label def BC_youngmale 1 "BC Young Male" 0 "Else", modify
label val BC_youngmale BC_youngmale

* BC Old Female
gen BC_oldfemale=.
label var BC_oldfemale "BC Old Women"

replace BC_oldfemale=1 if oldfemale==1 & groups==3
replace BC_oldfemale=0 if oldfemale==1 & groups!=3
replace BC_oldfemale=0 if oldfemale==0

label def BC_oldfemale 1 "BC Old Female" 0 "Else", modify
label val BC_oldfemale BC_oldfemale

* BC Old Male
gen BC_oldmale=.
label var BC_oldmale "BC Old Men"
replace BC_oldmale=1 if oldmale==1 & groups==3
replace BC_oldmale=0 if oldmale==1 & groups!=3
replace BC_oldmale=0 if oldmale==0

label def BC_oldmale 1 "BC Old Male" 0 "Else", modify
label val BC_oldmale BC_oldmale

* MSF Young Female
gen MSF_youngfemale=.
label var MSF_youngfemale "MSF Young Women"

replace MSF_youngfemale=1 if youngfemale==1 & groups==2
replace MSF_youngfemale=0 if youngfemale==1 & groups!=2
replace MSF_youngfemale=0 if youngfemale==0

label def MSF_youngfemale 1 "MSF Young Female" 0 "Else", modify
label val MSF_youngfemale MSF_youngfemale

* MSF Young Male
gen MSF_youngmale=.
label var MSF_youngmale "MSF Young Men"

replace MSF_youngmale=1 if youngmale==1 & groups==2
replace MSF_youngmale=0 if youngmale==1 & groups!=2
replace MSF_youngmale=0 if youngmale==0

label def MSF_youngmale 1 "MSF Young Male" 0 "Else", modify
label val MSF_youngmale MSF_youngmale

* MSF Old Female
gen MSF_oldfemale=.
label var MSF_oldfemale "MSF Old Women"

replace MSF_oldfemale=1 if oldfemale==1 & groups==2
replace MSF_oldfemale=0 if oldfemale==1 & groups!=2
replace MSF_oldfemale=0 if oldfemale==0

label def MSF_oldfemale 1 "MSF Old Female" 0 "Else", modify
label val MSF_oldfemale MSF_oldfemale

* MSF Old Male
gen MSF_oldmale=.
label var MSF_oldmale "BC Old Men"

replace MSF_oldmale=1 if oldmale==1 & groups==2
replace MSF_oldmale=0 if oldmale==1 & groups!=2
replace MSF_oldmale=0 if oldmale==0

label def MSF_oldmale 1 "MSF Old Male" 0 "Else", modify
label val MSF_oldmale MSF_oldmale

* CA Young Female
gen CA_youngfemale=.
label var CA_youngfemale "CA Young Women"

replace CA_youngfemale=1 if youngfemale==1 & groups==1 
replace CA_youngfemale=0 if youngfemale==1 & groups!=1
replace CA_youngfemale=0 if youngfemale==0

label def CA_youngfemale 1 "CA Young Female" 0 "Else", modify
label val CA_youngfemale CA_youngfemale

* CA Young Male
gen CA_youngmale=.
label var CA_youngmale "CA Young Men"

replace CA_youngmale=1 if youngmale==1 & groups==1 
replace CA_youngmale=0 if youngmale==1 & groups!=1
replace CA_youngmale=0 if youngmale==0

label def CA_youngmale 1 "CA Young Male" 0 "Else", modify
label val CA_youngmale CA_youngmale

* CA Old Female
gen CA_oldfemale=.
la var CA_oldfemale "CA Old Women"

replace CA_oldfemale=1 if oldfemale==1 & groups==1
replace CA_oldfemale=0 if oldfemale==1 & groups!=1
replace CA_oldfemale=0 if oldfemale==0

la de CA_oldfemale 1 "CA Old Female" 0 "Else", modify
la val CA_oldfemale CA_oldfemale

* CA Old Male
gen CA_oldmale=.
label var CA_oldmale "CA Old Men"

replace CA_oldmale=1 if oldmale==1 & groups==1
replace CA_oldmale=0 if oldmale==1 & groups!=1
replace CA_oldmale=0 if oldmale==0

label def CA_oldmale 1 "CA Old Male" 0 "Else", modify
label val CA_oldmale CA_oldmale

* Variable that contains all exl.groups 
gen exlgroups=.
label var exlgroups "socio-economic groups (excl)"

replace exlgroups =1 if LSF_youngfemale ==1
replace exlgroups =2 if LSF_youngmale ==1
replace exlgroups =3 if LSF_oldfemale ==1
replace exlgroups =4 if LSF_oldmale ==1
replace exlgroups =5 if SCP_youngfemale ==1
replace exlgroups =6 if SCP_youngmale ==1
replace exlgroups =7 if SCP_oldfemale ==1
replace exlgroups =8 if SCP_oldmale ==1
replace exlgroups =9 if BC_youngfemale ==1
replace exlgroups =10 if BC_youngmale ==1
replace exlgroups =11 if BC_oldfemale ==1
replace exlgroups =12 if BC_oldmale ==1
replace exlgroups =13 if MSF_youngfemale ==1
replace exlgroups =14 if MSF_youngmale ==1
replace exlgroups =15 if MSF_oldfemale ==1
replace exlgroups =16 if MSF_oldmale ==1
replace exlgroups =17 if CA_youngfemale==1
replace exlgroups =18 if CA_youngmale==1
replace exlgroups =19 if CA_oldfemale==1
replace exlgroups =20 if CA_oldmale==1

#delimit ;
label def exlgroups
1 "LSF Young Female"
2 "LSF Young Male"
3 "LSF Old Female"
4 "LSF Old Male"

5 "SCP Young Female"
6 "SCP Young Male"
7 "SCP Old Female"
8 "SCP Old Male"

9 "BC Young Female"
10 "BC Young Male"
11 "BC Old Female"
12 "BC Old Male"

13 "MSF Young Female"
14 "MSF Young Male"
15 "MSF Old Female"
16 "MSF Old Male"

17 "CA Young Female"
18 "CA Young Male"
19 "CA Old Female"
20 "CA Old Male", modify;
label val exlgroups exlgroups;
#delimit cr



********************************************************************************
* 5 Attach LMV Values
********************************************************************************
* Import Excel Table in order to merge

save "ESS_temp", replace
local years 2016 2014 2018 

foreach y of local years {
	import delimited using "lmv_values_`y'.csv", clear ///
		   colrange(2:19) rowrange(4:23) varnames(2) delimiters(",")

	foreach x of varlist _all {
			rename `x' lmv_`x'_`y'
			}
		
	gen exlgroups=int(_n) // generate variable that contains the exlgroup number
	save "LMV_TEMP_`y'", replace
}

use "ESS_temp", clear


foreach y of local years {
drop _merge

	merge m:1 exlgroups using "LMV_TEMP_`y'", keepusing(lmv_*)


	* Obtain one lmv variable
	capture noisily	replace lmv_at_`y'=. if cntry!="AT"
	capture noisily	replace lmv_be_`y'=. if cntry!="BE"
	capture noisily	replace lmv_ch_`y'=. if cntry!="CH"
	capture noisily	replace lmv_de_`y'=. if cntry!="DE"
	capture noisily	replace lmv_dk_`y'=. if cntry!="DK"
	capture noisily	replace lmv_es_`y'=. if cntry!="ES"
	capture noisily	replace lmv_fi_`y'=. if cntry!="FI"
	capture noisily	replace lmv_fr_`y'=. if cntry!="FR"
	capture noisily	replace lmv_gr_`y'=. if cntry!="GR"
	capture noisily	replace lmv_ie_`y'=. if cntry!="IE"
	capture noisily	replace lmv_is_`y'=. if cntry!="IS"
	capture noisily	replace lmv_it_`y'=. if cntry!="IT"
	capture noisily	replace lmv_nl_`y'=. if cntry!="NL"
	capture noisily	replace lmv_no_`y'=. if cntry!="NO"
	capture noisily	replace lmv_pt_`y'=. if cntry!="PT"
	capture noisily	replace lmv_se_`y'=. if cntry!="SE"
	capture noisily	replace lmv_uk_`y'=. if cntry!="GB"
		
	gen lmv`y' =.
	capture noisily	replace lmv`y' = lmv_at_`y' if cntry=="AT"
	capture noisily	replace lmv`y' = lmv_be_`y' if cntry=="BE"
	capture noisily	replace lmv`y' = lmv_ch_`y' if cntry=="CH"
	capture noisily	replace lmv`y' = lmv_de_`y' if cntry=="DE"
	capture noisily	replace lmv`y' = lmv_dk_`y' if cntry=="DK"
	capture noisily	replace lmv`y' = lmv_es_`y' if cntry=="ES"
	capture noisily	replace lmv`y' = lmv_fi_`y' if cntry=="FI"
	capture noisily replace lmv`y' = lmv_fr_`y' if cntry=="FR"
	capture noisily	replace lmv`y' = lmv_gr_`y' if cntry=="GR"
	capture noisily	replace lmv`y' = lmv_ie_`y' if cntry=="IE"
	capture noisily	replace lmv`y' = lmv_is_`y' if cntry=="IS"
	capture noisily	replace lmv`y' = lmv_it_`y' if cntry=="IT"
	capture noisily	replace lmv`y' = lmv_nl_`y' if cntry=="NL"
	capture noisily	replace lmv`y' = lmv_no_`y' if cntry=="NO"
	capture noisily	replace lmv`y' = lmv_pt_`y' if cntry=="PT"
	capture noisily	replace lmv`y' = lmv_se_`y' if cntry=="SE"
	capture noisily	replace lmv`y' = lmv_uk_`y' if cntry=="GB"

	label var lmv`y' "Labor Market Risk Value in the year `y'"
	
}
drop lmv_*


*  Outsiderness combine years

gen lmv2014b = lmv2014 if essround == 7
gen lmv2016b = lmv2016 if essround == 8
gen lmv2018b = lmv2018 if essround == 9

gen lmv_combined = .
replace lmv_combined = lmv2014b if !missing(lmv2014b)
replace lmv_combined = lmv2016b if missing(lmv_combined) & !missing(lmv2016b)
replace lmv_combined = lmv2018b if missing(lmv_combined) & !missing(lmv2018b)
rename lmv_combined lmv
 fre lmv

********************************************************************************
log close
