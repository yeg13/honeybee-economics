
drop canola_bts
gen canola_bts=(month<=7&month>=5)
gen canola_bte=(month==5|month==8)
replace canola_bts=1 if (month<=7&month>=5)
replace canola_bte=1 if (month==5|month==8)

tab month, gen(month)
gen lnprecipm=ln(average_mintemp)
gen lnprecipa=ln(average_precip)

drop if region==7
egen _year=group(year)

**Blooming time start and end - Corn**
gen percorn_bts=percorn if corn_bts==1
replace percorn_bts=0 if corn_bts==0

gen percorn_bte=percorn if corn_bte==1
replace percorn_bte=0 if corn_bte==0

**Blooming time start and end - Cotton**
gen percotton_bts=percotton if cotton_bts==1
replace percotton_bts=0 if cotton_bts==0

gen percotton_bte=percotton if cotton_bte==1
replace percotton_bte=0 if cotton_bte==0

drop percotton_bt
gen percotton_bt=percotton if cotton_bte==1|cotton_bts==1
replace percotton_bt=0 if cotton_bte==0&cotton_bts==0

**Blooming time start and end - Sorghum**
gen persorghum_bts=persorghum if sorghum_bts==1
replace persorghum_bts=0 if sorghum_bts==0

gen persorghum_bte=persorghum if sorghum_bte==1
replace persorghum_bte=0 if sorghum_bte==0

gen persorghum_bt=persorghum if sorghum_bte==1|sorghum_bts==1
replace persorghum_bt=0 if sorghum_bte==0&sorghum_bts==0

**Blooming time start and end - Soybeans**
gen persoybean_bts=persoybean if soybean_bts==1
replace persoybean_bts=0 if soybean_bts==0

gen persoybean_bte=persoybean if soybean_bte==1
replace persoybean_bte=0 if soybean_bte==0

gen persoybean_bt=persoybean if soybean_bte==1|soybean_bts==1
replace persoybean_bt=0 if soybean_bte==0&soybean_bts==0

drop agg_natural
drop pernatural
gen agg_natural=agg_forest+agg_shrubland+agg_grassland+agg_wetland
gen pernatural=agg_natural*100/totalarea


**Blooming time for natural areas**

drop bloom_region
gen bloom_region=2 if migratory==0&(state=="WA"|state=="OR"|state=="WY")
replace bloom_region=3 if migratory==0&(state=="CA")
replace bloom_region=10 if migratory==0&(state=="MN"|state=="WI"|state=="IA"|state=="IL"|state=="IN"|state=="OH"|state=="MI")
replace bloom_region=5 if migratory==0&(state=="NV"|state=="UT")
replace bloom_region=6 if migratory==0&(state=="AZ"|state=="NM")
replace bloom_region=8 if migratory==0&(state=="MT"|state=="ND"|state=="SD"|state=="NE"|state=="KS"|state=="CO"|state=="OK"|state=="TX")
replace bloom_region=11 if migratory==0&(state=="MO"|state=="KY"|state=="NY"|state=="PA"|state=="WV"|state=="TN"|state=="AL"|state=="GA"|state=="VA"|state=="NC")
drop naturalbt
gen naturalbt=1 if ((bloom_region==2&month>=2&month<=10)|(bloom_region==3&month>=1&month<=10)|(bloom_region==5&month>=4&month<=9)|(bloom_region==6&month>=3&month<=12)|(bloom_region==8&month>=5&month<=10)|(bloom_region==10&month>=5&month<=10)|(bloom_region==11&month>=4&month<=11))
replace naturalbt=0 if missing(naturalbt)

gen pernaturalbt=pernatural if naturalbt==1
replace pernaturalbt=0 if missing(pernaturalbt)

gen cornbt=1 if (corn_bts==1|corn_bte==1)
gen cottonbt=1 if (cotton_bts==1|cotton_bte==1)
gen sorghumbt=1 if (sorghum_bts==1|sorghum_bte==1)
gen soybt=1 if (soybean_bts==1|soybean_bte==1)
gen canolabt=1 if (canola_bts==1|canola_bte==1)
replace cornbt=0 if missing(cornbt)
replace cottonbt=0 if missing(cottonbt)
replace sorghumbt=0 if missing(sorghumbt)
replace soybt=0 if missing(soybt)
replace canolabt=0 if missing(canolabt)

replace percornpt=percorn if plantcorn==1
replace percornpt=0 if (missing(percornpt)&!missing(totalarea))
replace persoybeanpt=persoybean if plantsoy==1
replace persoybeanpt=0 if (missing(persoybeanpt)&!missing(totalarea))
replace percanolapt=percanola if plantcanola==1
replace percanolapt=0 if (missing(percanolapt)&!missing(totalarea))
replace perricept=perrice if (plantrice==1&!missing(totalarea))
replace perricept=0 if (missing(perricept)&!missing(totalarea))
replace persorghumpt=persorghum if plantsorghum==1
replace persorghumpt=0 if (missing(persorghumpt)&!missing(totalarea))
replace perspringwhtpt=perspringwht if plantspringwht==1
replace perspringwhtpt=0 if (missing(perspringwhtpt)&!missing(totalarea))
replace perwinwhtpt=perwinwht if plantwinwht==1
replace perwinwhtpt=0 if (missing(perwinwhtpt)&!missing(totalarea))

drop if migratory_proxy==1


gen fungi=1 if (Azoxystrobin|Boscalid|Bromuconazole|Captan|CarbendazimMBC|Carboxin|Chlorothalonil|Cyprodinil|Dicloran|Difenoconazole|Dimethomorph|Diphenamid|Epoxiconazole|Etridiazole|Famoxadone|Fenamidone|Fenbuconazole|Fenhexamid|Fludioxonil|Fluoxastrobin|Flutolanil|HexachlorobenzeneHCB|Hexythiazox|Hydroxychlorothalonil|Imazalil|Iprodione|Mefenoxam|Metalaxyl|Myclobutanil|Propiconazole|Pyraclostrobin|Pyrimethanil|Quinoxyfen|QuintozenePCNB|Tebuconazole|Tetraconazole|Thiabendazole|THPI|Triadimefon|Triadimenol|Trifloxystrobin|Triflumizole|Triticonazole|Vinclozolin)>0
lowess lnnosema percorn, bwidth(0.8) title(Lowess smoother Nosema and Corn)
lowess lnnosema percorn if plantcorn==1, bwidth(0.8) title (Lowess smoother Nosema and corn during planting)
lowess lnnosema percorn if cornbt==1, bwidth(0.8) title (Lowess smoother Nosema and corn during blooming)
lowess lnnosema persoybean, bwidth(0.8) title(Lowess smoother Nosema and Soy)
lowess lnnosema persoybean if plantsoy==1, bwidth(0.8) title (Lowess smoother Nosema and soy during planting)
lowess lnnosema persoybean if soybt==1, bwidth(0.8) title (Lowess smoother Nosema and soy during blooming)

