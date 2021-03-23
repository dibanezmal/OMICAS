---
title: "                             DEBATE 1"
author: "Dani Ibañez"
date: "1/3/2021"
output:
  html_document: default
  word_document: default
---

```{r setup, include=FALSE, echo=FALSE, out.width = "300px", out.height="200px",fig.align='center'}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, eval = TRUE, warning = FALSE, comment=NA)

```
<br>

### PREGUNTA 1: Ejemplo Estudio Microarrays

<br>

#### **Título del Estudio**
  
Combined Use of Laser Capture Microdissection and cDNA Microarray Analysis Identifies Locally Expressed Disease-Related Genes in Focal Regions of Psoriasis Vulgaris Skin Lesions

<br>

#### **Tipo de Microarrays**
  
Affymetrix HGU133A 2.0

The GeneChip™ Human Genome U133A 2.0 Array is a **single array** representing **14,500 well-characterized human genes** that can be used to explore human biology and disease processes.

<br>

#### **Número de muestras y grupos**
  
Paired lesional and non-lesional samples from 7 psoriatic patients were used.
Samples from the first four patients were used in the single vs. double amplification comparison.
Samples from the remaining three patients were subjected to LCM.
NOTA: dos métodos de visualización de muestras de 7 pacientes.

<br>

#### **Objetivo del estudio** 
  
La psoriasis vulgar es una enfermedad compleja caracterizada por alteraciones en el crecimiento y diferenciación de los queratinocitos epidérmicos, así como un marcado aumento de las poblaciones de leucocitos.

En este estudio, se utiliza microdisección por captura láser (LCM) y análisis de matriz de genes para estudiar la expresión génica de las células en la epidermis y dermis lesionadas, en comparación con las regiones no lesionadas correspondientes. 

Usando este enfoque, se detectan 1800 productos génicos expresados de forma diferencial en la epidermis o dermis de las zonas con psoriasis. En concreto este estudio detectó una producción local de CCL19, una quimiocina organizadora linfoide, y su receptor CCR7 en agregados dérmicos psoriásicos, junto con la presencia de productos génicos LAMP3 / DC-LAMP y CD83, que tipifican las CD maduras.

En conclusión, los patrones de expresión génica obtenidos con LCM y análisis de microarrays junto con la detección de células T y DC mediante tinción inmune sugieren un posible mecanismo para la organización linfoide a través de CCL19 / CCR7 en la piel enferma.

<br>

#### **Enlace de datos y artículo**
  
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3352975/

Gene Expression Omnibus repository (**GSE26866**)  

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE26866

__________________________________________________________________________________________________

<br>

### PREGUNTA 2: Estudio base

<br>

#### **Introducción a Biobase**
  
Como personalmente me ha costado mucho entenderlo todo y al final creo que lo he conseguido, aunque me extienda, comparto la información que he encontrado.Disculpad si a alguien le parece obvio. A mi se me mezclaban nombres, funciones, clases, de todo.
  
La primera idea importante es que Biobase tiene las funciones para acceder, leer y escribir en un ExpressionSet. Pero lo que me costó es entender es que también incluye 3 archivos o datasets de ejemplo relacionados con microarrays. Son los siguientes: <br>
  
- aaMap
- sample.ExpressionSet
- geneData
  
Creo que cuando uno está aprendiendo los comandos y funciones R de acceso, es fácil confundir nombres de ejemplos y datos con nombres de instrucciones de R. De hecho en cualquier trabajo en R, a veces es muy útil y clarifica ideas el utilizar nombres de los datos y objetos en español para distinguirlo de los nombres de las funciones en R, siempre en inglés, especialmente cuando uno empieza a programar con paquetes nuevos.
  
En cualquier caso, lo primero es saber que hay un ExpressionSet de ejemplo en Biobase que se llama **sample.ExpressionSet**.
  
La segunda cuestión importante es el nombre **"extdata"** que aparece en varias ocasiones. Investigando he visto que **extdata** es el nombre de un directorio usado para grabar archivos descargados mediante funciones de R. Me puse a mirar qué tenía yo en mi ordenador con el nombre **extdata** y me salieron decenas de directorios con ese nombre.
  
Pues bien, de nuevo Biobase, al instalarse el paquete, genera un directorio "/Biobase/extdata/" donde guarda dos archivos TXT: <br>
  
- exprsData.txt
- pData.txt
  
Por lo tanto, este nombre "extdata" que parecía inventado, resulta ser el directorio donde se guardan unos archivos TXT incluidos en el paquete Biobase, que por otra parte, no he sabido ver dónde lo cuentan que existen. De hecho en la ayuda de Biobase diria que no los menciona.
  
