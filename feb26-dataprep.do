/*
CODES REFERENCE:
-1 Refusal
-2 Don't Know
-3 Invalid Skip
-4 VALID SKIP
-5 NON-INTERVIEW
*/

////////////////////////////////////////////////////////////
// .DO FILE SETUP //////////////////////////////////////////
////////////////////////////////////////////////////////////

// Don't use paging.
set more off

// Data extract to use:
local dataver = "feb26"

// Uncomment and edit according to the system used (Mac/Win) and data folder.
cd "/Users/soehantha/Desktop/NLSY79"
//cd "Z:\home\torvall\Projects\SHTThesis\nls-data\"

// Clear all existing data.
clear *

// Import NLS data.
insheet using "`dataver'.csv", comma clear case

// Add labels to the variables.//
do "`dataver'-labels.do"
// Add labels to the values.
do "`dataver'-value-labels.do"


////////////////////////////////////////////////////////////
// PREPARE DATA FOR RESHAPING //////////////////////////////
////////////////////////////////////////////////////////////

// Get rid of useless variables.
drop VERSION_R26_2014 SAMPLE_ID_1979 SAMPLE_RACE_78SCRN

// Move the year to the end of some of the variables names to prepare them for reshaping.
rename EMPLOYERS_ALL_IND_????_01_XRND EMPLOYERS_ALL_IND_????
rename EMPLOYERS_ALL_OCC_????_01_XRND EMPLOYERS_ALL_OCC_????
rename CAL_YEAR_JOBS_????_XRND CAL_YEAR_JOBS_????
rename NUMCH90_1989 NUMCH89_1989
rename NUMCH*_# NUMCH_(####)[2]

// Create a dummy variable if there was any leave related to pregnancy, child care and other personal or family reasons. 
forvalues yr = 1979/2015 {
  capture confirm variable EMPLOYERS_ALL_WHYNOWK_`yr'_01_01
	if !_rc {
    egen LEAVEFAM_`yr' = anymatch(EMPLOYERS_ALL_WHYNOWK_`yr'_01_0*), values(8, 10, 11)
  }
}

// Get the number of days taken of paid pregnancy leave in current year.
// Note: There are some cases where the number of days of paid leave is 0.
forvalues yr = 1977/2015 {
  // Check if variables for this year exist.
  capture confirm variable QES_48_01_01_Y_`yr'
	if !_rc {
    // Normalize all years to 4 digit format.
    replace QES_48_01_01_Y_`yr' = 1900 + QES_48_01_01_Y_`yr' if QES_48_01_01_Y_`yr' < 100
    // Generate start and end date variables.
    gen STARTPAIDLEAVE_`yr' = mdy(QES_48_01_01_M_`yr', QES_48_01_01_D_`yr', QES_48_01_01_Y_`yr')
    gen ENDPAIDLEAVE_`yr' = mdy(QES_49_01_01_M_`yr', QES_49_01_01_D_`yr', QES_49_01_01_Y_`yr')
    // Set start and end date variables to time format.
    format STARTPAIDLEAVE_`yr' %td
    format ENDPAIDLEAVE_`yr' %td
    // Generate the variable with the number of days of paid pregnancy leave.
    gen DAYSPAIDLEAVE_`yr' = ENDPAIDLEAVE_`yr' - STARTPAIDLEAVE_`yr'
    // Drop source and intermediate variables.
    drop QES_48_01_01_*_`yr' QES_49_01_01_*_`yr' STARTPAIDLEAVE_`yr' ENDPAIDLEAVE_`yr'
  }
}

// Get rid of all period data after processing it.
drop *_NUM*_*
drop *_0?

// Reshape the data from wide format to long.
reshape long CAL_YEAR_JOBS_ DAYSPAIDLEAVE_ EMPLOYERS_ALL_IND_ EMPLOYERS_ALL_OCC_ ESR_COL_ HGC_ HRP1_ HRP2_ HRP3_ HRP4_ HRP5_ LEAVEFAM_ MARSTAT_COL_ MARSTAT_KEY_ NUMCH_ Q15_5_ Q2_3A_ QES_50_01_ QES_52A_01_ QES_52A_02_ QES_52A_03_ QES_52A_04_ QES_52A_05_ REGION_ RNI_ WKSWK_PCY_, i(CASEID_1979) j(year)