lowess lnmites percorn, bwidth(0.8) title(Lowess smoother Mites and Corn)
lowess lnmites percorn if plantcorn==1, bwidth(0.8) title (Lowess smoother Mites and corn during planting)
lowess lnmites percorn if cornbt==1, bwidth(0.8) title (Lowess smoother Mites and corn during blooming)
lowess lnmites persoybean, bwidth(0.8) title(Lowess smoother Mites and Soy)
lowess lnmites persoybean if plantsoy==1, bwidth(0.8) title (Lowess smoother Mites and soy during planting)
lowess lnmites persoybean if soybt==1, bwidth(0.8) title (Lowess smoother Mites and soy during blooming)

lowess lnmites1 percorn, bwidth(0.8) title(Lowess smoother Mites and Corn)
lowess lnmites1 percorn if plantcorn==1, bwidth(0.8) title (Lowess smoother Mites and corn during planting)
lowess lnmites1 percorn if cornbt==1, bwidth(0.8) title (Lowess smoother Mites and corn during blooming)
lowess lnmites1 persoybean, bwidth(0.8) title(Lowess smoother Mites and Soy)
lowess lnmites1 persoybean if plantsoy==1, bwidth(0.8) title (Lowess smoother Mites and soy during planting)
lowess lnmites1 persoybean if soybt==1, bwidth(0.8) title (Lowess smoother Mites and soy during blooming)

lowess lnnosema percotton, bwidth(0.8) title(Lowess smoother Nosema and Cotton)
lowess lnnosema percotton if plantcotton==1, bwidth(0.8) title (Lowess smoother Nosema and cotton during planting)
lowess lnnosema percotton if cottonbt==1, bwidth(0.8) title (Lowess smoother Nosema and cotton during blooming)
lowess lnmites percotton, bwidth(0.8) title(Lowess smoother Mites and Cotton)
lowess lnmites percotton if plantcotton==1, bwidth(0.8) title (Lowess smoother Mites and cotton during planting)
lowess lnmites percotton if cottonbt==1, bwidth(0.8) title (Lowess smoother Mites and cotton during blooming)

lowess lnnosema percanola, bwidth(0.8) title(Lowess smoother Nosema and Canola)
lowess lnnosema percanola if plantcanola==1, bwidth(0.8) title (Lowess smoother Nosema and canola during planting)
lowess lnnosema percanola if canolabt==1, bwidth(0.8) title (Lowess smoother Nosema and canola during blooming)
lowess lnmites percanola, bwidth(0.8) title(Lowess smoother Mites and Canola)
lowess lnmites percanola if plantcanola==1, bwidth(0.8) title (Lowess smoother Mites and canola during planting)
lowess lnmites percanola if canolabt==1, bwidth(0.8) title (Lowess smoother Mites and canola during blooming)

lowess lnnosema persorghum, bwidth(0.8) title(Lowess smoother Nosema and Sorghum)
lowess lnnosema persorghum if plantsorghum==1, bwidth(0.8) title (Lowess smoother Nosema and sorghum during planting)
lowess lnnosema persorghum if sorghumbt==1, bwidth(0.8) title (Lowess smoother Nosema and sorghum during blooming)
lowess lnmites persorghum, bwidth(0.8) title(Lowess smoother Mites and Sorghum)
lowess lnmites persorghum if plantsorghum==1, bwidth(0.8) title (Lowess smoother Mites and sorghum during planting)
lowess lnmites persorghum if sorghumbt==1, bwidth(0.8) title (Lowess smoother Mites and sorghum during blooming)

lowess lnnosema perrice, bwidth(0.8) title(Lowess smoother Nosema and Rice)
lowess lnnosema perrice if plantrice==1, bwidth(0.8) title (Lowess smoother Nosema and rice during planting)
lowess lnmites perrice, bwidth(0.8) title(Lowess smoother Mites and Rice)
lowess lnmites perrice if plantrice==1, bwidth(0.8) title (Lowess smoother Mites and rice during planting)

lowess lnnosema perbarley, bwidth(0.8) title(Lowess smoother Nosema and Barley)
lowess lnnosema perbarley if plantbarley==1, bwidth(0.8) title (Lowess smoother Nosema and barley during planting)
lowess lnmites perbarley, bwidth(0.8) title(Lowess smoother Mites and Barley)
lowess lnmites perbarley if plantbarley==1, bwidth(0.8) title (Lowess smoother Mites and barley during planting)

gen plantspringwht=1 if month==4|month==5|month==6
replace plantspringwht=0 if missing(plantspringwht)

lowess lnnosema perspringwht, bwidth(0.8) title(Lowess smoother Nosema and Spring wheat)
lowess lnnosema perspringwht if plantspringwht==1, bwidth(0.8) title (Lowess smoother Nosema and spring wheat during planting)
lowess lnmites perspringwht, bwidth(0.8) title(Lowess smoother Mites and springwheat)
lowess lnmites perspringwht if plantspringwht==1, bwidth(0.8) title (Lowess smoother Mites and spring wheat during planting)

lowess lnnosema perwinwht, bwidth(0.8) title(Lowess smoother Nosema and winter wheat)
lowess lnnosema perwinwht if plantwinwht==1, bwidth(0.8) title (Lowess smoother Nosema and winter wheat during planting)
lowess lnmites perwinwht, bwidth(0.8) title(Lowess smoother Mites and winterwheat)
lowess lnmites perwinwht if plantwinwht==1, bwidth(0.8) title (Lowess smoother Mites and winter wheat during planting)

