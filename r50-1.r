# Něco  našel, cítím to. Ale stále mi cosi chybí, jakási konstanta či snad parametr lepší.
#
# Dvakráte jsem tajnou zprávu zkoumal, ale k ničemu to nevedlo. Kéž bych měl sílu tisíckrát se ni podívat.   
# A kvardrátem ji poté učinit, to by bylo!
#
# Ale jak? Cítím, že již jsem na stopě, jen času nezbývá
#
# Zkusím rychle napsat, cojsem doposud vyzkoušel. Snad jiný, lepší a věkem protřelý přijde a dílo mé dokončí. 
# Mně již čas vypršel, kroky v písku se blíží. Příboj zlověstně šumí. Musím jít ... 

#Nejprve stáheme tajná data
install.packages("curl")
library(curl)
curl_download("https://github.com/jiristepan/r50/blob/master/message.rda?raw=true", destfile="message.rda" )
load(file = "message.rda")

#a teď je zkusíme vykreslit.
plot(1, type="n", xlim=c(0, 400), ylim=c(0, 400))
rasterImage(hidenmessage * 2 ,
            xleft = 350, 
            ybottom = 50, 
            xright = 360, 
            ytop  = 400,
            angle = 45)

#karamba! Co to znamená???????


