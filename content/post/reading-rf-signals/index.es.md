---
title: "Mando de Parking: Parte 1"
description: "Descifrando los Secretos de la Comunicación por RF: Cómo Aprendí a Leer Señales de RF"
slug: leyendo-senales-rf
date: 2023-09-16
image: cover.png
categories:
    - Mando de Parking
tags:
    - radiofrequencia
    - modulación
---
Durante la vida cotidiana, a menudo nos encontramos con desafíos únicos que despiertan nuestra curiosidad y nos impulsan a explorar el mundo de la tecnología. Recientemente, me enfrenté a uno de estos enigmas: una creciente colección de mandos de garaje que abarrotaban mi vida, cada uno diseñado para uno o, como máximo, dos puertas de garaje. La cantidad de estos mandos se volvió inmanejable, lo que me llevó a embarcarme en una ambiciosa aventura. ¿Mi objetivo? Descifrar el funcionamiento interno de estos dispositivos y crear una solución versátil capaz de abrir hasta seis puertas de garaje distintas.

Esta cautivadora aventura me llevó a través de varias áreas emocionantes, que abarcan no solo las complejidades de las comunicaciones por RF (Radio Frecuencia), sino también el diseño de circuitos, la optimización de baterías y el arte de la comunicación a bajo nivel entre circuitos integrados.

A lo largo de esta serie de artículos, profundizaremos en estos cinco segmentos distintos pero interconectados:

* **Comprender cómo funcionan las comunicaciones por RF.** *(Este artículo)*
* **Elaboración del diseño inicial del mando a distancia como prueba de concepto.** *(Próximamente)*
* **Abriendo mis puertas de garaje.** *(Próximamente)*
* **Optimización del diseño para lograr la máxima compacidad.** *(Próximamente)*
* **Guiándote a través del proceso de construir tu propio mando a distancia multi-puertas.** *(Próximamente)*

Juntos, desentrañaremos los misterios de la tecnología de control remoto y exploraremos la electrónica moderna.

## El viaje comienza: Visualizando señales de RF
Mi proyecto comenzó con la adquisición de una herramienta modesta pero potente: un 'dongle' SDR (Radio Definida por Software). En el pasado, explorar las profundidades de las señales de RF requería equipos costosos, pero hoy en día, los 'dongles' SDR proporcionan un medio asequible para visualizar y analizar estas señales en tiempo real. La esencia de todo esto es el algoritmo FFT (Transformada Rápida de Fourier), que descompone las señales recibidas en sus frecuencias constituyentes, lo que nos permite descifrar las técnicas de modulación.

