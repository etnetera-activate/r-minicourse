---
title       : R Intro
subtitle    : syntaxe, základy
author      : Jiri Stepan
job         : Etnetera
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}



---



Atomické datové typy
--------------------
- číslo `3.14` 
- celé číslo `3L`
- komplexní číslo `1+2i`
- string `"jirka"` nebo `'jirka'`
- boolean `TRUE` nebo `F`

---


```r
a <- 1 + 1
a
```

```
## [1] 2
```

```r
5 > a
```

```
## [1] TRUE
```

```r
1/0
```

```
## [1] Inf
```

```r
0/0
```

```
## [1] NaN
```


---

Vše je vektor
--------------------
Vektor má vždy všechny elementy *stejného typu*.

```r
b <- 1:6
b
```

```
## [1] 1 2 3 4 5 6
```

```r
c <- seq(10, 60, by = 10)
c
```

```
## [1] 10 20 30 40 50 60
```

```r
b + c  #per item scitani
```

```
## [1] 11 22 33 44 55 66
```


---

Vektor lze mocně subsetovat
---------------------------


```r
a <- c("a", "b", "g", "e")
a[1:2]  #seznam indexu jako rozsah
```

```
## [1] "a" "b"
```

```r
a[c(1, 4)]  #vyctem indexu
```

```
## [1] "a" "e"
```

```r
a[-3]  #vylouceni jednoho indexu
```

```
## [1] "a" "b" "e"
```


---

Logický index
-------------


```r
cond = a > "b"
cond
```

```
## [1] FALSE FALSE  TRUE  TRUE
```

```r
a[cond]  #pomoci boolen vektoru
```

```
## [1] "g" "e"
```


----

Lists
-----
* list může obsavat pojmenované elementy různého typu
* typicky se používá jako návratová struktura


```r
list(vyska = c(180, 196, 147, 165), jmeno = c("jirka", "petr", "karel", "dana"))
```

```
## $vyska
## [1] 180 196 147 165
## 
## $jmeno
## [1] "jirka" "petr"  "karel" "dana"
```


--- 
Dataframe - hlavní struktura
----------------------------

Pokud má list elementy stejné délky, snadno z něj vznikne *dataframe*, což je základní věc v Rku.


```r
data <- as.data.frame(list(vyska = c(180, 196, 147, 165), jmeno = c("jirka", 
    "petr", "karel", "dana")))
data
```

```
##   vyska jmeno
## 1   180 jirka
## 2   196  petr
## 3   147 karel
## 4   165  dana
```


---
Dovádíme s dataframes
---------------------


```r
data$vyska  #nam da vektor odpovidajici sloupci
```

```
## [1] 180 196 147 165
```

```r
data[, "vyska"]  #nam da to same
```

```
## [1] 180 196 147 165
```

```r
data[c(1, 3), ]  #prvni a treti radek
```

```
##   vyska jmeno
## 1   180 jirka
## 3   147 karel
```


---

Dovádíme s dataframes
---------------------
Podíváme se jak vypadá jako objekt a manipulujeme s atributy


```r
class(data)
```

```
## [1] "data.frame"
```

```r
summary(data)  # základní pohled na hodnoty dat
```

```
##      vyska       jmeno  
##  Min.   :147   dana :1  
##  1st Qu.:160   jirka:1  
##  Median :172   karel:1  
##  Mean   :172   petr :1  
##  3rd Qu.:184            
##  Max.   :196
```


---
Dovádíme s dataframes
---------------------
Objekt si nese i další metainformace.


```r
str(data)  #jiný pohled na strukturu objetu
```

```
## 'data.frame':	4 obs. of  2 variables:
##  $ vyska: num  180 196 147 165
##  $ jmeno: Factor w/ 4 levels "dana","jirka",..: 2 4 3 1
```

```r
attributes(data)
```

```
## $names
## [1] "vyska" "jmeno"
## 
## $row.names
## [1] 1 2 3 4
## 
## $class
## [1] "data.frame"
```


---
Odbočka - co je to ten Factor
-----------------------------

- jedná se o vektor s konečnou množinou hodnot (`levels`)
- typicky slouží pro groupování
- lze definovat explicitně pomocí `as.factor(x)`
- řada statstických metod a funkcí s ním pracuje speciálním způsobem

---


Dovádíme s dataframes
---------------------
Podíváme se jak vypadá jako objekt a manipulujeme s atributy


```r
names(data)
```

```
## [1] "vyska" "jmeno"
```

```r
names(data) <- c("sloupec1", "sloupec2")
data
```

```
##   sloupec1 sloupec2
## 1      180    jirka
## 2      196     petr
## 3      147    karel
## 4      165     dana
```


---

Pasti na Javisty
----------------
* myslete vektrorově - cyklus je většinou špatně
* `.` nemá žádný význam, je prostě částí názvu. Hojně s používá místo mezery ve funcích typu `as.numeric()` nebo `is.na()` apod.
* trochu podobný význam jako `.` v javě má `$`
* pole se indexují od jedné
* funkce vrací svoji poslední hodnotu nebo to co vyhodí funkce return()
* doporučuji [code style guide](http://4dpiecharts.com/r-code-style-guide/)

---

Ukázka kódování
---------------
Ověříme si na jednoduchém kódu, zda jsou skutečně vektorizované operace rychlejší než cykly


```r
a <- 1:1000
b <- sqrt(a)
```

vs.

```r
for (i in 1:length(a)) {
    b[i] <- sqrt(a[i])
}
```




