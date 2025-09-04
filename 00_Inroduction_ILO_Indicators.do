
clear all

cd "/Users/nastianedjai/Desktop/Makrovariables/National_Var/"


import excel "/Users/nastianedjai/Desktop/Makrovariables/National_Var/GDP_UNEMP.xlsx", sheet("Data") cellrange(A1:D34) firstrow clear
duplicates list cntry year

replace cntry = "ES" in 3
replace cntry = "ES" in 14
replace cntry = "ES" in 25
replace cntry = "NL" in 8
replace cntry = "NO" in 9
replace cntry = "NL" in 19
replace cntry = "NO" in 20
replace cntry = "NL" in 30
replace cntry = "NO" in 31

save NAT.dta, replace

clear all
cd "/Users/nastianedjai/Desktop/Makrovariables/Kumulierter Datensatz/"
use "/Users/nastianedjai/Desktop/Makrovariables/Kumulierter Datensatz/PSE.dta"

drop _merge
merge m:1 cntry year using "/Users/nastianedjai/Desktop/Makrovariables/National_Var/NAT.dta" 
tab cntry if _merge == 2 
tab gdp year if cntry == "PT" // check 
tab unemp_nat year if cntry == "PT" // check 

save PSE.dta, replace


* ILO DATA
frame change default

frame create ILO
frame change ILO

drop source_label sex_label indicator_label obs_status_label note_indicator_label note_source_label

destring time, replace
 
rename ref_area_label cntry

collapse (mean) obs_value, by(time)
collapse (median) obs_value, by(time)

twoway (line obs_value time, sort lwidth(medthick) lcolor(cranberry)), ///
    title("Temporary Employment Rates in Western Europe from 1986-2024", size(*1.1) margin(b=4)) ///
    xtitle("Year", size(*0.9) margin(medsmall)) ///
    ytitle("% of total employees", size(*0.9) margin(medsmall)) ///
    ylabel(, angle(horizontal)) ///
    xlabel(1980 (5) 2025, angle(horizontal)) /// 
	scheme(plotplain)
	
graph export test.eps, as(eps)
writepsfrag test.eps using test.tex, body(document)

frame change default
*note(Temporary employment rates (% of total employees) in the EU-28 and in different country clusters in the period 1983–2024. Data: ILO Database (2025))