tab lnnosema if year==2009
sum lnnosema if year==2010
sum lnnosema if year==2011
sum lnnosema if year==2012
sum lnnosema if year==2013
sum lnnosema if year==2014

sum lnCornall900 if year==2010
sum lnCornall900 if year==2011
sum lnCornall900 if year==2012
sum lnCornall900 if year==2013
sum lnCornall900 if year==2014
sum lnSoyall900 lnCanola lnSpringwht lnWinterwht lnSorghum lnCotton if lnnosema!=0

***Full Crop Models***
drop if migratory!=0
tab neonics

*Model 1
replace lnmites1=ln(mites+1)
replace month2=month*month
egen _year=group(year)
destring year, generate(year2)

reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region

**Model 2
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region

**Model 3
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region

**Model 4
gen natural_ndvi=pernatural*average_veg
replace natural_ndvi=pernatural*average_veg
sum average_veg natural_ndvi
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region

**Model 5
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region

**Model 6**NDVI during bloom?
gen ndvi_bloom=average_veg*naturalbt
replace ndvi=0 if missing(ndvi_bloom)
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region


**Model 7
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region

**Model 8
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region

**Model 9
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region

**Model 10
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region

**Model 11
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region

**Model 12**NDVI during bloom?
reg lnnosema percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region

***Natural Log Full Crop Model***
drop lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900
gen lnCornall900=ln(cornall+900)
gen lnSoyall900=ln(soybeans+900)
gen lnCottonall900=ln(cotton+900)
gen lnCanola900=ln(canola+900)
gen lnSorghum900=ln(sorghum+900)
gen lnRice900=ln(rice+900)
gen lnBarleyall900=ln(barley+900)
gen lnSpringwht900=ln(spring_wheat+900)
gen lnWinterwht900=ln(winter_wheat+900)
gen lnNatural900=ln(agg_natural+900)
replace lnCornall900=0 if (missing(lnCornall900)&percorn>=0)
replace lnSoyall900=0 if (missing(lnSoyall900)&percorn>=0)
replace lnCottonall900=0 if (missing(lnCottonall900)&percorn>=0)
replace lnCanola900=0 if (missing(lnCanola900)&percorn>=0)
replace lnSorghum900=0 if (missing(lnSorghum900)&percorn>=0)
replace lnRice900=0 if (missing(lnRice900)&percorn>=0)
replace lnBarleyall900=0 if (missing(lnBarleyall900)&percorn>=0)
replace lnSpringwht900=0 if (missing(lnSpringwht900)&percorn>=0)
replace lnWinterwht900=0 if (missing(lnWinterwht900)&percorn>=0)
replace lnNatural900=0 if (missing(lnNatural900)&percorn>=0)

sum lnCornall900 if (lnCornall900!=0&lnnosema!=0)


*Model 1
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region

**Model 2
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region

**Model 3
gen lnNaturalbt=lnNatural900 if naturalbt==1
replace lnNaturalbt=0 if naturalbt==0
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region

**Model 4
gen natural_ndvi=pernatural*average_veg
gen lnNatural_ndvi=lnNatural900*average_veg
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region

**Model 5
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region

**Model 6**NDVI during bloom?
gen ndvi_bloom=average_veg*naturalbt
replace ndvi=0 if missing(ndvi_bloom)
gen lnndvi_bloom=lnndvi*naturalbt
replace lnndvi_bloom=0 if missing(ndvi_bloom)
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region

**Model 7
drop lntemp
gen lntemp=ln(average_mintemp)
sum lntemp average_mintemp
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region

**Model 8
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region

**Model 9
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region

**Model 10
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region

**Model 11
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region

**Model 12**NDVI during bloom?
reg lnnosema lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

****Tobit***