// Rename variables to use sensible and more practical names.
rename CASEID_1979 caseid
rename FAM_1B_1979 age
rename SAMPLE_SEX_1979 gender
rename REGION_ region
rename HGC_ educ
rename MARSTAT_KEY_ maritalstatus
rename NUMCH_ children
rename ESR_COL_ employmentstatusrecode
rename MARSTAT_COL_ maritalstatusrecode
rename WKSWK_PCY_ weeksworked
rename QES_50_01_ pregnancygaps
rename QES_52A_01_ hrsperweek1
rename QES_52A_02_ hrsperweek2
rename QES_52A_03_ hrsperweek3
rename QES_52A_04_ hrsperweek4
rename QES_52A_05_ hrsperweek5
rename DAYSPAIDLEAVE_ dayspaidleave
rename EMPLOYERS_ALL_IND_ industry
rename EMPLOYERS_ALL_OCC_ occupation
rename HRP1_ nomwage1
rename HRP2_ nomwage2
rename HRP3_ nomwage3
rename HRP4_ nomwage4
rename HRP5_ nomwage5
rename LEAVEFAM_ leavefam
rename RNI_ reasonnoninterview
rename Q15_5_ understandingofqs
rename Q2_3A_ maritalstatuschanged
rename CAL_YEAR_JOBS_ numjobsyear
rename C1DOB dobc1
rename C2DOB dobc2
rename C3DOB dobc3
rename C4DOB dobc4
rename C5DOB dobc5
rename C6DOB dobc6
rename C7DOB dobc7
rename C8DOB dobc8
rename C9DOB dobc9
rename C10DOB dobc10
rename C11DOB dobc11

// Mark the data as panel data.
xtset caseid year


/*
GENERATE/CLEAN NEEDED DATA
*/
// Set negative values (non answers) to missing.
replace dobc1 = . if dobc1 < 0
replace dobc2 = . if dobc2 < 0
replace dobc3 = . if dobc3 < 0
replace dobc4 = . if dobc4 < 0
replace dobc5 = . if dobc5 < 0
replace dobc6 = . if dobc6 < 0
replace dobc7 = . if dobc7 < 0
replace dobc8 = . if dobc8 < 0
replace dobc9 = . if dobc9 < 0
replace dobc10 = . if dobc10 < 0
replace dobc11 = . if dobc11 < 0

replace educ = . if educ < 0
replace industry = . if industry <= 0 // There are 2 0's in caseid 12018 that need to be cleared.
replace maritalstatus = . if maritalstatus < 0
replace occupation = . if occupation < 0
replace weeksworked = . if weeksworked < 0
replace pregnancygaps = . if pregnancygaps < 0
replace region = . if region<0
replace numjobsyear = . if numjobsyear < 0

replace nomwage1 = . if nomwage1 < 0
replace nomwage2 = . if nomwage2 < 0
replace nomwage3 = . if nomwage3 < 0
replace nomwage4 = . if nomwage4 < 0
replace nomwage5 = . if nomwage5 < 0

replace hrsperweek1 = . if hrsperweek1 < 0
replace hrsperweek2 = . if hrsperweek2 < 0
replace hrsperweek3 = . if hrsperweek3 < 0
replace hrsperweek4 = . if hrsperweek4 < 0
replace hrsperweek5 = . if hrsperweek5 < 0 

