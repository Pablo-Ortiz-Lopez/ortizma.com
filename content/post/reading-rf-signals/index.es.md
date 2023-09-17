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
Durante la vida cotidiana, a menudo me encuentro con desafíos que despiertan mi curiosidad y me impulsan a explorar el mundo de la tecnología. Recientemente, me enfrenté a uno: una creciente colección de mandos de garaje. La cantidad de estos mandos me llevó a embarcarme en un ambicioso proyecto, para descifrar el funcionamiento interno de estos dispositivos y crear una solución versátil capaz de abrir hasta seis puertas de garaje distintas.

Este proyecto ha abarcado varias áreas, que abarcan no solo las comunicaciones por RF (Radio Frecuencia), sino también el diseño de circuitos, la optimización de baterías y el arte de la comunicación a bajo nivel entre circuitos integrados.

A lo largo de esta serie de artículos, profundizaremos en estos cinco segmentos distintos pero interconectados:

* **Comprender cómo funcionan las comunicaciones por RF.** *(Este artículo)*
* **Elaboración del diseño inicial del mando a distancia como prueba de concepto.** *(Próximamente)*
* **Abriendo mis puertas de garaje.** *(Próximamente)*
* **Optimización del diseño para lograr la máxima compacidad.** *(Próximamente)*
* **Guiándote a través del proceso de construir tu propio mando a distancia multi-puertas.** *(Próximamente)*

Juntos, exploraremos los misterios de la tecnología de control remoto y la electrónica moderna.

## Demodulación de las señales
Para comenzar a analizar las señales de radio, primero debemos entender como funcionan. 

Las leyes de la física estipulan que para enviar una onda de baja frecuencia a través de un medio no conductivo, como es el aire, se necesita una antena más grande tanto en el emisor y receptor, que para enviar y recibir una onda de mayor frecuencia. También estipulan que si enviamos 2 ondas de la misma frecuencia, estas seran imposibles de distinguir en nuestro dispositivo receptor. 

Como podréis imaginar, no es deseable utilizar antenas kilométricas en nuestros dispositivos portátiles, y también nos gustaría que varios canales de comunicación puedan utilizar el mismo medio simultáneamente. Afortunadamente, las leyes de la física no se pueden modificar, pero si las podemos utilizar a nuestro favor.

Para conseguir enviar información de forma eficiente, lo que hacemos es "esconder" nuestra información en ondas electromagnéticas que tengan las propiedades que deseamos, esto se conoce como modulación. 

### Ejemplo de aplicación de modulación
Por ejemplo, imagina que es de noche, y quieres comunicarte desde una gran distancia con un amigo tuyo. Tienes una linterna en la mano, por lo que puedes apagarla y encenderla, y enviar una serie de pulsos que tu amigo puede interpretar siguiendo un lenguaje que hayáis acordado previamente. Enhorabuena, acabas de enviar un mensaje utilizando modulación ASK, la misma que utilizan que nuestros mandos.

La siguiente imagen muestra cómo funciona la modulación ASK:
![Modulación ASK](images/reading-rf-signals/ask.png)

#### Diferencias entre los mandos y los humanos
Los humanos disponemos de 6 receptores de ondas electromagnéticas, 3 en cada uno de nuestros ojos. Estos receptores filtran físicamente un rango de frecuencias específico, por ejemplo, los receptores del color rojo filtran las ondas de entre 400THz y 480THz. Esto significa, que podríamos utilizar una linterna de color rojo, y él podría detectar los pulsos con 2 de sus 6 receptores. Si la linterna es de color blanco, la onda que emitiremos estará compuesta por una multitud de frecuencias, que activaremos sus 6 receptores. 

Las frecuencias que componen la luz visible tienen desventajas si queremos utilizarlas para controlar máquinas:
* Podrían ser molestas: Imagina que cada vez que quieres controlar la televisión tuvieses que usar un rayo de luz, podría resultar molesto si quieres ver una película a oscuras.
* Las ondas de tan alta frecuencia no son capaces de atravesar materiales sólidos con cierto grosor: Imagina que el WiFi solo funcionase si puedes ver el router.

Es por esto, que los dispositivos electrónicos habitualmente utilizan frecuencias que nuestros ojos no pueden detectar.
En Europa, los automatismos se comunican predominantemente a través de la modulación ASK (Amplitude Shift Keying) con una onda portadora de 433.92 MHz.

#### Diseñando un lenguaje para comunicarnos
Imagina que queremos enviar una secuencia de 8 ceros (00000000) a nuestro amigo. Si lo modulásemos directamente como ASK, se traduciría en completa oscuridad. Como puedes imaginar, un receptor tendría dificultades para entender que este silencio significa 8 ceros si no tiene una referencia de cuando hemos empezado a enviar, y con que velocidad enviamos pulsos. Por esta razón, para esconder un mensaje binario en una onda, primero debemos codificarlo, traduciendo bits de información en secuencias que facilitan la recuperación del reloj en el extremo del receptor. Por ejemplo, cada 1 podría traducirse como '110', y cada 0 como '100'.