*****Table C.7.Nosema and Corn****
****Percentages****
*Model 1*
reg lnnosema percorn percornpt month month2 i.year i.region
reg lnmites1 percorn percornpt month month2 i.year i.region
**Model 2
reg lnnosema percorn percornpt pernatural month month2 i.year i.region
reg lnmites1 percorn percornpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema percorn percornpt pernaturalbt month month2 i.year i.region
reg lnmites1 percorn percornpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema percorn percornpt natural_ndvi month month2 i.year i.region
reg lnmites1 percorn percornpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema percorn percornpt average_veg month month2 i.year i.region
reg lnmites1 percorn percornpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema percorn percornpt ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn percornpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema percorn percornpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema percorn percornpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema percorn percornpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema percorn percornpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema percorn percornpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema percorn percornpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn percornpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnCornall900 lnCornall900pt month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt month month2 i.year i.region
**Model 2
reg lnnosema lnCornall900 lnCornall900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnCornall900 lnCornall900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnCornall900 lnCornall900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnCornall900 lnCornall900pt average_veg month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnCornall900 lnCornall900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnCornall900 lnCornall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.8.Nosema and Soy****
****Percentages****
*Model 1*
reg lnnosema persoybean persoybeanpt month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt month month2 i.year i.region
**Model 2
reg lnnosema persoybean persoybeanpt pernatural month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema persoybean persoybeanpt pernaturalbt month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema persoybean persoybeanpt natural_ndvi month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema persoybean persoybeanpt average_veg month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema persoybean persoybeanpt ndvi_bloom month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema persoybean persoybeanpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema persoybean persoybeanpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema persoybean persoybeanpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema persoybean persoybeanpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema persoybean persoybeanpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema persoybean persoybeanpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnSoyall900 lnSoyall900pt month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt month month2 i.year i.region
**Model 2
reg lnnosema lnSoyall900 lnSoyall900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnSoyall900 lnSoyall900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnSoyall900 lnSoyall900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnSoyall900 lnSoyall900pt average_veg month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnSoyall900 lnSoyall900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnSoyall900 lnSoyall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.9.Nosema and Cotton****
****Percentages****
*Model 1*
reg lnnosema percotton percottonpt month month2 i.year i.region
reg lnmites1 percotton percottonpt month month2 i.year i.region
**Model 2
reg lnnosema percotton percottonpt pernatural month month2 i.year i.region
reg lnmites1 percotton percottonpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema percotton percottonpt pernaturalbt month month2 i.year i.region
reg lnmites1 percotton percottonpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema percotton percottonpt natural_ndvi month month2 i.year i.region
reg lnmites1 percotton percottonpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema percotton percottonpt average_veg month month2 i.year i.region
reg lnmites1 percotton percottonpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema percotton percottonpt ndvi_bloom month month2 i.year i.region
reg lnmites1 percotton percottonpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema percotton percottonpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema percotton percottonpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema percotton percottonpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema percotton percottonpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema percotton percottonpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema percotton percottonpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 percotton percottonpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnCottonall900 lnCottonall900pt month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt month month2 i.year i.region
**Model 2
reg lnnosema lnCottonall900 lnCottonall900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnCottonall900 lnCottonall900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnCottonall900 lnCottonall900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnCottonall900 lnCottonall900pt average_veg month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnCottonall900 lnCottonall900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnCottonall900 lnCottonall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.10.Nosema and Canola****
****Percentages****
*Model 1*
reg lnnosema percanola percanolapt month month2 i.year i.region
reg lnmites1 percanola percanolapt month month2 i.year i.region
**Model 2
reg lnnosema percanola percanolapt pernatural month month2 i.year i.region
reg lnmites1 percanola percanolapt pernatural month month2 i.year i.region
**Model 3
reg lnnosema percanola percanolapt pernaturalbt month month2 i.year i.region
reg lnmites1 percanola percanolapt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema percanola percanolapt natural_ndvi month month2 i.year i.region
reg lnmites1 percanola percanolapt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema percanola percanolapt average_veg month month2 i.year i.region
reg lnmites1 percanola percanolapt average_veg month month2 i.year i.region
**Model 6
reg lnnosema percanola percanolapt ndvi_bloom month month2 i.year i.region
reg lnmites1 percanola percanolapt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema percanola percanolapt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema percanola percanolapt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema percanola percanolapt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema percanola percanolapt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema percanola percanolapt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema percanola percanolapt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 percanola percanolapt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnCanola900 lnCanola900pt month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt month month2 i.year i.region
**Model 2
reg lnnosema lnCanola900 lnCanola900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnCanola900 lnCanola900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnCanola900 lnCanola900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnCanola900 lnCanola900pt average_veg month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnCanola900 lnCanola900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnCanola900 lnCanola900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.11.Nosema and Sorghum****
****Percentages****
*Model 1*
reg lnnosema persorghum persorghumpt month month2 i.year i.region
reg lnmites1 persorghum persorghumpt month month2 i.year i.region
**Model 2
reg lnnosema persorghum persorghumpt pernatural month month2 i.year i.region
reg lnmites1 persorghum persorghumpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema persorghum persorghumpt pernaturalbt month month2 i.year i.region
reg lnmites1 persorghum persorghumpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema persorghum persorghumpt natural_ndvi month month2 i.year i.region
reg lnmites1 persorghum persorghumpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema persorghum persorghumpt average_veg month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema persorghum persorghumpt ndvi_bloom month month2 i.year i.region
reg lnmites1 persorghum persorghumpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema persorghum persorghumpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema persorghum persorghumpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema persorghum persorghumpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema persorghum persorghumpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema persorghum persorghumpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema persorghum persorghumpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 persorghum persorghumpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnSorghum900 lnSorghum900pt month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt month month2 i.year i.region
**Model 2
reg lnnosema lnSorghum900 lnSorghum900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnSorghum900 lnSorghum900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnSorghum900 lnSorghum900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnSorghum900 lnSorghum900pt average_veg month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnSorghum900 lnSorghum900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnSorghum900 lnSorghum900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.12.Nosema and Rice****
****Percentages****
*Model 1*
reg lnnosema perrice perricept month month2 i.year i.region
reg lnmites1 perrice perricept month month2 i.year i.region
**Model 2
reg lnnosema perrice perricept pernatural month month2 i.year i.region
reg lnmites1 perrice perricept pernatural month month2 i.year i.region
**Model 3
reg lnnosema perrice perricept pernaturalbt month month2 i.year i.region
reg lnmites1 perrice perricept pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema perrice perricept natural_ndvi month month2 i.year i.region
reg lnmites1 perrice perricept natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema perrice perricept average_veg month month2 i.year i.region
reg lnmites1 perrice perricept average_veg month month2 i.year i.region
**Model 6
reg lnnosema perrice perricept ndvi_bloom month month2 i.year i.region
reg lnmites1 perrice perricept ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema perrice perricept average_mintemp average_precip month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema perrice perricept average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema perrice perricept average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema perrice perricept average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema perrice perricept average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema perrice perricept average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 perrice perricept average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnRice900 lnRice900pt month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt month month2 i.year i.region
**Model 2
reg lnnosema lnRice900 lnRice900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnRice900 lnRice900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnRice900 lnRice900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnRice900 lnRice900pt average_veg month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnRice900 lnRice900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnRice900 lnRice900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnRice900 lnRice900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region


*****Table C.13.Nosema and Barley****
****Percentages****
*Model 1*
reg lnnosema perbarley perbarleypt month month2 i.year i.region
reg lnmites1 perbarley perbarleypt month month2 i.year i.region
**Model 2
reg lnnosema perbarley perbarleypt pernatural month month2 i.year i.region
reg lnmites1 perbarley perbarleypt pernatural month month2 i.year i.region
**Model 3
reg lnnosema perbarley perbarleypt pernaturalbt month month2 i.year i.region
reg lnmites1 perbarley perbarleypt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema perbarley perbarleypt natural_ndvi month month2 i.year i.region
reg lnmites1 perbarley perbarleypt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema perbarley perbarleypt average_veg month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_veg month month2 i.year i.region
**Model 6
reg lnnosema perbarley perbarleypt ndvi_bloom month month2 i.year i.region
reg lnmites1 perbarley perbarleypt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema perbarley perbarleypt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema perbarley perbarleypt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema perbarley perbarleypt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema perbarley perbarleypt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema perbarley perbarleypt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema perbarley perbarleypt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 perbarley perbarleypt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnBarleyall900 lnBarleyall900pt month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt month month2 i.year i.region
**Model 2
reg lnnosema lnBarleyall900 lnBarleyall900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnBarleyall900 lnBarleyall900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnBarleyall900 lnBarleyall900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnBarleyall900 lnBarleyall900pt average_veg month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnBarleyall900 lnBarleyall900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnBarleyall900 lnBarleyall900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region