// We only got the age of the individuals in 1979, so we need to calculate it.
replace age = age + year - 1979
// Create race groups from ethnicity.
gen race = . if FAM_30_1_1979 <= 0 | FAM_31_1979 <= 0
// 0. other (0 NONE, 28 OTHER)
replace race = 0 if inlist(FAM_31_1979, 2, 4,  8, 9, 10, 13, 14, 28, 26) | inlist(FAM_30_1_1979, 2, 4, 8, 9, 10, 13, 14, 26, 28)
// 1. white (3 ENGLISH, 5 FRENCH, 6 GERMAN, 7 GREEK, 11 IRISH, 12 ITALIAN, 22 POLISH, 23 PORTUGUESE, 24 RUSSIAN, 25 SCOTTISH, 27 WELSH, 29 AMERICAN) = 12
replace race = 1 if inlist(FAM_31_1979, 3, 5, 6, 7, 11, 12, 22, 23, 24, 25, 27, 29) | (FAM_31_1979 < 0 & inlist(FAM_30_1_1979, 3, 5, 6, 7, 11, 12, 22, 23, 24, 25, 27, 29))
// 2. black (1 BLACK) = 1
replace race = 2 if FAM_31_1979 == 1 | (FAM_31_1979 < 0 & FAM_30_1_1979 == 1)
// 3. hispanic (15 CUBAN, 16 CHICANO, 17 MEXICAN, 18 MEXICAN-AMER, 19 PUERTO RICAN, 20 OTHER HISPANIC, 21 OTHER SPANISH) = 7
replace race = 3 if inlist(FAM_31_1979, 15, 16, 17, 18, 19, 20, 21) | (FAM_31_1979 < 0 & inlist(FAM_30_1_1979, 15, 16, 17, 18, 19, 20, 21))
drop FAM_31_1979 FAM_30_1_1979

// Create industry and occupation top level groups.
// https://www.nlsinfo.org/sites/nlsinfo.org/files/attachments/121217/Attachment%203-1970%20Industry%20and%20Occupational%20Codes.pdf
replace industry = 1 if industry >= 769 & industry <= 798
replace industry = 2 if industry >= 17 & industry <= 28
replace industry = 3 if industry >= 107 & industry <= 398
replace industry = 4 if industry >= 67 & industry <= 77
replace industry = 5 if industry >= 727 & industry <= 759
replace industry = 6 if industry >= 507 & industry <= 698
replace industry = 7 if industry >= 807 & industry <= 809
replace industry = 8 if industry >= 407 & industry <= 479
replace industry = 9 if industry >= 47 & industry <= 57
replace industry = 10 if industry >= 907 & industry <= 937
replace industry = 11 if industry >= 707 & industry <= 718
replace industry = 12 if industry >= 828 & industry <= 897
replace industry = 13 if industry != . & industry == 37 | industry == 399 | industry == 487 | industry == 497 | industry == 722 | industry == 817 | industry == 819 | industry == 827 | industry == 898 | industry == 947 | industry == 948 | industry == 967 | industry == 998 | industry == 999 | industry == 1180 | industry == 1370 | industry == 1480 | industry == 1690 | industry == 1870 | industry == 2270 | industry == 2290 | industry == 2380 | industry == 2390 | industry == 2590 | industry == 2680 | industry == 2870 | industry == 2980 | industry == 3080 | industry == 3090 | industry == 3170 | industry == 3190 | industry == 3490 | industry == 3590 | industry == 3680 | industry == 3890 | industry == 3990 | industry == 4260 | industry == 4270 | industry == 4470 | industry == 4670 | industry == 4870 | industry == 4970 | industry == 4990 | industry == 5380 | industry == 5570 | industry == 6180 | industry == 6190 | industry == 6290 | industry == 6370 | industry == 6670 | industry == 6680 | industry == 6770 | industry == 6870 | industry == 7380 | industry == 7470 | industry == 7590 | industry == 7680 | industry == 7770 | industry == 7860 | industry == 7870 | industry == 7980 | industry == 8170 | industry == 8190 | industry == 8270 | industry == 8370 | industry == 8470 | industry == 8660 | industry == 8680 | industry == 8870 | industry == 8980 | industry == 9080 | industry == 9090 | industry == 9170 | industry == 9470 | industry == 9480 | industry == 9590 | industry == 9990
//Primary: Agriculture, Fishing, Mining
//replace industry = 14 if industry == 2 | industry == 9
//Secondary: Manufacturing, Construction
//replace industry = 15 if industry == 3 | industry == 4
//Tertiary: Service Industry
//replace industry = 16 if industry == 1| industry == 5 | industry == 6 | industry == 7 | industry == 8 | industry == 10 | industry == 11 | industry == 12
replace ind = 14 if ind == 2 | industry == 3 | industry == 4 | ind == 9 | ind == 13
replace ind = 16 if ind == 1 | ind == 5 | ind == 7
replace ind = 18 if ind == 11 | ind == 12 | ind == 16 | ind == 10 | ind == 8


