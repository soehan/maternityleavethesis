//Hausman Tests
//GROUP A
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., re
hausman fixed ., sigmamore

//GROUP B
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., fe
estimates store fixed
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., re
hausman fixed ., sigmamore

//REGRESSIONS
//GROUP A
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m1, title(model 1)
xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year  if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m2, title(model 2)
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m3, title(model 3)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m4, title(model 4)
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m5, title(model 5)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m6, title(model 6)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 1 & firstchildcount != ., vce(robust) fe
estimates store m7, title(model 7)

estout m1 m2 m3 m4 m5 m6 m7, cells(b(star fmt(4)) t(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(r2 df_r bic, fmt(4 0 1) label(R-sqr dfres BIC))
	
//GROUP B
xtreg y weeksgap numchildren ib2.educfac logu ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m1, title(model 1)
xtreg y weeksgap numchildren marriagedummy ib2.educfac logu age ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m2, title(model 2)
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m3, title(model 3)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m4, title(model 4)
xtreg y weeksgap numchildren ib2.educfac age age2 marriagedummy numjobsyear ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m5, title(model 5)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m6, title(model 6)
xtreg y weeksgap ib2.educfac age age2 marriagedummy birthgap birthgapage birthgapage2 ib1979.year if gender == 2 & paidgapmarker == 0 & firstchildcount != ., vce(robust) fe
estimates store m7, title(model 7)

estout m1 m2 m3 m4 m5 m6 m7, cells(b(star fmt(4)) t(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(r2 df_r bic, fmt(4 0 1) label(R-sqr dfres BIC))