*****Table C.14.Nosema and Spring Wheat****
****Percentages****
*Model 1*
reg lnnosema perspringwht perspringwhtpt month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt month month2 i.year i.region
**Model 2
reg lnnosema perspringwht perspringwhtpt pernatural month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema perspringwht perspringwhtpt pernaturalbt month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema perspringwht perspringwhtpt natural_ndvi month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema perspringwht perspringwhtpt average_veg month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema perspringwht perspringwhtpt ndvi_bloom month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema perspringwht perspringwhtpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 perspringwht perspringwhtpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnSpringwht900 lnSpringwht900pt month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt month month2 i.year i.region
**Model 2
reg lnnosema lnSpringwht900 lnSpringwht900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnSpringwht900 lnSpringwht900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnSpringwht900 lnSpringwht900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnSpringwht900 lnSpringwht900pt average_veg month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnSpringwht900 lnSpringwht900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnSpringwht900 lnSpringwht900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Table C.15.Nosema and Winter Wheat****
****Percentages****
*Model 1*
reg lnnosema perwinwht perwinwhtpt month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt month month2 i.year i.region
**Model 2
reg lnnosema perwinwht perwinwhtpt pernatural month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt pernatural month month2 i.year i.region
**Model 3
reg lnnosema perwinwht perwinwhtpt pernaturalbt month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt pernaturalbt month month2 i.year i.region
**Model 4
reg lnnosema perwinwht perwinwhtpt natural_ndvi month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt natural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema perwinwht perwinwhtpt average_veg month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_veg month month2 i.year i.region
**Model 6
reg lnnosema perwinwht perwinwhtpt ndvi_bloom month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt ndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema perwinwht perwinwhtpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 perwinwht perwinwhtpt average_mintemp average_precip ndvi_bloom month month2 i.year i.region
****Natural Logs****
*Model 1
reg lnnosema lnWinterwht900 lnWinterwht900pt month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt month month2 i.year i.region
**Model 2
reg lnnosema lnWinterwht900 lnWinterwht900pt lnNatural900 month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt lnNatural900 month month2 i.year i.region
**Model 3
reg lnnosema lnWinterwht900 lnWinterwht900pt lnNaturalbt month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt lnNaturalbt month month2 i.year i.region
**Model 4
reg lnnosema lnWinterwht900 lnWinterwht900pt lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt lnNatural_ndvi month month2 i.year i.region
**Model 5
reg lnnosema lnWinterwht900 lnWinterwht900pt average_veg month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_veg month month2 i.year i.region
**Model 6
reg lnnosema lnWinterwht900 lnWinterwht900pt lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt lnndvi_bloom month month2 i.year i.region
**Model 7
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip month month2 i.year i.region
**Model 8
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg lnnosema lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg lnmites1 lnWinterwht900 lnWinterwht900pt average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

***Simple Crop Model***

reg lnnosema neonic_crop neonic_crop_plant neonic_crop_bloom month month2 i.year i.region
reg lnmites1 neonic_crop neonic_crop_plant neonic_crop_bloom month month2 i.year i.region
*********Corn******
reg lnnosema percorn percornpt percornbt month month2 i.year i.region
reg lnmites1 percorn percornpt percornbt month month2 i.year i.region
gen lnCornall900bt=lnCornall900 if cornbt==1
replace lnCornall900bt=0 if (missing(lnCornall900bt)&percorn>=0)
reg lnnosema lnCornall900 lnCornall900pt lnCornall900bt month month2 i.year i.region
reg lnmites1 lnCornall900 lnCornall900pt lnCornall900bt month month2 i.year i.region
**********Cotton*******
reg lnnosema percotton percottonpt percottonbt month month2 i.year i.region
reg lnmites1 percotton percottonpt percottonbt month month2 i.year i.region
gen lnCottonall900bt=lnCottonall900 if cottonbt==1
replace lnCottonall900bt=0 if (missing(lnCottonall900bt)&percorn>=0)
reg lnnosema lnCottonall900 lnCottonall900pt lnCottonall900bt month month2 i.year i.region
reg lnmites1 lnCottonall900 lnCottonall900pt lnCottonall900bt month month2 i.year i.region
*********Sorghum******
reg lnnosema persorghum persorghumpt persorghumbt month month2 i.year i.region
reg lnmites1 persorghum persorghumpt persorghumbt month month2 i.year i.region
gen lnSorghum900bt=lnSorghum900 if sorghumbt==1
replace lnSorghum900bt=0 if (missing(lnSorghum900bt)&percorn>=0)
reg lnnosema lnSorghum900 lnSorghum900pt lnSorghum900bt month month2 i.year i.region
reg lnmites1 lnSorghum900 lnSorghum900pt lnSorghum900bt month month2 i.year i.region
********Soybean*****
reg lnnosema persoybean persoybeanpt persoybt month month2 i.year i.region
reg lnmites1 persoybean persoybeanpt persoybt month month2 i.year i.region
gen lnSoyall900bt=lnSoyall900 if soybt==1
replace lnSoyall900bt=0 if (missing(lnSoyall900bt)&percorn>=0)
reg lnnosema lnSoyall900 lnSoyall900pt lnSoyall900bt month month2 i.year i.region
reg lnmites1 lnSoyall900 lnSoyall900pt lnSoyall900bt month month2 i.year i.region
*******Canola********
reg lnnosema percanola percanolapt percanolabt month month2 i.year i.region
reg lnmites1 percanola percanolapt percanolabt month month2 i.year i.region
gen lnCanola900bt=lnCanola900 if canolabt==1
replace lnCanola900bt=0 if (missing(lnCanola900bt)&percorn>=0)
reg lnnosema lnCanola900 lnCanola900pt lnCanola900bt month month2 i.year i.region
reg lnmites1 lnCanola900 lnCanola900pt lnCanola900bt month month2 i.year i.region

*******Threshold Models
gen nosemathresh=1 if nosema>=1
gen mitesthresh=1 if mites>=3
replace nosemathresh=0 if (missing(nosemathresh)&nosema>=0)
replace mitesthresh=0 if (missing(mitesthresh)&mites>=0)