## Visualizando señales de RF
Mi proyecto comenzó con la adquisición de una herramienta modesta pero potente: un 'dongle' SDR (Radio Definida por Software). Estos 'dongles' SDR descomponen las diferentes frecuencias mediante algoritmos, en lugar de filtrarlas físicamente como hacen nuestros ojos o la radio de nuestro coche. Esto nos permite visualizar y analizar estas señales en tiempo real. 

El algoritmo más esencial para conseguir esto es el algoritmo FFT (Transformada Rápida de Fourier), que descompone las señales recibidas en sus frecuencias constituyentes, lo que nos permite ver en tiempo real las técnicas de modulación. 

La belleza de la transformación de fourier, en mi opinión, es que es lo más parecido que tenemos a poder ajustar nuestros ojos para poder ver rangos de colores que resultan imposibles de imaginar para nosotros.

Para aprender más sobre el algoritmo FFT, te recomiendo los siguientes dos videos:
* [La Historia Sorprendente Detrás del Algoritmo Más Importante de Todos los Tiempos](https://www.youtube.com/watch?v=nmgFG7PUHfo) de Veritasium, donde se discute la historia y la importancia de este algoritmo.
* [Pero, ¿qué es la Transformada de Fourier? Una introducción visual.](https://www.youtube.com/watch?v=spUNpyF58BY) de 3Blue1Brown, útil para comprender lo que está sucediendo en el fondo.

No es necesario que veas los vídeos, lo más importante es que interiorices esta imágen de lo que consigue la transformación FFT:

![Visualización del algoritmo FFT](images/reading-rf-signals/fft.png)

### Demodulación con SDR Sharp
SDR Sharp te permite demodular señales en tiempo real y transforma la información extraida a impulsos de sonido para que puedas escucharla, siempre que esté dentro del rango de audición humana. Además, puedes exportar estas señales demoduladas como archivos .wav para un análisis detallado utilizando herramientas como Audacity.

## Mis mandos a distancia
Utilizando los conceptos anteriores, pude comenzar la ingeniería inversa de mis mandos a distancia. Para cada uno de ellos, presioné sus botones y esperé ver un pico en la vista FFT. Si hubiera visto más de un pico separado para alguno de los mandos, significaría que están utilizando una modulación un poco mas compleja: FSK. 

La modulación FSK consistiría en que utilizásemos una linterna verde para decir que estamos bien, y una linterna roja para decir que estamos en apuros. Afortunadamente, esto no ocurrió para ninguno de ellos, lo que significa que todos utilizan ASK (Podemos descartar otras modulaciones mas complejas como PSK o QAM porque son mandos económicos).

En esta imagen, puedes ver cómo se ve un mando a distancia en SDR Sharp. Si configuramos la demodulación en modo 'AM', escucharemos las variaciones en la amplitud.
![Señal de mi mando a distancia](images/reading-rf-signals/sdr_ask.png)
En esta otra imagen, puedes ver cómo se ve la grabación .wav en Audacity. Finalmente, se puede observar la información enviada por el mando a distancia.
![Datos de mi mando a distancia](images/reading-rf-signals/audacity.png)

Tres de los cuatro mandos que tengo utilizan una onda portadora de 433.92 MHz. Sin embargo, uno de los mandos, debido a su antigüedad, utiliza 280 MHz, una frecuencia que las regulaciones legales desde entonces han restringido a los aficionados.

> Un dato curioso: en el pasado, los operadores de telegrafía profesionales se referían a los aficionados como 'ham-fisted' (Manos de jamón) debido a su tendencia a cometer errores en sus mensajes. Esto finalmente ha llevado a que las bandas de frecuencia donde los aficionados tienen permiso legal para operar se denominen 'Ham-Bands' (Bandas de jamón).

A pesar de los desafíos, sigo decidido a explorar el territorio de la puerta de 280 MHz. Mantente atento para actualizaciones sobre esta intrigante búsqueda.

## Conclusión
Y con eso, concluimos nuestro viaje inicial al intrigante mundo de las señales de RF y su modulación/demodulación. Estos conocimientos sientan las bases para nuestras próximas aventuras. En los próximos artículos, aprovecharemos este conocimiento para crear nuestro propio mando a distancia de garaje multi-puerta, brindando una demostración práctica de los conceptos que hemos discutido. Así que mantente atento a la próxima entrega, donde nos sumergiremos de lleno en el diseño de la primera prueba de concepto.