replace occupation = 13 if occupation >= 1 & occupation <= 195
replace occupation = 1 if occupation >= 980 & occupation <= 984
replace occupation = 2 if occupation >= 821 & occupation <= 824
replace occupation = 3 if occupation >= 740 & occupation <= 785
replace occupation = 4 if occupation >= 601 & occupation <= 695
replace occupation = 5 if occupation >= 901 & occupation <= 965
replace occupation = 6 if occupation >= 701 & occupation <= 715
replace occupation = 7 if occupation >= 401 & occupation <= 580
replace occupation = 8 if occupation >= 260 & occupation <= 280
replace occupation = 9 if occupation >= 301 & occupation <= 395
replace occupation = 10 if occupation >= 801 & occupation <= 802
replace occupation = 11 if occupation == 200 | occupation == 254 | occupation == 290 | occupation == 400 | occupation == 581 | occupation == 600 | occupation == 700 | occupation == 720 | occupation == 722 | occupation == 730 | occupation == 731 | occupation == 735 | occupation == 816 | occupation == 830 | occupation == 871 | occupation == 874 | occupation == 881 | occupation == 896 | occupation == 900 | occupation == 900 | occupation == 1020 | occupation == 1320 | occupation == 1920 | occupation == 2000 | occupation == 2010 | occupation == 2100 | occupation == 2110 | occupation == 2200 | occupation == 2300 | occupation == 2310 | occupation == 2340 | occupation == 2540 | occupation == 2630 | occupation == 2900 | occupation == 3230 | occupation == 3300 | occupation == 3320 | occupation == 3600 | occupation == 3650 | occupation == 3710 | occupation == 3720 | occupation == 3740 | occupation == 3820 | occupation == 3850 | occupation == 3940 | occupation == 4010 | occupation == 4020 | occupation == 4200 | occupation == 4220 | occupation == 4230 | occupation == 4250 | occupation == 4460 | occupation == 4510 | occupation == 4610 | occupation == 4700 | occupation == 4710 | occupation == 4720 | occupation == 4750 | occupation == 4760 | occupation == 5000 | occupation == 5120 | occupation == 5210 | occupation == 5240 | occupation == 5260 | occupation == 5310 | occupation == 5420 | occupation == 5520 | occupation == 5540 | occupation == 5560 | occupation == 5600 | occupation == 5610 | occupation == 5620 | occupation == 5630 | occupation == 5700 | occupation == 5810 | occupation == 5820 | occupation == 5860 | occupation == 5900 | occupation == 5920 | occupation == 5930 | occupation == 6000 | occupation == 6050 | occupation == 6130 | occupation == 6200 | occupation == 6750 | occupation == 6840 | occupation == 7000 | occupation == 7200 | occupation == 7220 | occupation == 7330 | occupation == 7340 | occupation == 7350 | occupation == 7700 | occupation == 7720 | occupation == 7750 | occupation == 7810 | occupation == 8160 | occupation == 8210 | occupation == 8710 | occupation == 8810 | occupation == 8960 | occupation == 9000 | occupation == 9140 | occupation == 9600 | occupation == 9620 | occupation == 9640
replace occupation = 12 if occupation >= 201 & occupation <= 245
//White collar
//replace occupation = 16 if occ == 12 | occ == 13
//Pink collar
//replace occupation = 15 if occ == 9 | occ == 8 | occ == 6 | occ == 5 | occ == 4
//Blue collar
//replace occupation = 14 if occ == 10 | occ == 7 | occ == 3 | occ == 2 | occ == 1
replace occ = 14 if occ == 10 | occ == 11 | occ == 12 | occ == 13 
replace occ = 15 if occ == 7 | occ == 8 | occ == 9
replace occ = 16 if occ == 4 | occ == 6
replace occ = 17 if occ == 1 | occ == 2 | occ == 3 | occ == 5