Para aprender más sobre el algoritmo FFT, te recomiendo los siguientes dos videos:
* [La Historia Sorprendente Detrás del Algoritmo Más Importante de Todos los Tiempos](https://www.youtube.com/watch?v=nmgFG7PUHfo) de Veritasium, donde se discute la historia y la importancia de este algoritmo.
* [Pero, ¿qué es la Transformada de Fourier? Una introducción visual.](https://www.youtube.com/watch?v=spUNpyF58BY) de 3Blue1Brown, útil para comprender lo que está sucediendo en el fondo.

La siguiente imagen muestra cómo el FFT representa las señales en el dominio de la frecuencia:

![Visualización del algoritmo FFT](images/reading-rf-signals/fft.png)

## Demodulación de las señales
Finalmente pude ver el FFT en el software SDR Sharp, pero no sabía cómo extraer la información de allí, esto se debe a que las señales están moduladas y se debe elegir la técnica de demodulación adecuada para extraer la información. Pero antes de sumergirnos en la demodulación, es esencial entender qué es la modulación.

### ¿Por qué usar modulación?
Cuando transmitimos información como radiación electromagnética, enviarla tal cual no es práctico por varias razones:

* No todas las ondas se propagan eficazmente en todos los medios.
* El tamaño óptimo de la antena varía según la onda.
* A menudo queremos enviar múltiples flujos sin interferencias.

Para optimizar la transferencia de información, utilizamos la modulación. Mezclamos nuestra información con ondas portadoras: señales ideales para viajar con la mínima interferencia a través de diversos medios como el aire, cables o fibras ópticas. La onda resultante hereda las características de la onda portadora.

El siguiente gráfico muestra los diferentes tipos de modulación de señal, según el tipo de datos a enviar y el tipo de onda portadora utilizada:
![Tipos de Modulación](images/reading-rf-signals/modulations.jpg)

### Ejemplo de aplicación de modulación
Por ejemplo, consideremos la transmisión de audio. Enviar directamente la señal analógica de un micrófono sin modulación plantea desafíos:

* Requeriría una antena extremadamente grande o una fuente de energía extremadamente potente.
* Varios flujos de audio interferirían entre sí.

Para superar esto, recurrimos a la modulación. Mirando el gráfico, queremos una señal portadora analógica, porque esas se propagan mejor en el aire. Y debemos buscar en la categoría de 'datos analógicos', porque la señal que proviene de nuestro micrófono es analógica. A partir de aquí, podemos elegir AM, FM o PM. Elegiremos AM porque es sencillo y adecuado para comprender más adelante cómo funcionan los mandos a distancia.

La siguiente ilustración muestra cómo se vería nuestro experimento usando AM:
![Tipos de Modulación](images/reading-rf-signals/am-transmission.gif)

### Demodulación con SDR Sharp
SDR Sharp te permite demodular señales en tiempo real y escuchar la salida demodulada, siempre que esté dentro del rango de audición humana. Además, puedes exportar estas señales demoduladas como archivos .wav para un análisis detallado utilizando herramientas como Audacity.

Como ejemplo práctico, sintonicemos una emisora de radio local.
#### Paso 1: Navegar por el espectro RF y elegir una emisora
El primer paso es buscar emisoras dentro de la vista FFT. En mi región, las emisoras de FM suelen estar en el rango de frecuencia entre aproximadamente 87.5 MHz y 108 MHz. En algún lugar de este rango, encontré cuatro transmisiones distintas, cada una representando una emisora de radio diferente. Para sintonizar una de ellas, seleccioné su rango de frecuencia específico.

#### Paso 2: Determinando la modulación
Una vez seleccionada la emisora de radio deseada, al principio solo escuché ruido, simplemente porque no se había aplicado la técnica de demodulación correcta. A diferencia de nuestro experimento anterior, donde en el gráfico FFT mostraría una sola frecuencia, estas emisoras de radio revelaban un patrón más intrincado de frecuencias que variaban de forma independiente, una característica distintiva de la modulación FM. Reconociendo esto, cambié rápidamente a la demodulación WFM, el tipo de FM utilizado por las emisoras de radio. Finalmente, pude disfrutar de la emisora de radio local con una claridad cristalina.

#### La Belleza de Ondas Portadoras Distintas:
Como observarás, estas emisoras transmiten su audio en ondas portadoras distintas, lo que les permite transmitir varias corrientes de audio simultáneamente. Gracias a la modulación, pude disfrutar de jazz relajante, mientras que simultáneamente, un adolescente podía disfrutar de su *reggaeton* preferido y estridente en la emisora "de al lado".

{{<video  src="WFM.mp4" controls="yes" >}}

Por cierto, he mostrado estaciones de FM porque, a pesar de mis esfuerzos, no he podido detectar ninguna estación de AM similar a las que imaginamos en nuestro experimento anterior. Esta limitación probablemente se debe a las restricciones de mi equipo: un 'dongle' económico.

## Modulación ASK
En Europa, la automatización de consumo se comunica predominantemente a través de la modulación ASK (Amplitude Shift Keying) con una onda portadora de 433.92 MHz. El ASK es similar a la AM que discutimos anteriormente, pero en lugar de una señal analógica, enciende y apaga la onda portadora según un valor binario.

La siguiente imagen muestra cómo funciona la modulación ASK:
![Modulación ASK](images/reading-rf-signals/ask.png)

Imagina que queremos enviar una secuencia de 8 ceros (00000000). Si lo moduláramos directamente como ASK, se traduciría en un completo silencio de radio. Como puedes imaginar, un receptor tendría dificultades para entender que este silencio significa 8 ceros sin un reloj compartido. Por eso, la modulación ASK requiere codificación, traduciendo bits de información en secuencias que facilitan la recuperación del reloj en el extremo del receptor. Por ejemplo, cada 1 podría traducirse como '110', y cada 0 como '100'.

## Mis mandos a distancia
Utilizando los conceptos que se mostraron anteriormente, pude comenzar la ingeniería inversa de mis mandos a distancia. Para cada uno de ellos, presioné sus botones y esperé ver un pico en la vista FFT. Si hubiera visto más de un pico separado para alguno de los mandos, significaría que están utilizando la más compleja FSK. Afortunadamente, ninguno de ellos lo hizo, lo que significa que todos utilizan ASK (puedo descartar PSK o QAM porque son mandos de consumo económicos).

En esta imagen, puedes ver cómo se ve un mando a distancia en SDR Sharp. Si configuramos la demodulación en 'AM', escucharemos las variaciones en la amplitud.
![Señal de mi mando a distancia](images/reading-rf-signals/sdr_ask.png)
En esta otra imagen, puedes ver cómo se ve la grabación .wav en Audacity. Finalmente, se puede observar la información binaria enviada por el mando a distancia.
![Señal de mi mando a distancia](images/reading-rf-signals/audacity.png)

Tres de los cuatro mandos que tengo utilizan una onda portadora de 433.92 MHz. Sin embargo, uno de los mandos, debido a su antigüedad, utiliza 280 MHz, una frecuencia que las regulaciones legales desde entonces han restringido a los aficionados.

> Un dato curioso: en el pasado, los operadores de telegrafía profesionales se referían a los aficionados como 'ham-fisted' (manos torpes) debido a su tendencia a cometer errores en sus mensajes. Esto finalmente ha llevado a que las bandas de frecuencia donde los aficionados tienen permiso legal para operar se denominen 'Ham-Bands' (Bandas de jamón).

A pesar de los desafíos, sigo decidido a explorar el territorio inexplorado de la puerta de 280 MHz. Mantente atento para actualizaciones sobre esta intrigante búsqueda.

## Conclusión
Y con eso, concluimos nuestro viaje inicial al intrigante mundo de las señales de RF y su modulación/demodulación. Estos conocimientos sientan las bases para nuestras próximas aventuras. En los próximos artículos, aprovecharemos este conocimiento para crear nuestro propio mando a distancia de garaje multi-puertas, brindando una demostración práctica de los conceptos que hemos discutido. Así que mantente atento a la próxima entrega, donde nos sumergiremos de lleno en el diseño de la primera prueba de concepto de un mando a distancia.