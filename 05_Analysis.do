
*---------------------- Analysis: Insider versus Outsider ----------------------*


*--------------------------------------------*
* Conventional Political Participation: Vote *
*--------------------------------------------*

* LABOR MARKET RISK
logit vote c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround ///
    [pweight=newweight2], vce(cluster cntry_num)
	
* Full-Model as reference for sample size
logit vote c.lmv_re i.essround if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans1_lmv

* + Controls
logit vote c.lmv_re c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround  if e(sample) ///
    [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans2_lmv

* + Income
logit vote c.lmv_re i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround if e(sample) ///
    [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans3_lmv

* + Class
logit vote c.lmv_re i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround if e(sample) ///
    [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans4_lmv

* + Education
logit vote c.lmv_re i.skill i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround if e(sample) ///
    [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans5_lmv


* + Contract Type 
logit vote c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround if e(sample) ///
    [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans6_lmv


coefplot (vdtrans1_lmv, label("Baseline") msymbol(O) color(navy)) ///
         (vdtrans2_lmv, label("Controls") msymbol(D) color(maroon)) ///
         (vdtrans3_lmv, label("Income") msymbol(S) color(teal)) ///
		 (vdtrans4_lmv, label("Class") msymbol(X) color(forest_green)) ///
         (vdtrans5_lmv, label("Education") msymbol(T) color(purple)), ///
     keep(lmv_re) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permnant Contract)" "Temporary Contract" "' lmv_re = "Labor Market Risk") ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Effect of Labor Market Dualization on Conventional Participation", size(*0.9) margin(b=1)) ///
     subtitle("Average Marginal Effects of Labor Market Risk on Voting Participation", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1) xsize(1.5)  ///
     name(inf_pp_dua, replace)

cd "/Users/nastianedjai/Desktop/Plots Final/Insider-Outsider/"
graph export inf_vote_dua1.jpg, replace



*--------------------------------------------*
* Marginal Effects: LMV before + SES Control *
*--------------------------------------------*

* Full-Model as reference for sample size
logit vote c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    [pweight=newweight2], cluster(cntry_num) vce(cluster cntry_num)
	
*  with Control Variable 
logit vote c.lmv_re i.labcon2 c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround if e(sample)  ///
    [pweight=newweight2], cluster(cntry_num) vce(cluster cntry_num)
margins, at(lmv_re=(-3(0.5)3)) saving(margins_com, replace)

*  with Income Variable 
logit vote c.lmv_re i.labcon2 i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround if e(sample) ///
    [pweight=newweight], cluster(cntry_num) vce(cluster cntry_num)
margins, at(lmv_re=(-3(0.5)3)) saving(margins_im, replace)

*  with Class Variable 
logit vote c.lmv_re i.labcon2 i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround if e(sample) ///
    [pweight=newweight2], cluster(cntry_num) vce(cluster cntry_num)
margins, at(lmv_re=(-3(0.5)3)) saving(margins_cm, replace)

*  with Education Variable
logit vote c.lmv_re i.labcon2  i.inc3med i.skill i.class5 c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround if e(sample) ///
    [pweight=newweight], cluster(cntry_num) vce(cluster cntry_num)
margins, at(lmv_re=(-3(0.5)3)) saving(margins_em, replace)


combomarginsplot margins_com  margins_im margins_cm margins_em, labels("Baseline Model with Controls" "Adjusted for Income" "Adjusted for Class" "Adjusted for Education") ciopt(color(%10))plotopts(lwidth(medthin) lcolor(lavender))  scheme(plotplain) title("Mediating Role of Socioeconomic Status in Unconventional Participation", size(*0.8) margin(b=1)) subtitle("Average Marginal Effects for Conventional Particitpation by Labor Market Risk", size(*0.7) color(gs6)  margin(b=4)) xtitle("Labor Market Risk", size(*0.7) margin(medsmall)) ytitle("Average Marginal Effect to Vote", size(*0.7) margin(medsmall)) legend(position(6) ring(1) col(2) size(*0.8)) xsize(4) ysize(6) name(combinedmargin, replace) 

cd "/Users/nastianedjai/Desktop/Plots Final/Insider-Outsider/"
graph export mediation_lmv_plot.jpg, replace



*-----------------------------------------------*
*						 KHB					*
*-----------------------------------------------*

* Full Model for sample restriction
logit vote c.lmv_re i.labcon2 i.class5 i.skill i.inc3med  c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround [pweight=newweight2], vce(cluster cntry_num)

* Income as Mediator
khb logit vote  c.lmv_re || i.inc3med if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(c.rlgdgr i.gender i.ethnie2 ///
                c.agea c.unemp_nat c.gdp i.cntry_num i.essround)

* Education (Skill) as Mediator
khb logit vote c.lmv_re || i.skill if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(i.inc3med c.rlgdgr i.gender i.ethnie2 ///
                c.agea c.unemp_nat c.gdp i.cntry_num i.essround)

* Class as Mediator
khb logit vote c.lmv_re || i.class5 if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
                c.agea c.unemp_nat c.gdp i.cntry_num i.essround)
				

* ====== PLOT: INDIRECT EFFECTS  ======*


capture frame drop khb_lmv1
frame create khb_lmv1
frame change khb_lmv1


input str20 mediation diff se
"Income"    -0.0676805   0.0120352
"Education" -0.1522401   0.0141515
"Class"     -0.1343288   0.0522721
end

gen id    = _n
gen upper = diff + 1.96*se
gen lower = diff - 1.96*se

* p-Wert & Significance
gen pval = 2*normal(-abs(diff/se))
gen sig  = ""
replace sig="***" if pval<0.01
replace sig="**"  if pval>=0.01 & pval<0.05
replace sig="*"   if pval>=0.05 & pval<0.10
replace sig="n.s." if sig==""


summ upper lower, meanonly
local pad = 0.03*(`r(max)'-`r(min)')
gen ylab = upper + `pad'

twoway ///
 (bar diff id, barwidth(0.8) color(black%50) lcolor(black) lwidth(vthin)) ///
 (rcap upper lower id, lwidth(vthin) lcolor(gs6)) ///
 (scatter ylab id, msymbol(i) mlabel(sig) mlabpos(12) mlabsize(small) mlabgap(1)), ///
 xlabel(1 `"Income"' 2 `"Education"' 3 `"Class"', labsize(small)) ///
 yline(0, lpattern(dash) lcolor(gs8)) ///
 ytitle("Indirect effect on vote (logit)", size(small)) ///
 title("KHB Decomposition of Labour Market Risk Effects on Conventional Participation", size(*0.9) margin(b=1)) ///
 subtitle("Mediators: Income, Education, Class; Controls held constant", size(*0.75) color(gs6)) ///
 legend(off) ///
 graphregion(color(white)) ///
 scheme(plotplain) ///
 name(khb_lmv_plot, replace)

graph export "khb_lmv_plot.pdf", replace

	

** TEMPORARY EMPLOYMENT

* Full-Model Reference to ensure same sample size for LMR Model
logit vote i.labcon2 c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround [pweight=newweight2], vce(cluster cntry_num)

* Baseline 
logit vote i.labcon2 i.cntry_num i.essround if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans1_lab

* + Controls 
logit vote i.labcon2 c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans2_lab

* + Income
logit vote i.labcon2 i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans3_lab

* + Class
logit vote i.labcon2 i.class5  i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans4_lab

* + Education 
logit vote i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans5_lab

* + Labor Market Risk (als zusätzlicher Prädiktor)
logit vote i.labcon2 c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround ///
    if e(sample) [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*) post
est store vdtrans6_lab


* Coefplot der AMEs für Vertragsstatus (1.labcon2 = befristet vs. unbefristet)
coefplot (vdtrans1_lab, label("Baseline") msymbol(O) color(navy)) ///
         (vdtrans2_lab, label("Controls") msymbol(D) color(maroon)) ///
         (vdtrans3_lab, label("Income") msymbol(S) color(teal)) ///
         (vdtrans4_lab, label("Class") msymbol(T) color(forest_green)) ///
         (vdtrans5_lab, label("Education") msymbol(X) color(purple)), ///
     keep(1.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permanent)" "Temporary Contract" "') ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Effect of Contract Type on Conventional Participation", size(*0.9) margin(b=1)) ///
     subtitle("Average Marginal Effects of Temporary vs. Permanent Contract on Voting", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1) xsize(1.5)  ///
     name(inf_vote_contract, replace)

cd "/Users/nastianedjai/Desktop/Plots Final/Insider-Outsider/"
graph export inf_vote_contract.svg, replace


* Robustness Check
coefplot (vdtrans1_lab, label("Baseline") msymbol(O) color(navy)) ///
         (vdtrans2_lab, label("Controls") msymbol(D) color(maroon)) ///
         (vdtrans3_lab, label("Income") msymbol(S) color(teal)) ///
         (vdtrans4_lab, label("Education") msymbol(T) color(purple)) ///
         (vdtrans5_lab, label("Class") msymbol(X) color(forest_green)) ///
         (vdtrans6_lab, label("+ LMR") msymbol(Oh) color(forest_green)), ///
     keep(1.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permanent)" "Temporary Contract" "') ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Effect of Contract Type on Conventional Participation", size(*0.9) margin(b=1)) ///
     subtitle("Average Marginal Effects of Temporary vs. Permanent Contract on Voting", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1) xsize(1.5)  ///
     name(inf_pp_contract, replace)



*-----------------------------------------------*
*						 KHB					*
*-----------------------------------------------*


* Volles Modell 
logit vote i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age  ///
    c.agea c.unemp_nat c.gdp i.cntry_num i.essround [pweight=newweight2], vce(cluster cntry_num)
	
	
khb logit vote i.labcon2 || i.class5_r if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround) ///
    summary
	
* Income 
khb logit vote i.labcon2 || i.inc3med if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.cntry_num i.essround) ///
	summary

* Education 
khb logit vote i.labcon2 || i.skill if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround) ///
	summary

* Class 
khb logit vote i.labcon2 || i.class5 if e(sample) [pweight=newweight2], ///
    cluster(cntry_num) vce(cluster cntry_num) ///
    concomitant(i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.cntry_num i.essround) ///
	summary


* ====== PLOT: INDIRECT EFFECTS  ======*

capture frame drop khb_lab1
frame create khb_lab1
frame change khb_lab1

* Income:    Diff = -0.1298707, SE = 0.0182292
* Education: Diff = -0.0999800, SE = 0.0112068
* Class:     Diff = -0.0216731, SE = 0.0190744
input str20 mediation diff se
"Income"    -0.1298707   0.0182292
"Education" -0.0999800   0.0112068
"Class"     -0.0216731   0.0190744
end

gen id    = _n
gen upper = diff + 1.96*se
gen lower = diff - 1.96*se

* p-Wert & Signifikanzsterne
gen pval = 2*normal(-abs(diff/se))
gen sig  = ""
replace sig="***" if pval<0.01
replace sig="**"  if pval>=0.01 & pval<0.05
replace sig="*"   if pval>=0.05 & pval<0.10
replace sig="n.s." if sig==""

summ upper lower, meanonly
local pad = 0.03*(`r(max)'-`r(min)')
gen ylab = upper + `pad'

twoway ///
 (bar diff id, barwidth(0.8) color(black%50) lcolor(black) lwidth(vthin)) ///
 (rcap upper lower id, lwidth(vthin) lcolor(gs6)) ///
 (scatter ylab id, msymbol(i) mlabel(sig) mlabpos(12) mlabsize(small) mlabgap(1)), ///
 xlabel(1 `"Income"' 2 `"Education"' 3 `"Class"', labsize(small)) ///
 yline(0, lpattern(dash) lcolor(gs8)) ///
 ytitle("Indirect effect on vote (logit)", size(small)) ///
 title("KHB Decomposition of Contract Type Effects on Conventional Participation", size(*0.9) margin(b=1)) ///
 subtitle("Mediators: Income, Education, Class; Controls held constant", size(*0.75) color(gs6)) ///
 legend(off) ///
 graphregion(color(white)) ///
 scheme(plotplain) ///
 name(khb_lab_plot, replace)

graph export "khb_lab_plot.pdf", replace
graph export "khb_lab_plot.png", width(2000) replace




*------------------------------------------------------------------------------*

*----------------------------------------*
* Unconventional Political Participation *
*----------------------------------------*


* LABOR MARKET RISK
xtset cntry_num

xtreg politics c.lmv_re  i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround , fe vce(cluster cntry_num)  // Full
est store pdtrans6_dua

xtreg politics c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num)  // Education
ereturn list
est store pdtrans5_dua

xtreg politics c.lmv_re i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num) // Class
est store pdtrans4_dua

xtreg politics  c.lmv_re i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num) // Income
est store pdtrans3_dua

xtreg politics c.lmv_re c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround if e(sample) , fe vce(cluster cntry_num) 
est store pdtrans2_dua

xtreg politics  c.lmv_re i.essround if e(sample) , fe vce(cluster cntry_num) 
est store pdtrans1_dua


coefplot (pdtrans1_dua, label("Baseline Model") msymbol(O) color(navy))  ///
         (pdtrans2_dua, label("Adjusted for Control Variables") msymbol(D) color(maroon)) ///
         (pdtrans3_dua, label("Adjusted for Income") msymbol(S) color(teal)) ///
         (pdtrans4_dua, label("Adjusted for Class") msymbol(T) color(forest_green)) ///
         (pdtrans5_dua, label("Adjusted for Education") msymbol(X) color(purple)), ///
     keep(lmv_re *.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permnant Contract)" "Temporary Contract" "' lmv_re = "Labor Market Risk") ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Fixed-Effects of Labor Market Dualization on Unconventional Political Participation", size(*0.9) margin(b=1)) ///
     subtitle("Average Marginal Effects of Labor Market Risk on Civic Engagement", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1.2) xsize(1.7)  ///
     name(inf_pp_dua, replace)
	 
* Robustness Check  
coefplot (pdtrans1_dua, label("Baseline Model") msymbol(O) color(navy))  ///
         (pdtrans2_dua, label("Adjusted for Control Variables") msymbol(D) color(maroon)) ///
         (pdtrans3_dua, label("Adjusted for Income") msymbol(S) color(teal)) ///
         (pdtrans4_dua, label("Adjusted for Class") msymbol(T) color(purple)) ///
         (pdtrans5_dua, label("Adjusted for Education") msymbol(X) color(forest_green)) ///
         (pdtrans6_dua, label("Adjusted for Status-Based Outsider") msymbol(Oh) color(forest_green) keep(lmv_re)), ///
     keep(lmv_re *.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permnant Contract)" "Temporary Contract" "' lmv_re = "Labor Market Risk") ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Fixed-Effects of Labor Market Dualization on Unconventional Political Participation", size(*0.9) margin(b=1)) ///
     subtitle("Average Marginal Effects of Labor Market Risk on Civic Engagement", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1.2) xsize(1.7)  ///
     name(inf_pp_dua, replace)
	 


*--------------------------------------------*
* Marginal Effects: LMV before + SES Control *
*--------------------------------------------*

* Full-Model as reference for sample size
xtreg politics c.lmv_re  i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround , fe  vce(cluster cntry_num) 
	
* Model with Control Variable 
xtreg politics c.lmv_re c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround, fe  vce(cluster cntry_num) 
margins, at(lmv_re=(-3(0.5)3)) saving(margins_com, replace)

* Model with Income Variable 
xtreg politics c.lmv_re  i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround , fe  vce(cluster cntry_num) 
margins, at(lmv_re=(-3(0.5)3)) saving(margins_im, replace)

* Model with Class Variable 
xtreg politics c.lmv_re  i.labcon2 i.class5  i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround , fe  vce(cluster cntry_num) 
margins, at(lmv_re=(-3(0.5)3)) saving(margins_cm, replace)


* Model with Education Variable
xtreg politics c.lmv_re i.skill i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.unemp_nat c.gdp i.essround , fe vce(cluster cntry_num) 
margins, at(lmv_re=(-3(0.5)3)) saving(margins_em, replace)


combomarginsplot margins_com  margins_im margins_cm margins_em, labels("Baseline Model with Controls" "Adjusted for Income" "Adjusted for Class" "Adjusted for Education") ciopt(color(%10))plotopts(lwidth(medthin) lcolor(lavender))  scheme(plotplain) title("Mediating Role of Socioeconomic Status in Unconventional Participation", size(*0.8) margin(b=1)) subtitle("Average Marginal Effects for Unconventional Particitpation by Labor Market Risk", size(*0.7) color(gs6)  margin(b=4)) xtitle("Labor Market Risk", size(*0.7) margin(medsmall)) ytitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall)) legend(position(6) ring(1) col(2) size(*0.8)) xsize(4) ysize(6) name(combinedmargin_uncon, replace) 


* STATUS-BASED 

* No notable differences in time
xtset cntry_num

xtreg politics c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround , fe vce(cluster cntry_num) // Labor Market Risk
est store pdtrans6_dua1

xtreg politics i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age  c.agea c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num) // Education
est store pdtrans5_dua1

xtreg politics i.labcon2 i.class5 i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num) // Class
ereturn list
est store pdtrans4_dua1

xtreg politics  i.labcon2 i.inc3med c.rlgdgr i.gender i.ethnie2 c.agea c.age c.unemp_nat c.gdp i.essround if e(sample), fe vce(cluster cntry_num) // Income
est store pdtrans3_dua1

xtreg politics i.labcon2 c.rlgdgr i.gender i.ethnie2 c.age  c.agea c.unemp_nat c.gdp i.essround if e(sample) , fe  vce(cluster cntry_num)
est store pdtrans2_dua1

xtreg politics i.labcon2 i.essround if e(sample) , fe vce(cluster cntry_num)
est store pdtrans1_dua1

// Check of Correlation for Suppression Effect 
corr skill labcon2 if e(sample)
corr class5 labcon2 if e(sample)
corr inc3med labcon2 if e(sample)
corr politics01 skill if e(sample)
corr politics01 class5 if e(sample)
corr politics01 inc3med if e(sample)


* Result Status-Based Outsider
coefplot (pdtrans1_dua1, label("Baseline Model") msymbol(O) color(navy))  ///
         (pdtrans2_dua1, label("Adjusted for Control Variables") msymbol(D) color(maroon)) ///
         (pdtrans3_dua1, label("Adjusted for Income") msymbol(S) color(teal)) ///
         (pdtrans4_dua1, label("Adjusted for Class") msymbol(T) color(forest_green)) ///
         (pdtrans5_dua1, label("Adjusted for Education") msymbol(X) color(purple)), ///
     keep(*.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permnant Contract)" "Temporary Contract" "' lmv_re = "Labor Market Risk") ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Fixed-Effects of Labor Market Dualization on Unconventional Political Participation", size(*0.9) margin(b=1)) ///
     subtitle("Temporary vs. Permanent Contract on Civic Engagement", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1) xsize(1.5)  ///
     name(inf_pp_contract, replace)

* Robustness
coefplot (pdtrans1_dua1, label("Baseline Model") msymbol(O) color(navy))  ///
         (pdtrans2_dua1, label("Adjusted for Control Variables") msymbol(D) color(maroon)) ///
         (pdtrans3_dua1, label("Adjusted for Income") msymbol(S) color(teal)) ///
         (pdtrans4_dua1, label("Adjusted for Education") msymbol(T) color(purple)) ///
         (pdtrans5_dua1, label("Adjusted for Class") msymbol(X) color(cranberry)) ///
         (pdtrans6_dua1, label("Adjusted for Labor Market Risk") msymbol(Oh) color(forest_green)), ///
     keep(*.labcon2) ///
     coeflabels(1.labcon2 = `" "(Ref.: Permnant Contract)" "Temporary Contract" "' lmv_re = "Labor Market Risk") ///
     ciopts(recast(rcap) color(gs10)) ///
     xline(0, lpattern(shortdash) lcolor(red)) ///
     ylabel(, labsize(*0.9)) ///
     legend(pos(6) ring(1) row(2) size(*0.7))  ///
     title("Fixed-Effects of Labor Market Dualization on Unconventional Political Participation", size(*0.9) margin(b=1)) ///
     subtitle("Adjusted for Labor Market Risk", size(*0.8) margin(b=3) color(gs6)) ///
     scheme(plotplain) ///
     horizontal ///
	 mlabel format(%9.2g) mlabposition(12) mlabgap(*1.5) mlabsize(*0.7) ///
     xtitle("Average Marginal Effect to Engage", size(*0.7) margin(medsmall) color(gs6)) ///
     ysize(1) xsize(1.5)  ///
     name(inf_pp_dua, replace)

	 