// Get the number of weeks not worked from the number of weeks worked.
gen weeksgap = 52 - weeksworked if weeksworked >= 0

/* Create a married dummy to use next.
bysort caseid (year): gen dummarried = 1 if maritalstatusrecode[_n-1] == 1 & maritalstatusrecode == 2
replace dummarried = 0 if dummarried == .
*/
gen dummarried = 1 if maritalstatusrecode == 2
replace dummarried = 0 if maritalstatusrecode == 3 | maritalstatus == 1

// Generate counter since year of first marriage.
gen maryrcount = .
bysort caseid (year): replace maryrcount = 0 if dummarried == 1
bysort caseid (year): replace maryrcount = maryrcount[_n-1] + 1 if maryrcount[_n-1] != .

// Generate counter until year of first marriage.
gsort caseid -year
by caseid: replace maryrcount = -1 if maryrcount[_n-1] == 0
by caseid: replace maryrcount = maryrcount[_n-1] - 1 if maryrcount == .
gsort caseid year
// Set all caseid's that got married to 1.
replace dummarried = 1 if maryrcount != .

/* Generate counter to and from year of first child.
bysort caseid (year): gen dumhadchildren = 1 if children[_n-1] == 0 & (children > 0 & children != .)
// Number of years since the birth of the first child (based on bio/step/adopted children in household).
gen firstchildyrcount = .
bysort caseid (year): replace firstchildyrcount = 0 if dumhadchildren == 1
bysort caseid (year): replace firstchildyrcount = firstchildyrcount[_n-1] + 1 if firstchildyrcount[_n-1] != .
// Number of years until the birth of the first child.
gsort caseid -year
by caseid: replace firstchildyrcount = -1 if firstchildyrcount[_n-1] == 0
by caseid: replace firstchildyrcount = firstchildyrcount[_n-1] - 1 if firstchildyrcount == .
gsort caseid year
// Set all caseid's that had a child to 1.
replace dumhadchildren = 1 if firstchildyrcount != .
*/

gen numchildren = 0
replace numchildren = 1 if dobc1 <= year
replace numchildren = 2 if dobc2 <= year
replace numchildren = 3 if dobc3 <= year
replace numchildren = 4 if dobc4 <= year
replace numchildren = 5 if dobc5 <= year
replace numchildren = 6 if dobc6 <= year
replace numchildren = 7 if dobc7 <= year
replace numchildren = 8 if dobc8 <= year
replace numchildren = 9 if dobc9 <= year
replace numchildren = 10 if dobc10 <= year
replace numchildren = 11 if dobc11 <= year

gen dumhadchildren = 1 if dobc1 > 0 & dobc1 != .
gen agec1 = year - dobc1 if dumhadchildren == 1

// Clear the pregnancygaps variable of negative numbers.
replace pregnancygaps = . if pregnancygaps < 0

gen dumhadpreggap = 1 if pregnancygap >=1 & pregnancygap != . & gender == 2 
replace dumhadpreggap = 0 if dumhadpreggap != 1 & gender == 2 & agec1 != .

// Set all caseid's that had pregnancy gaps to 1.
//egen dumeverhadpreggap = count(pregnancygaps) if pregnancygaps > 0 & pregnancygaps != . & dumhadchildren == 1, by(caseid)
//replace 

// Check what's going on here.
//replace pregnancygaps = -4 if gender == 2 & year >= 1988
//replace pregnancygaps = 0 if gender == 2 & pregnancygaps < 1 & pregnancygaps != .

// Clean up employmentstatusrecode to employed, unemployed, out of LF.
//replace employmentstatusrecode = 3 if income == 0 & weeksworked == 0
//replace employmentstatusrecode = 1 if weeksworked != 0 & employmentstatusrecode == .
replace employmentstatusrecode = 1 if employmentstatusrecode != 1 & employmentstatusrecode != 2 & employmentstatusrecode != 3
replace employmentstatusrecode = 3 if occupation == 590 // If person in armed forces, put them in out of LF.

// Clean occupation.
replace occupation = . if occupation == 590 // Then make that occupation as missing because it's not applicable.
replace occupation = . if occupation == 995 // set Never worked/Did not work during that period to missing.

