*------------------------------------------------------------------------------*
* Robustness Check                                                             *
*------------------------------------------------------------------------------*

*-----------------------------*
* Union Membership            *
*-----------------------------*

* Conventional Participation
logit vote c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround [pweight=newweight2], vce(cluster cntry_num)
margins, dydx(*)
est store union_without1

logit vote c.lmv_re i.labcon2 i.union2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround [pweight=newweight2] if e(sample), vce(cluster cntry_num)
margins, dydx(*)
est store union_with1

esttab union_without1 union_with1 using union_part.tex, ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    compress label alignment(D{.}{.}{-1}) ///
    title(Average Marginal Effects on Voting Participation) ///
    mtitles("With" "Without") ///
    keep(lmv_re *.labcon2 ) ///
    order(lmv_re *.labcon2 ) ///
    coeflabels( ///
        lmv_re    "Labor Market Risk" ///
        0b.labcon2 "Unlimited Contract" ///
        1b.union2 "Union Membership (or Previously)" ///
        0b.labcon2 "No Union Membership" ///
    ) ///
    b(3) se(3) ///
    stats(r2 N, fmt(3 0) labels("Pseudo R²" "Observations")) ///
    noobs replace


* Unconventional Participation
xtreg politics c.lmv_re i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, fe vce(cluster cntry_num) 
est store union_without2

esttab union_without2 union_with2 using union_part.tex, ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    compress label alignment(D{.}{.}{-1}) ///
    title(Average Marginal Effects on Voting Participation) ///
    mtitles("With" "Without") ///
    keep(lmv_re *.labcon2 ) ///
    order(lmv_re *.labcon2 ) ///
    coeflabels( ///
        lmv_re    "Labor Market Risk" ///
        0b.labcon2 "Contract Type (Ref. Permanent Contract)" ///
        0b.labcon2 "Unlimited Contract (Ref. Permanent Contract)" ///
        1b.union2 "Union Membership (Ref. Yes or Previously)" ///
        0b.labcon2 "No Union Membership" ///
    ) ///
    b(3) se(3) ///
    stats(r2 N, fmt(3 0) labels("Pseudo R²" "Observations")) ///
    noobs replace


*-----------------------------*
* Income                      *
*-----------------------------*

* Unconventional Participation
xtreg hinctnta c.lmv_re i.labcon2 i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround, fe vce(cluster cntry_num)
est store income
mat list e(b)

esttab income using income.tex, ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    compress label alignment(D{.}{.}{-1}) ///
    title(Average Marginal Effects on Voting Participation) ///
    mtitles("With" "Without") ///
    keep(lmv_re *.labcon2) ///
    order(lmv_re *.labcon2 ) ///
    coeflabels( ///
        lmv_re    "Labor Market Risk" ///
        0b.labcon2 "Contract Type (Ref. Permanent Contract)" ///
        1.labcon2  "Unlimited Contract" ///
    ) ///
    b(3) se(3) ///
    stats(r2 N, fmt(3 0) labels("Pseudo R²" "Observations"))


*-----------------------------*
* Diagnosis                   *
*-----------------------------*

* Conventional Participation

* Hosmer–Lemeshow goodness-of-fit test
logit vote i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, vce(cluster cntry_num)
estat gof, group(10) table
lroc

predict phat1, pr        // Predicted Probability
predict pearson1, resid  // Pearson Residuals
predict dev1, deviance   // Deviance Residuals
predict hat1, hat        // Leverage (Pregibon)

scatter pearson1 phat1
scatter dev1 phat1
scatter hat1 phat1

logit vote c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround 
estat gof, group(10) table
lroc

predict phat2, pr        
predict pearson2, resid  
predict dev2, deviance   
predict hat2, hat        

scatter pearson2 phat2
scatter dev2 phat2
scatter hat2 phat2

ldfbeta varname
predict dbeta, dbeta

* Textauswertung:
* - Beide goodness-of-fit Tests zeigen gute Modellanpassung (AUC ~0.71).
* - Residualdiagnostik bestätigt robuste Spezifikation.
* - Keine einflussreichen Ausreißer.


*-----------------------------*
* Unconventional Participation*
*-----------------------------*

* Multicollinearity
frame change con1
xtdata i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround, fe clear
corr
frame change default

frame change con2
xtdata lmv_re class5 skill inc3med rlgdgr gender ethnie2 age agea unemp_nat gdp essround, fe clear
corr
frame change default

* Ergebnis: keine problematische Multikollinearität. SES-Korrelationen moderat und theoretisch sinnvoll.


*-----------------------------*
* Alternative Specifications  *
*-----------------------------*

xtreg politics i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, fe 
est store fe

xtreg politics i.labcon2 i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, re 
est store re

hausman fe re

xtreg politics c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, fe 
est store fe2

xtreg politics c.lmv_re i.class5 i.skill i.inc3med c.rlgdgr i.gender i.ethnie2 ///
    c.age c.agea c.unemp_nat c.gdp i.essround, re 
est store re2

hausman fe re

* Ergebnis: Hausman-Test -> FE bevorzugt (RE inkonsistent).


*-----------------------------*
* Time Variance Tests         *
*-----------------------------*

xtreg politics i.labcon2##i.essround i.class5 i.skill i.inc3med c.rlgdgr i.gender ///
    i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround, fe vce(cluster cntry_num) 

xtreg politics i.lmv_re##i.essround i.class5 i.skill i.inc3med c.rlgdgr i.gender ///
    i.ethnie2 c.age c.agea c.unemp_nat c.gdp i.essround, fe vce(cluster cntry_num) 