*Model 1
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region
**Model 2
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region
**Model 3
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region
**Model 4
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region
**Model 5
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region
**Model 6
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region
**Model 7
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region
**Model 8
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg nosemathresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg mitesthresh percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region

*********Natural Log*********
*Model 1
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region
**Model 2
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region
**Model 3
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region
**Model 4
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region
**Model 5
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region
**Model 6
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region
**Model 7
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region
**Model 8
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg nosemathresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region

*****Robustness Checks****
drop nosema_d
gen nosema_d=1 if (nosema>0&!missing(nosema))
replace nosema_d=0 if ((nosema==0)&!missing(nosema))

*Model 1
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht month month2 i.year i.region
**Model 2
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernatural month month2 i.year i.region
**Model 3
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht pernaturalbt month month2 i.year i.region
**Model 4
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht natural_ndvi month month2 i.year i.region
**Model 5
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_veg month month2 i.year i.region
**Model 6
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht ndvi_bloom month month2 i.year i.region
**Model 7
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip month month2 i.year i.region
**Model 8
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernatural month month2 i.year i.region
**Model 9
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip pernaturalbt month month2 i.year i.region
**Model 10
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip natural_ndvi month month2 i.year i.region
**Model 11
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg nosema_d percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region
reg lnmites1 percorn persoybean percotton percanola persorghum perrice perbarley perspringwht perwinwht average_mintemp average_precip ndvi_bloom month month2 i.year i.region

*********Natural Log*********
*Model 1
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 month month2 i.year i.region
**Model 2
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural900 month month2 i.year i.region
**Model 3
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNaturalbt month month2 i.year i.region
**Model 4
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnNatural_ndvi month month2 i.year i.region
**Model 5
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_veg month month2 i.year i.region
**Model 6
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 lnndvi_bloom month month2 i.year i.region
**Model 7
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip month month2 i.year i.region
**Model 8
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural900 month month2 i.year i.region
**Model 9
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNaturalbt month month2 i.year i.region
**Model 10
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnNatural_ndvi month month2 i.year i.region
**Model 11
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip average_veg month month2 i.year i.region
**Model 12
reg nosema_d lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region
reg mitesthresh lnCornall900 lnSoyall900 lnCottonall900 lnCanola900 lnSorghum900 lnRice900 lnBarleyall900 lnSpringwht900 lnWinterwht900 average_mintemp average_precip lnndvi_bloom month month2 i.year i.region



******Two Stage Regressions****
gen neonic_crop=percorn+persoybean+percotton+percanola+persorghum+perrice+perbarley+perspringwht+perwinwht 
replace neonic_crop=0 if missing(neonic_crop)
gen neonicplant=1 if (plantcorn==1|plantcotton==1|plantsoy==1|plantsorghum==1|plantrice==1|plantcanola==1|plantspringwht==1|plantwinwht==1)
replace neonicplant=0 if missing(neonicplant)
gen neonic_crop_plant=percornpt+persoybeanpt+percottonpt+percanolapt+persorghumpt+perricept+perbarleypt+perspringwhtpt+perwinwhtpt
replace neonic_crop_plant=0 if missing(neonic_crop_plant)
gen persoybt=persoybean*soybt
replace persoybt=0 if missing(persoybt)
gen percottonbt=percotton*cottonbt
replace percottonbt=0 if missing(percottonbt)
gen persorghumbt=persorghum*sorghumbt
replace persorghumbt=0 if missing(persorghumbt)
gen percanolabt=percanola*canolabt
replace percanolabt=0 if missing(percanolabt)
gen neonic_crop_bloom=percornbt+persoybt+percottonbt+percanolabt+persorghumbt
replace neonic_crop_bloom=0 if missing(neonic_crop_bloom)

***With Planting time***
**Only crop and planting time
reg neonics neonic_crop neonicplant neonic_crop_plant month month_2
predict yhat1, xb
reg neonics neonic_crop neonicplant neonic_crop_plant month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant month month_2
logit neonics neonic_crop neonicplant neonic_crop_plant month month_2 i.year i.region
replace region=9 if (region==2|region==3)

**Crop, planting time and vegetation
reg neonics neonic_crop neonicplant neonic_crop_plant average_veg month month2
predict yhat2, xb
reg neonics neonic_crop neonicplant neonic_crop_plant average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant average_veg month month_2 i.year i.region

**Crop, planting time, vegetation and temp
reg neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_veg month month_2
predict yhat3, xb
reg neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_veg month month_2 i.year i.region

**Crop, planting time, vegetation and precip
reg neonics neonic_crop neonicplant neonic_crop_plant average_precip average_veg month month_2
predict yhat4, xb
reg neonics neonic_crop neonicplant neonic_crop_plant average_precip average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant average_precip average_veg month month_2 i.year i.region

**Crop, planting time, vegetation, temp and precip
reg neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_precip average_veg month month_2
predict yhat5, xb
reg neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_precip average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant average_mintemp average_precip average_veg month month_2 i.year i.region

***With planting and bloom times***

**Crop, planting time, bloom time
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom month month_2
predict yhat6, xb
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom month month2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom month month_2
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom month month_2 i.year i.region

**Crop, planting time, bloom time, vegetation
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_veg month month_2
predict yhat7, xb
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_veg month month_2 i.year i.region

**Crop, planting time, bloom time, vegetation, temp
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_mintemp average_veg month month_2
predict yhat8, xb
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_mintemp average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_mintemp average_veg month month_2 i.year i.region

**Crop, planting time, bloom time, vegeation, precip
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_precip average_veg month month_2
predict yhat9, xb
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_precip average_veg month month_2 i.year i.region
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_precip average_veg month month_2 i.year i.region

**Crop, planting time, bloom time, vegetation, temp, precip
reg neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_mintemp average_precip average_veg month month_2 i.year i.region
predict yhat10, xb
logit neonics neonic_crop neonicplant neonic_crop_plant neonicbloom neonic_crop_bloom average_mintemp average_precip average_veg month month_2 i.year i.region

***Threshold level models
replace lnndvi=ln(average_veg)