// Merge inflation and unemployment data.
merge m:m year using inflation.dta, nogenerate
merge m:m year using unemployment.dta, nogenerate
sort caseid year

// Get rid of empty observations that were created.
drop if caseid == .

// Match the region unemployment with the individual's region.
// NE: 1 - MW: 2 - S: 3 - W: 4
gen unemployment = .
replace unemployment = northeast if region == 1
replace unemployment = midwest if region == 2
replace unemployment = south if region == 3
replace unemployment = west if region == 4
drop northeast midwest south west

gen logu = ln(unemployment)

gen realwage1 = nomwage1 / inflation / 100 if nomwage1 != .
gen realwage2 = nomwage2 / inflation / 100 if nomwage2 != .
gen realwage3 = nomwage3 / inflation / 100 if nomwage3 != .
gen realwage4 = nomwage4 / inflation / 100 if nomwage4 != .
gen realwage5 = nomwage5 / inflation / 100 if nomwage5 != .

gen earnings1 = realwage1 * hrsperweek1 if nomwage1 != . & hrsperweek1 != .
gen earnings2 = realwage2 * hrsperweek2 if nomwage2 != . & hrsperweek2 != .
gen earnings3 = realwage3 * hrsperweek3 if nomwage3 != . & hrsperweek3 != .
gen earnings4 = realwage4 * hrsperweek4 if nomwage4 != . & hrsperweek4 != .
gen earnings5 = realwage5 * hrsperweek5 if nomwage5 != . & hrsperweek5 != .

egen totalearnings = rowtotal(earnings*), missing
egen totalhrsworked = rowtotal(hrsperweek*), missing

// Get rid of negatives in the income variable.
//replace income = . if income < 0
// Generate the real income variable.


// Generate variables to capture nonlinear effects.
gen age2 = age * age
gen age3 = age2 * age
gen educ2 = educ * educ

gen educfac = 1 if educ < 12 & educ != . 
replace educfac = 2 if educ == 12 | educ == 13 | educ == 14 | educ == 15 
replace educfac = 3 if educ == 16
replace educfac = 4 if educ > 16 & educ != .
label define lblEducfac 1 "1 Less than HS" 2 "2 HS graduate" 3 "3 College" 4 "4 Masters/PhD"
lab values educfac lblEducfac

gen kids = .
replace kids = 0 if children == 0
replace kids = 1 if children == 1
replace kids = 2 if children == 2
replace kids = 3 if children == 3
replace kids = 4 if children > 4 & children != .

////////////////////////////////////////////////////////////
// CLEAN UP MISSING VALUES /////////////////////////////////
////////////////////////////////////////////////////////////

// Get rid of records without data.
//drop if understanding == -5 | income == -1 | income == -2 | employmentstatusrecode == -3 | employmentstatusrecode == 4
//drop if maritalstatus == -3 & income == -3
//drop if employmentstatusrecode != 1 & pregnancygaps == -3 & pregnancygaps == . // Check if this is still needed.

replace maritalstatus = 2 if maritalstatus == 3 | maritalstatus == 6
// Generate dummy variables.
//do `dataver'-dummies.do


////////////////////////////////////////////////////////////
// LABEL DATA //////////////////////////////////////////////
////////////////////////////////////////////////////////////

