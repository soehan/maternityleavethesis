// Uncomment and edit according to the system used (Mac/Win) and data folder.
cd "/Users/soehantha/Desktop/NLSY79"
//cd "Z:\home\torvall\Projects\SHTThesis\nls-data\"

// Base year to use. Options are "1982" and "2017"
local baseyear = "2017"

clear *
insheet using "inflation_data_`baseyear'.csv", comma names
save "inflation.dta", replace