reg nosemathresh neonics month month_2 
reg nosemathresh neonics average_veg month month_2
reg nosemathresh neonics average_mintemp average_veg month month_2 
reg nosemathresh neonics average_precip average_veg month month_2 
reg nosemathresh neonics average_mintemp average_precip average_veg month month_2 
reg nosemathresh neonics month month_2 i.year i.region
reg nosemathresh neonics average_veg month month_2 i.year i.region
reg nosemathresh neonics average_mintemp average_veg month month_2 i.year i.region
reg nosemathresh neonics average_precip average_veg month month_2 i.year i.region
reg nosemathresh neonics average_mintemp average_precip average_veg month month_2 i.year i.region
logit nosemathresh neonics month month_2
logit nosemathresh neonics month month_2 i.year i.region
logit nosemathresh neonics average_veg month month_2 i.year i.region
logit nosemathresh neonics average_precip average_veg month month_2 i.year i.region
logit nosemathresh neonics average_mintemp average_precip average_veg month month_2 i.year i.region

replace region=8 if (region==4|region==5)

reg mitesthresh neonics month month_2
reg mitesthresh neonics average_veg month month2
reg mitesthresh neonics average_mintemp average_veg month month_2
reg mitesthresh neonics average_precip average_veg month month_2 
reg mitesthresh neonics average_mintemp average_precip average_veg month month_2
reg mitesthresh neonics month month_2 i.year i.region
reg mitesthresh neonics average_veg month month_2 i.year i.region
reg mitesthresh neonics average_mintemp average_veg month month_2 i.year i.region
reg mitesthresh neonics average_precip average_veg month month_2 i.year i.region
reg mitesthresh neonics average_mintemp average_precip average_veg month month_2 i.year i.region

logit mitesthresh neonics month month_2
logit mitesthresh neonics month month_2 i.year i.region
logit mitesthresh neonics average_veg month month_2 i.year i.region
logit mitesthresh neonics average_mintemp average_veg month month_2 i.year i.region
logit mitesthresh neonics average_precip average_veg month month2 i.year i.region
logit mitesthresh neonics average_mintemp average_precip average_veg month month_2 i.year i.region

replace month=13 if (month==1|month==2)

***Loads Models
tobit nosema neonics month month_2, ll(0)
tobit nosema neonics month month_2 i.year i.region, ll(0)
tobit nosema neonics average_mintemp average_veg month month_2 i.year i.region, ll(0)
tobit nosema neonics average_mintemp average_precip average_veg month month_2 i.year i.region, ll(0)
sum nosema if nosema>0

reg mites neonics month month_2 
reg mites neonics month month_2 i.year i.region
reg mites neonics average_veg month month_2 i.year i.region
reg mites neonics average_mintemp average_veg month month_2 i.year i.region
reg mites neonics average_precip average_veg month month_2 i.year i.region
reg mites neonics average_mintemp average_precip average_veg month month_2 i.year i.region

reg nosema neonics month month_2
reg nosema neonics month month_2 i.year i.region
reg nosema neonics average_veg month month_2 i.year i.region
reg nosema neonics average_mintemp average_veg month month_2 i.year i.region
reg nosema neonics average_precip average_veg month month_2 i.year i.region
reg nosema neonics average_mintemp average_precip average_veg month month_2 i.year i.region


***Natural Log forms
reg lnnosema neonics month month_2 
reg lnnosema neonics average_veg month month_2 
reg lnnosema neonics average_mintemp average_veg month month_2 
reg lnnosema neonics average_precip average_veg month month_2 
reg lnnosema neonics average_mintemp average_precip average_veg month month_2 
reg lnnosema neonics month month_2 i.year i.region
reg lnnosema neonics average_veg month month_2 i.year i.region
reg lnnosema neonics average_mintemp average_veg month month_2 i.year i.region
reg lnnosema neonics average_precip average_veg month month_2 i.year i.region
reg lnnosema neonics average_mintemp average_precip average_veg month month_2 i.year i.region

reg lnnosema1 neonics month month_2
reg lnnosema1 neonics month month_2 i.year i.region
reg lnnosema1 neonics average_veg month month_2 i.year i.region
reg lnnosema1 neonics average_mintemp average_veg month month_2 i.year i.region
reg lnnosema1 neonics average_precip average_veg month month_2 i.year i.region
reg lnnosema1 neonics average_mintemp average_precip average_veg month month_2 i.year i.region

tobit lnnosema1 neonics month month_2, ll(0)
tobit lnnosema1 neonics month month_2 i.year i.region, ll(0)
tobit lnnosema1 neonics average_mintemp average_veg month month_2 i.year i.region, ll(0)
tobit lnnosema1 neonics average_mintemp average_precip average_veg month month_2 i.year i.region, ll(0)

reg lnmites1 neonics month month_2 
reg lnmites1 neonics average_veg month month_2 
reg lnmites1 neonics average_mintemp average_veg month month_2 
reg lnmites1 neonics average_precip average_veg month month_2 
reg lnmites1 neonics average_mintemp average_precip average_veg month month_2
reg lnmites1 neonics month month_2 i.year i.region
reg lnmites1 neonics average_veg month month_2 i.year i.region
reg lnmites1 neonics average_mintemp average_veg month month_2 i.year i.region
reg lnmites1 neonics average_precip average_veg month month_2 i.year i.region
reg lnmites1 neonics average_mintemp average_precip average_veg month month_2 i.year i.region

****Predictative***
reg nosemathresh yhat1 month month_2 
reg nosemathresh yhat2 average_veg month month_2 
reg nosemathresh yhat3 average_mintemp average_veg month month_2 
reg nosemathresh yhat4 average_precip average_veg month month_2
reg nosemathresh yhat5 average_mintemp average_precip average_veg month month_2
reg nosemathresh yhat6 month month_2 
reg nosemathresh yhat7 average_veg month month_2
reg nosemathresh yhat8 average_mintemp average_veg month month_2 
reg nosemathresh yhat9 average_precip average_veg month month_2 
reg nosemathresh yhat10 average_mintemp average_precip average_veg month month_2 
reg nosemathresh yhat1 month month_2 i.year i.region
reg nosemathresh yhat2 average_veg month month_2 i.year i.region
reg nosemathresh yhat3 average_mintemp average_veg month month_2 i.year i.region
reg nosemathresh yhat4 average_precip average_veg month month_2 i.year i.region
reg nosemathresh yhat5 average_mintemp average_precip average_veg month month_2 i.year i.region
reg nosemathresh yhat6 month month_2 i.year i.region
reg nosemathresh yhat7 average_veg month month_2 i.year i.region
reg nosemathresh yhat8 average_mintemp average_veg month month_2 i.year i.region
reg nosemathresh yhat9 average_precip average_veg month month_2 i.year i.region
reg nosemathresh yhat10 average_mintemp average_precip average_veg month month_2 i.year i.region