// Value labels.
label define lblRace 0 "0 OTHER" 1 "1 WHITE" 2 "2 BLACK" 3 "3 HISPANIC"
label values race lblRace
label define lblRegion 1 "NORTHEAST" 2 "MIDWEST" 3 "SOUTH" 4 "WEST"
label values region lblRegion
label define lblMarStat 0 "0 NEVER MARRIED" 1 "1 MARRIED" 2 "2 SEPARATED, DIVORCED, OR WIDOWED"
label values maritalstatus lblMarStat
label values employmentstatus vlR0214901
label values maritalstatusrecode vlR0405600
label define lblIndustry 6 "6 Wholesale and Retail Trade " 14 " 14 Agriculture, Manufacturing, & Kindred" 16 " 16 Business, Finance, and Kindred" 18 "18 Business, Finance, and Kindred Services" 
label values industry lblIndustry
//label define lblOccupation 0 "None" 13 "13 Professional, Technical, and Kindred Workers" 12 "12 Managers and Administrators, except Farm" 8 "8 Sales Workers" 9 "9 Clerical and Unskilled Workers" 7 "7 Craftsmen and Kindred Workers" 4 "4 Operatives, except Transport" 6 "6 Transport Equipment Operatives" 3 "3 Laborers, except Farm" 10 "10 Farmers and Farm Managers" 2 "2 Farm Laborers and Farm Foremen" 5 "5 Service Workers, except Private Household" 1 "1 Private Household Workers" 11 "11 Other" 990 "Same as present job"
label define lblOccupation 14 "14 Managers, Administrators, and Kindred" 15 "15 Clerical, Sales, and Kindred Workers" 16 "16 Operatives" 17 "17 Laborers and Service Workers"
label values occupation lblOccupation
label values understandingofqs vlR0329700
label values maritalstatuschanged vlR0411400

// Variable labels.
label var caseid "Panel case ID"
label var year "Year of the observation"
label var age "Age of the individual at the time of the observation"
label var race "The individual's race"
label var educ "Highest grade completed"
label var educfac "Education factor variables (from educ)"
label var maritalstatus "Marital status"
label var children "Number of bio/step/adpt children in household"
label var industry "Industry the individual works in"
label var occupation "Occupation of the individual"
label var weeksworked "Weeks worked in the year"
label var weeksgap "Number of weeks not worked in the year"
label var leavefam "Had a gap for family reasons"
label var pregnancygaps "Number of paid pregnancy gaps in the year"
label var dumhadpreggap "Paid preggap dummy"

drop if educ == . 
////////////////////
// Number of years since the birth of the first child (based on bio/step/adopted children in household).
gen pregnancygapcount = .
bysort caseid (year): replace pregnancygapcount = 0 if dumhadpreggap == 1
bysort caseid (year): replace pregnancygapcount = pregnancygapcount[_n-1] + 1 if pregnancygapcount[_n-1] != .

// Number of years until the birth of the first child.
gsort caseid -year
by caseid: replace pregnancygapcount = -1 if pregnancygapcount[_n-1] == 1
by caseid: replace pregnancygapcount = pregnancygapcount[_n-1] -1 if pregnancygapcount[_n-1] != . 
gsort caseid year

gen paidgapmarker = 1 if pregnancygapcount != .
replace paidgapmarker = 0 if dumhadpreggap == 0 & paidgapmarker != 1

gen fweeksgap = f.weeksgap
gen y = log(realwage1)

gen dumhadchildren2 = 1 if dobc1 > 0 & dobc1 != .
//gen agec1 = year - dobc1 if dumhadchildren == 1 //apparently it's already defined
gen agec2 = year - dobc2 if dumhadchildren == 1
gen agec3 = year - dobc3 if dumhadchildren == 1
gen agec4 = year - dobc4 if dumhadchildren == 1
gen agec5 = year - dobc5 if dumhadchildren == 1
gen agec6 = year - dobc6 if dumhadchildren == 1
gen agec7 = year - dobc7 if dumhadchildren == 1
gen agec8 = year - dobc8 if dumhadchildren == 1
gen agec9 = year - dobc9 if dumhadchildren == 1
gen agec10 = year - dobc10 if dumhadchildren == 1
gen agec11 = year - dobc11 if dumhadchildren == 1

gen firstchildcounter = agec1
//replace firstchildcounter = . if firstchildcounter < -5
//replace firstchildcounter = . if firstchildcounter > 25

replace agec1 = . if agec1 < 0
replace agec2 = . if agec2 < 0
replace agec3 = . if agec3 < 0
replace agec4 = . if agec4 < 0
replace agec5 = . if agec5 < 0
replace agec6 = . if agec6 < 0
replace agec7 = . if agec7 < 0
replace agec8 = . if agec8 < 0
replace agec9 = . if agec9 < 0
replace agec10 = . if agec10 < 0
replace agec11 = . if agec11 < 0

