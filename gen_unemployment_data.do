// Uncomment and edit according to the system used (Mac/Win) and data folder.
cd "/Users/soehantha/Desktop/NLSY79"
//cd "Z:\home\torvall\Projects\SHTThesis\nls-data\"

clear *
insheet using "unemployment_data.csv", comma names
save "unemployment.dta", replace