reg mitesthresh yhat1 month month_2 
reg mitesthresh yhat2 average_veg month month_2 
reg mitesthresh yhat3 average_mintemp average_veg month month_2 
reg mitesthresh yhat4 average_precip average_veg month month_2
reg mitesthresh yhat5 average_mintemp average_precip average_veg month month_2
reg mitesthresh yhat6 month month_2 
reg mitesthresh yhat7 average_veg month month_2 
reg mitesthresh yhat8 average_mintemp average_veg month month_2 
reg mitesthresh yhat9 average_precip average_veg month month_2
reg mitesthresh yhat10 average_mintemp average_precip average_veg month month_2
reg mitesthresh yhat1 month month_2 i.year i.region
reg mitesthresh yhat2 average_veg month month_2 i.year i.region
reg mitesthresh yhat3 average_mintemp average_veg month month_2 i.year i.region
reg mitesthresh yhat4 average_precip average_veg month month_2 i.year i.region
reg mitesthresh yhat5 average_mintemp average_precip average_veg month month_2 i.year i.region
reg mitesthresh yhat6 month month_2 i.year i.region
reg mitesthresh yhat7 average_veg month month_2 i.year i.region
reg mitesthresh yhat8 average_mintemp average_veg month month_2 i.year i.region
reg mitesthresh yhat9 average_precip average_veg month month_2 i.year i.region
reg mitesthresh yhat10 average_mintemp average_precip average_veg month month_2 i.year i.region

reg lnnosema yhat1 month month_2
reg lnnosema yhat2 average_veg month month_2 
reg lnnosema yhat3 average_mintemp average_veg month month_2
reg lnnosema yhat4 average_precip average_veg month month_2 
reg lnnosema yhat5 average_mintemp average_precip average_veg month month_2
reg lnnosema yhat6 month month_2 
reg lnnosema yhat7 average_veg month month_2 
reg lnnosema yhat8 average_mintemp average_veg month month_2
reg lnnosema yhat9 average_precip average_veg month month_2
reg lnnosema yhat10 average_mintemp average_precip average_veg month month_2 
reg lnnosema yhat1 month month_2 i.year i.region
reg lnnosema yhat2 average_veg month month_2 i.year i.region
reg lnnosema yhat3 average_mintemp average_veg month month_2 i.year i.region
reg lnnosema yhat4 average_precip average_veg month month_2 i.year i.region
reg lnnosema yhat5 average_mintemp average_precip average_veg month month_2 i.year i.region
reg lnnosema yhat6 month month_2 i.year i.region
reg lnnosema yhat7 average_veg month month_2 i.year i.region
reg lnnosema yhat8 average_mintemp average_veg month month_2 i.year i.region
reg lnnosema yhat9 average_precip average_veg month month_2 i.year i.region
reg lnnosema yhat10 average_mintemp average_precip average_veg month month_2 i.year i.region

reg lnmites1 yhat1 month month_2
reg lnmites1 yhat2 average_veg month month_2 
reg lnmites1 yhat3 average_mintemp average_veg month month_2 
reg lnmites1 yhat4 average_precip average_veg month month_2 
reg lnmites1 yhat5 average_mintemp average_precip average_veg month month_2 
reg lnmites1 yhat6 month month_2
reg lnmites1 yhat7 average_veg month month_2 
reg lnmites1 yhat8 average_mintemp average_veg month month_2 
reg lnmites1 yhat9 average_precip average_veg month month_2 
reg lnmites1 yhat10 average_mintemp average_precip average_veg month month_2 
reg lnmites1 yhat1 month month_2 i.year i.region
reg lnmites1 yhat2 average_veg month month_2 i.year i.region
reg lnmites1 yhat3 average_mintemp average_veg month month_2 i.year i.region
reg lnmites1 yhat4 average_precip average_veg month month_2 i.year i.region
reg lnmites1 yhat5 average_mintemp average_precip average_veg month month_2 i.year i.region
reg lnmites1 yhat6 month month_2 i.year i.region
reg lnmites1 yhat7 average_veg month month_2 i.year i.region
reg lnmites1 yhat8 average_mintemp average_veg month month_2 i.year i.region
reg lnmites1 yhat9 average_precip average_veg month month_2 i.year i.region
reg lnmites1 yhat10 average_mintemp average_precip average_veg month month_2 i.year i.region


reg nosema_d yhat1 month month_2
reg nosema_d yhat2 average_veg month month_2 
reg nosema_d yhat3 average_mintemp average_veg month month_2 
reg nosema_d yhat4 average_precip average_veg month month_2 
reg nosema_d yhat5 average_mintemp average_precip average_veg month month_2
reg nosema_d yhat6 month month_2
reg nosema_d yhat7 average_veg month month_2
reg nosema_d yhat8 average_mintemp average_veg month month_2
reg nosema_d yhat9 average_precip average_veg month month_2
reg nosema_d yhat10 average_mintemp average_precip average_veg month month_2 
reg nosema_d yhat1 month month_2 i.year i.region
reg nosema_d yhat2 average_veg month month_2 i.year i.region
reg nosema_d yhat3 average_mintemp average_veg month month_2 i.year i.region
reg nosema_d yhat4 average_precip average_veg month month_2 i.year i.region
reg nosema_d yhat5 average_mintemp average_precip average_veg month month_2 i.year i.region
reg nosema_d yhat6 month month_2 i.year i.region
reg nosema_d yhat7 average_veg month month_2 i.year i.region
reg nosema_d yhat8 average_mintemp average_veg month month_2 i.year i.region
reg nosema_d yhat9 average_precip average_veg month month_2 i.year i.region
reg nosema_d yhat10 average_mintemp average_precip average_veg month month_2 i.year i.region