//generate age of youngestchild
gen lastchildyrcount = 0
replace lastchildyrcount = year - dobc1 if dobc1 != .
replace lastchildyrcount = year - dobc2 if dobc2 != .
replace lastchildyrcount = year - dobc3 if dobc3 != .
replace lastchildyrcount = year - dobc4 if dobc4 != .
replace lastchildyrcount = year - dobc5 if dobc5 != .
replace lastchildyrcount = year - dobc6 if dobc6 != .
replace lastchildyrcount = year - dobc7 if dobc7 != .
replace lastchildyrcount = year - dobc8 if dobc8 != .
replace lastchildyrcount = year - dobc9 if dobc9 != .
replace lastchildyrcount = year - dobc10 if dobc10 != .
replace lastchildyrcount = year - dobc11 if dobc11 != .
replace lastchildyrcount = . if lastchildyrcount < 0
//////////////////////////////////////////
//generate "birthgap" to measure gap between first kid and last kid of year t
gen childgap1 = dobc2 - dobc1 if agec2 != .
gen childgap2 = dobc3 - dobc1 if agec3 != .
gen childgap3 = dobc4 - dobc1 if agec4 != .
gen childgap4 = dobc5 - dobc1 if agec5 != .
gen childgap5 = dobc6 - dobc1 if agec6 != .
gen childgap6 = dobc7 - dobc1 if agec7 != .
gen childgap7 = dobc8 - dobc1 if agec8 != .
gen childgap8 = dobc9 - dobc1 if agec9 != .
gen childgap9 = dobc10 - dobc1 if agec10 != .
gen childgap10 = dobc11 - dobc1 if agec11 != .


gen birthgap = childgap1/numchildren if childgap1 != .
replace birthgap = childgap2/numchildren if childgap2 != .
replace birthgap = childgap3/numchildren if childgap3 != .
replace birthgap = childgap4/numchildren if childgap4 != .
replace birthgap = childgap5/numchildren if childgap5 != .
replace birthgap = childgap6/numchildren if childgap6 != .
replace birthgap = childgap7/numchildren if childgap7 != .
replace birthgap = childgap8/numchildren if childgap8 != .
replace birthgap = childgap9/numchildren if childgap9 != .
replace birthgap = childgap10/numchildren if childgap10 != .

////////////////////////////////////////////////////


gen childyrgap = agec1 - lastchildyrcount
replace childyrgap = . if childyrgap == 0


replace maryrcount = . if maryrcount < -5

gen marriage = 1 if maritalstatusrecode == 1
replace marriage = 2 if maritalstatusrecode == 2
replace marriage = 3 if maritalstatusrecode == 3
replace marriage = 2 if caseid == 992 & maritalstatusrecode < 0
replace marriage = 3 if caseid == 1086 & maritalstatusrecode < 0
replace marriage = 2 if caseid == 1389 & maritalstatusrecode < 0
replace marriage = 2 if caseid == 2260 & maritalstatusrecode < 0
replace marriage = 3 if caseid == 2412 & maritalstatusrecode < 0
replace marriage = 2 if caseid == 10375 & maritalstatusrecode < 0
replace marriage = 3 if caseid == 4493 & maritalstatusrecode < 0
replace marriage = 3 if caseid == 4663 & maritalstatusrecode < 0
replace marriage = 1 if caseid == 5802 & maritalstatusrecode < 0
replace marriage = 2 if caseid == 9978 & maritalstatusrecode < 0
replace marriage = 3 if caseid == 9986 & maritalstatusrecode < 0
label define lblMarriage 1 "1 Never Married" 2 "2 Married, Spouse Present" 3 "3 Separated/Divorced"
label values marriage lblMarriage

replace y = 0 if y < 0

//DROP INTERMEDIATE VARS
do "dropintervars.do"
do "replacemissing.do"

//birthgap interactions
gen birthgapage = birthgap*age
gen birthgapage2 = birthgap*age2

//marriagedummy
gen marriagedummy = 1 if marriage == 2
replace marriagedummy = 0 if marriage != 2

// Order variables list.
order caseid year age age2 age3 race educfac marriage numchildren realwage1 y industry occupation fweeksgap leavefam

// Output data stats.
misstable sum, show
count
