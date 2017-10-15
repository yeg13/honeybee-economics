sum fungi
tab neonics
tab neonics if migratory==0


ttest mites, by(neonics)
sum mites if neonics==1
sum mites if neonics==0

sort neonics mites
sum mites if (neonics==0&mites>=3)
sum mites if (neonics==0&mites!=0)
sum mites if (neonics==1&mites>=3)
sum mites if (neonics==1&mites!=0)

ttest nosema, by(neonics)
sum nosema if neonics==1
sum nosema if (neonics==1&nosema>=1)
sum nosema if (neonics==1&nosema!=0)
sum nosema if neonics==0
sum nosema if (neonics==0&nosema>=1)
sum nosema if (neonics==0&nosema!=0)
sort fungi nosema

ttest mites if migratory==0, by(neonics)
sum mites if (neonics==1&migratory==0)
sum mites if (neonics==1&mites>=3&migratory==0)
sum mites if (neonics==1&mites!=0&migratory==0)
sum mites if (neonics==0&mites>=3&migratory==0)
sum mites if (neonics==0&mites!=0&migratory==0)
sum mites if (neonics==0&migratory==0)

sort migratory fungi mites
ttest nosema if migratory==0, by(neonics)

sum nosema if (neonics==1&migratory==0)
sum nosema if (neonics==1&nosema>=1&migratory==0)
sum nosema if (neonics==1&nosema!=0&migratory==0)

sum nosema if (neonics==0&migratory==0)
sum nosema if (neonics==0&nosema>=1&migratory==0)
sum nosema if (neonics==0&nosema!=0&migratory==0)
sort migratory fungi nosema

tab month neonics
tab region neonics if month==1
tab region neonics if month==2
tab region neonics if month==3
tab region neonics if month==4
tab region neonics if month==5
tab region neonics if month==6
tab region neonics if month==7
tab region neonics if month==8
tab region neonics if month==9
tab region neonics if month==10
tab region fungi if month==11

tab region neonics
tab state neonics if month==1
tab state neonics if month==2
tab state neonics if month==3
tab state neonics if month==4
tab state neonics if month==5
tab state neonics if month==6
tab state neonics if month==7
tab state neonics if month==8
tab state neonics if month==9
tab state neonics if month==10
tab state neonics if month==11


sum cornall agg_develop agg_fores agg_grass soybeans agg_wetland alfalfa other_hay apple shrubland winter_wheat barren agg_orange spring_wheat if neonics==1

sum cornall agg_develop agg_fores agg_grass soybeans agg_wetland alfalfa other_hay apple shrubland winter_wheat barren agg_orange spring_wheat if neonics==0


sum cornall agg_develop agg_fores agg_grass soybeans agg_wetland alfalfa other_hay apple shrubland winter_wheat barren agg_orange spring_wheat if (neonics==1&migratory==0)

sum cornall agg_develop agg_fores agg_grass soybeans agg_wetland alfalfa other_hay apple shrubland winter_wheat barren agg_orange spring_wheat if (neonics==0&migratory==0)


ttest cornall, by(neonics)
ttest agg_develop, by(fungi)
ttest agg_forest, by(fungi)
ttest agg_grassland, by(fungi)
ttest soybeans, by(fungi)
ttest agg_wetland, by(fungi)
ttest other_hay, by(fungi)
ttest shrubland, by(fungi)
ttest alfalfa, by(fungi)
ttest winter_wheat, by(fungi)
ttest spring_wheat, by(fungi)
ttest agg_orange, by(fungi)
ttest apples, by(fungi)

sum cornall if (neonics==1&fungi==1)
tab neonics fungi

sum cornall agg_develop agg_fores agg_grass soybeans agg_wetland alfalfa other_hay apple shrubland winter_wheat barren agg_orange spring_wheat if (neonics==1&fungi==1)
