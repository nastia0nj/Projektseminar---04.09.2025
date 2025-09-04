**************************************************
* ESS7-9 | Preparing the variables 
**************************************************

*-----------------------------------------------------------------*
* Sample Restriction: Countries & Age Range 
*-----------------------------------------------------------------*
keep if cntry == "AT" |  cntry == "CH"  | cntry == "ES" | cntry == "FI" | cntry == "FR" | cntry == "GB" | cntry == "IE" | cntry == "NL" | cntry == "NO" | cntry == "PT" | cntry == "SE"    & agea >= 16 & agea <= 65  

*-----------------------------------------------*
* Country Numeric Codes
*-----------------------------------------------*

gen cntry_num = .
replace cntry_num = 1  if cntry == "AT"
replace cntry_num = 2  if cntry == "CH"
replace cntry_num = 3  if cntry == "ES"
replace cntry_num = 4  if cntry == "FI"
replace cntry_num = 5  if cntry == "FR"
replace cntry_num = 6  if cntry == "GB"
replace cntry_num = 7  if cntry == "IE"
replace cntry_num = 8  if cntry == "NL"
replace cntry_num = 9  if cntry == "NO"
replace cntry_num = 10 if cntry == "PT"
replace cntry_num = 11 if cntry == "SE"

label define cntry_lbl 1 "AT" 2 "CH" 3 "ES" 4 "FI" 5 "FR" 6 "GB" 7 "IE" ///
                      8 "NL" 9 "NO" 10 "PT" 11 "SE"
label values cntry_num cntry_lbl
label variable cntry_num "Country (numeric)"
clonevar country = cntry_num

*-----------------------------------------------*
* Weights
*-----------------------------------------------*
gen newweight  = dweight * pspwght
gen newweight2 = pspwght * pweight

*-----------------------------------------------*
* Conventional Political Participation: Vote
*-----------------------------------------------*

recode vote (3 = .) (2 = 0)

*-----------------------------------------------*
* Unconventional Political Participation: Civic Engagement
*-----------------------------------------------*
clonevar u_wrkorg  = wrkorg
clonevar u_bctprd  = bctprd
clonevar u_pbldmn  = pbldmn
clonevar u_vote    = vote
recode u_vote (0 = 2) 

* PCA with weights
pca u_* [aweight=anweight]
scree 

* Factor analysis for Conventional Participation
factor u_* [aweight=anweight], ipf factors(1) // Clearly vote is not loading on the factor of Unconventional Political
rotate, varimax
predict uncon_polpart
sum uncon_polpart

egen umin_politics = min(uncon_polpart)
egen umax_politics = max(uncon_polpart)
gen politics100 = 100 * (uncon_polpart - umin_politics) / (umax_politics - umin_politics)
gen politics = 100 - politics100
label variable politics "Unconventional Political Participation"
sum politics

cap drop politics01
gen politics01 = (100 - politics100)*0.01
label variable politics01 "Political Participation Index"


*-----------------------------------------------*
* Employment Status & Contract Type
*-----------------------------------------------*
cap drop unemp
clonevar unemp = mnactic
recode unemp (1 = 1) (3 4 7 8 = 2) (5 6 2 9 = 3)
cap lab def unemp
label define unemp 1 "Paid Work" 2 "Unemployed" 3 "Inactive"
label values unemp unemp

cap drop labcon2
clonevar labcon2 = wrkctra
recode labcon2 (2 3 = 1) (1 = 0)
label define labcon2 1 "Temporary Contract" 0 "Unlimited"
label values labcon2 labcon2
label variable labcon2 "Contract"

cap drop wrkhrs
gen wrkhrs = .
replace wrkhrs = 1 if wkhct > 30 & wkhct < .
replace wrkhrs = 2 if wkhct <= 30 & wkhct < .
label define wrkhrs 1 "Full-time" 2 "Part-time"
label values wrkhrs wrkhrs