Pues resulta que estos archivos TXT son los archivos planos, separados por tabuladores que se leen mediante la función **read.table()** función que en principio si que todos conocemos. La función **system.file()** simplemente busca el directorio donde se encuentran dichos archivos.

Finalmente comentar que por un lado podemos leer directamente los archivos TXT anteriores para montar el ExpressionSet, pero podemos consultarlos directamente mediante los datasets comentados anteriormente. En efecto: <br>
  
- Si cargamos **data(geneData)** estamos trabajando con el archivo **exprsData.txt**
- Si cargamos **data(sample.ExpressionSet)** estamos trabajando con los mismos datos que con **pData.txt**
  
Abordamos pues el código R para trabajar...

<br>

#### **Análisis del ejemplo incluido en Biobase**


```{r Part1.1: installing and loading packages}
#if (!require("BiocManager"))
# + install.packages("BiocManager")
# BiocManager::install("Biobase","methods")

library(Biobase)
library(knitr)


# Extraemos los datos del archivo exprsData.txt en la matriz exprs


Directorio_txt <- system.file("extdata", package="Biobase")
exprsFile <- file.path(Directorio_txt, "exprsData.txt")
exprs <- as.matrix(read.table(exprsFile, header = TRUE, sep = "\t", row.names = 1, as.is=TRUE))


# Extraemos los datos del archivo pData.txt en la tabla pData


FenoMuestras <- file.path(Directorio_txt, "pData.txt")
pData <- read.table(FenoMuestras, header = TRUE, sep = "\t", row.names = 1, as.is=TRUE)


```


```{r Part1.2: Consulta de datos}

class(exprs) # exprs es un array. No entiendo porque se pasa a Array.
head(exprs,4)
colnames(exprs)
dim(exprs)

class(pData) # pData ess un dataframe
head(pData,10)
colnames(pData)
dim(pData)
str(pData)

# Las columnas de exprs son las filas de pData?

all(colnames(exprs)==rownames(pData))

``` 

   
Por otra parte podemos acceder directamente a los datos mediante la carga de geneData y sample.ExpresionSet.
   

```{r Part1.3: ejemplo acceso a los datos via data()}

data(sample.ExpressionSet)
muestras <- sample.ExpressionSet
colnames(muestras)
dim(muestras)
```

Podemos montar el archivo de descripción general del estudio:


```{r Part1.4: bloque descriptivo del experimento}


info_experimento <- new("MIAME", 
name="Dani Ibanez",
lab="laboratorio Uoc",
contact="dani@gmail.com",
title="psoriasis studies",
abstract="different gene expression in Non lesioned and lesioned skin",
url="www.psoriasis.uoc.com")

```


#### **Creación del elemento ExpressionSet a partir de los 4 bloques de datos:**


```{r Part1.5: Montar el ExpressionSet}

FenoData <- new("AnnotatedDataFrame", data=pData)
ejemploSet <- ExpressionSet(assayData = exprs, phenoData=FenoData, experimentData=info_experimento,annotation="GPL571")


```

<br>

#### **Leyendo y manipulando datos del ExpressionSet creado**

<br>

```{r Part1.6 leyendo y manipulando datos}

featureNames(ejemploSet)[1:10]
sampleNames(ejemploSet)
sampleNames (ejemploSet) <- c(1:26)
sampleNames(ejemploSet)
varLabels(ejemploSet)
varLabels(ejemploSet)[1]="sexo"
varLabels(ejemploSet)
head(exprs(ejemploSet)[,c(1,24,26)])
exprs(ejemploSet)[2,26]=9999
head(exprs(ejemploSet)[,c(1,24,26)])
```

<br>
  

### **Una propuesta gráfica como resumen de lo que es ExpressionSet**


Para finalizar, he intentado realizar un resumen gráfico de lo que es un ExpressionSet, con comentarios. Seguro que hay errores, por lo que pido que se tome como un simple ejercicio de síntesis para ser revisado, rectificado y mejorado.


```{r Part1.6: Representación gráfica de ExpressionSet,out.width = "1000px", out.height="600px"}

knitr::include_graphics("c:/MASTER/OMICAS/Estruct_Exprs2.jpg")

```

<br>
 
__________________________________________________________________________________________________

<br>
  
### PREGUNTA 3: Estudio GEOquery Package
  
<br>
  
#### **Introducción a Geoquery**


El estudio que hemos elegido en el primer apartado está basado en el microarray U133A 2.0 que se define en el paquete GPL571


Por ejemplo, yo puedo buscar para un tipo concreto de microarray, los estudios que han sido registrados. De este modo me puede servir de guia para el mio, o poder comparar otros datos que quizá enriquecen el mio. En el enlace siguiente  

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL571 