gen wrkhrs3 = .
replace wrkhrs3 = 1 if wkhct > 30
replace wrkhrs3 = 2 if wkhct <= 30 & wkhct >= 15 & wkhct != 555
replace wrkhrs3 = 3 if wkhct < 15 & wkhct != .
label define wrkhrs3 1 "Full-time" 2 "Part-time" 3 "Mini/No Contract"
label values wrkhrs3 wrkhrs3

* Risk Profile
sum lmv, d

// Lineare Transformation auf Skala [-3, 3]
sum lmv
scalar min_lmv = r(min)
scalar max_lmv = r(max)

gen lmv_re = ((lmv - min_lmv) / (max_lmv - min_lmv)) * 6 - 3
fre lmv_re


*-----------------------------------------------*
* Demographic Controls
*-----------------------------------------------*

*-----------------------------------------------*
* Age
*-----------------------------------------------*
gen age2 = agea^2

label variable agea "Age"

*-----------------------------------------------*
* Ethnie
*-----------------------------------------------*

gen ethnie = .
replace ethnie = 1 if brncntr == 1 & mocntr == 1 & facntr == 1
replace ethnie = 2 if brncntr == 1 & (mocntr == 2 | facntr == 2)
replace ethnie = 3 if brncntr == 2
label define ethnie_lbl 1 "Majority" 2 "Second Generation" 3 "Minority"
label variable ethnie "Ethnic Minority"
label values ethnie ethnie_lbl

recode ethnie (2 3 = 2), gen(ethnie2)
label define ethnie_lbl2 1 "Majority" 2 "Minority"
label variable ethnie2 "Ethnic Minority"
label values ethnie2 ethnie_lbl2

*-----------------------------------------------*
* Income
*-----------------------------------------------*

cap drop inc3med
gen inc3med = .
replace inc3med = 1 if hinctnta < 6    //  1–5 = Below Median
replace inc3med = 2 if hinctnta > 5    //  6–10 = Above Median

label define inc3med1 1 "Below Median" 2 "Above Median"
label values inc3med inc3med1

*-----------------------------------------------*
* Skill & Education
*-----------------------------------------------*
cap drop cat_skill
fre eisced
clonevar cat_skill = eisced
recode cat_skill (1 2 = 1) (3 4 = 2) (5 6 7 = 3) (55 = .)
clonevar num_skill = eduyrs

cap drop
clonevar cat_skill2 = eisced
recode cat_skill2 (1 2 3 4 = 1) (5 6 7 = 2) (55 = .)
label define cat_skill2 1 "Low"  2 "High"

fre eisced

label define cat_skill 1 "Low" 2 "Intermediate" 3 "High"
label values cat_skill cat_skill
label variable num_skill "Education Years"


*-----------------------------------------------*
* Marital Status
*-----------------------------------------------*

* Distribution overview
fre evmar   // Are you or have you ever been married?

* Value labels for marital status (binary: ever married)
label define evmar_lbl ///
    1 "Currently or Previously Married" ///
    2 "Never Married"

label values evmar evmar_lbl
label variable evmar "Material Status"

*-----------------------------------------------*
* Religiousity
*-----------------------------------------------*

label define rlgdgr_lbl ///
    0  "Not at all religious" ///
    1  "1 – Slightly religious" ///
    2  "2" ///
    3  "3" ///
    4  "4" ///
    5  "5 – Moderately religious" ///
    6  "6" ///
    7  "7" ///
    8  "8" ///
    9  "9" ///
    10 "Very religious"

label values rlgdgr rlgdgr_lbl
label variable rlgdgr "Self-rated religiosity (0–10 scale)"

*-----------------------------------------------*
* Trade Union Membership
*-----------------------------------------------*

* Ausgangsvariable: mbtru

* Klonen der Originalvariablen
clonevar union  = mbtru      
clonevar union2 = mbtru     

* Rekodierung: 1 & 2 = 1 ("Yes or Former"), 3 = 2 ("No")
recode union2 (1 2 = 1) (3 = 2)

* Label definieren und zuweisen
label define union2_lbl 1 "Yes or Former" 2 "No"
label values union2 union2_lbl
label variable union2 "Trade union membership (Yes/Former vs. No)"