Por ejemplo, si buscamos como palabra clave "psoriasis" encontramos 8 estudios realizados con este modelo de microaarray GPL571:

GSE11903 <br>
GSE20264 <br>
**GSE26866** <br>
GSE30768 <br>
GSE31652 <br>
GSE32407 <br>
GSE42305 <br>
GSE52471 <br>

Si clicamos en nuestro estudio concreto tenemos la información básica del estudio ya plasmada en el ejercicio 1:

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE26866

Si vemos el detalle, estamos hablando de 7 pacientes pero el análisis es sobre 37 muestras distintas combinando distintos factores

Factor 1: NL y LS
Factor 2: Whole single, Whole Double, Double
Factor 3: RD, EPI, PD, ICs

El estudio no trabaja sobre todas las combinaciones. En concreto estudia el resultado de 37 muestras que dan origen a 37 archivos GSM:

(P1:P7)+(NL,LS)+Whole Double = 7x2x1 = 14 muestras <br>
(P1:P4)+(NL+LS)+Whole Single = 4x2x1 = 8 muestras <br>
(P5:P7)+(NL-RD,NL-EPI,LS-PD,LS-EPI,LS-ICp)+Double = 3x5x1 = 15 muestras <br>

Al final de la página web del estudio GSE26866 encontramos la posibilidad de descargar todos los 37 archivos GSM o seleccionar cuales de ellos nos interesan.

Sobre cada GSM podemos obtener información detallada del archivo. Por ejemplo vemos la de GSM661400:

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM661400

>Status	Public on Jan 30, 2012 <br>
>Title	1_NL_whole_Double <br>
>Sample type	RNA <br>
>Source name	1, NL, whole, Double <br>
>Organism	Homo sapiens <br>
>Characteristics	tissue: non-lesional psoriatic skin <br>
>patient: 1 <br>
>condition: **Non-Lesional** <br>
>region: **whole** <br>
>amplification: **Double** <br>
>material: block <br>
>Extracted molecule	total RNA <br>
>Extraction protocol	QIAGEN Rneasy Kit <br>
>Label	biotin <br>
>Label protocol	Affymetrix single and double amplification protocol <br>

Este archivo incluye directamente la tabla de valores obtenidos en el Array con una tabla de 22277 registros de los cuales unos pocos son de control y header.

vamos con el código del estudio:

<br>

#### **Introducción a GEOquery**

<br>
  

```{r Preparando los datos del estudio GSE26866}

library(GEOquery)
psoriasisT <- getGEO("GSE26866",GSEMatrix=TRUE) # si no se indica por defecto es TRUE

class(psoriasisT)

# Es importante ver que psoriasisT es de classe List con un solo elemento. Pueden existir estudios con varios subestudios dentro. 
# Realizamos la extracción del primer y único elemento de la lista mediante el doble corchete [[1]]

psoriasis <- psoriasisT[[1]]

class(psoriasis)

# psoriasis ya es un elemento de tipo ExpressionSet y por lo tanto ya podemos aplicar las funciones típicas de este tipo para acceder a los datos. Antes vemos todos los elementos simplemento citando el elemento:

psoriasis


```
  
#### **Estructra de datos de ExpressionSet y acceso a sus datos**
  
<br>

Al mostrar el interior del elemento psoriasis vemos que tenemos un montón de elementos a los que acceder:

```{r Accediendo a los datos del estudio GSE26866}

# Acceso a la Tabla PhenoData usando el comando pData()

# Dimensiones de la tabla pData (40 datos de información para cada una de las 37 muestras)

dim(pData(psoriasis))

# Nombres de las columnas de pData (40 columnas de información de cada muestra)

colnames(pData(psoriasis))

# Contenido de pData por ejemplo, de las 10 primeras muestras, vamos a ver por ejemplo 4 campos concretos (1,3,6 y 10)

pData(psoriasis)[1:10,c(1,3,6,10)]

# Ahora accedemos al archivo de expresión génica mediante el comando exprs(). Aquí están los datos del experimento.
# Podemos ver que son 37 muestras y 22777 registros correspondientes a niveles de expresión.

dim(exprs(psoriasis))

# Nombres de las columnas de assayData (son los 37 nombres de los archivos GSM correspondientes a las 37 muestras)

colnames(exprs(psoriasis))

# Contenido de exprs por ejemplo, de los genes (parametros) en las posiciones 1000 a 1005, vemos los valores sobre las primeras 5 muestras del SET

exprs(psoriasis)[1000:1005,1:5]

# información del microarray

annotation(psoriasis)

# Descripción del experimento 

experimentData(psoriasis)



```

