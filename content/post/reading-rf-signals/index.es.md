---
title: "Mando de Parking: Parte 1"
description: "Descifrando los Secretos de la Comunicación por Radio: Cómo Aprendí a Leer Señales de Radio"
slug: leyendo-senales-rf
date: 2023-09-16
image: cover.png
categories:
    - Mando de Parking
tags:
    - radiofrequencia
    - modulación
---
Durante la vida cotidiana, a menudo me encuentro con desafíos que despiertan mi curiosidad y me impulsan a explorar el mundo de la tecnología. Recientemente, me enfrenté a uno: una creciente colección de mandos de parking. La cantidad de estos mandos me llevó a embarcarme en un ambicioso proyecto, para descifrar el funcionamiento interno de estos dispositivos y crear un dispositivo capaz de abrir hasta seis puertas de parking distintas.

Este proyecto ha abarcado varias áreas, no solo las comunicaciones por radio, sino también el diseño de circuitos, la optimización de baterías y el arte de la comunicación a bajo nivel entre circuitos integrados.

A lo largo de esta serie de artículos, profundizaremos en estos cinco segmentos distintos pero interconectados:

* **Entender cómo funcionan las comunicaciones por radio.** *(Este artículo)*
* **Diseñando mi primer mando a distancia.** *(Próximamente)*
* **Abriendo mis puertas de garaje.** *(Próximamente)*
* **Optimización del diseño para lograr el mínimo tamaño.** *(Próximamente)*
* **Guiándote para que puedas construir tu propio mando multi-puerta.** *(Próximamente)*

Juntos, exploraremos los misterios de la tecnología de control remoto y la electrónica moderna.

## Emitiendo señales
### Por qué utilizar modulación
Para comenzar a analizar las señales de radio, primero debemos entender como funcionan. 

Cuando era pequeño, en la piscina de mi abuela, a veces intentábamos crear una "piscina de olas" usando tablas de surf. Para conseguir esto, empujabamos arriba y abajo una tabla de surf (A mi abuela esto no le gustaba porque la piscina perdía mucha agua). 

Seguramente, mi abuela hubiese preferido que hagamos las olas usando nuestras manos en lugar de tablas de surf, de esta manera, las olas tendrían mucha menos altura: 

`La altura de las olas se conoce como AMPLITUD.` 

Estas olas, además, serían más cortas: 

`Cuanto más corta es una ola, más FRECUENCIA tiene.` 

No hubieran sido muy divertidas para nosotros, porque no llegarían demasiado lejos, y no conseguirían llenar la piscina de olas, cosa que con la tabla de surf sí conseguíamos.

La radiación electromagnética se comporta de forma muy similar: En lugar de hacer olas en el agua, estamos haciendo olas en una dimensión del universo que a día de hoy no sabemos a ciencia cierta cual es. Además, las olas en esta dimensión siempre se desplazan a la velocidad de la luz. 

En vez de usar una tabla de surf, o nuestras manos, para ondular esta dimensión del universo agitamos electrones usando una antena. Igual que en la piscina, si nuestra antena es pequeña, como la de nuestro móvil o mando del parking, no podremos crear olas muy largas, es decir, no podremos emitir a **baja frecuencia** como hacía con la tabla de surf.

`Por razones linguísticas, las "olas" que hacemos en el campo electromagnético, las llamamos ONDAS.`

{{<video  src="radiation.mp4" controls="no" >}}
> Esta animación, [del excelente vídeo de 3Blue1Brown sobre la radiación electromagnética](https://www.youtube.com/watch?v=aXRTczANuIs), muestra como al agitar un electrón, se producen ondas en el campo electromagnético.

### Por qué utilizar modulación
Imagina que es de noche, y quieres comunicarte desde una gran distancia con un amigo tuyo. Tienes una linterna en la mano, por lo que puedes apagarla y encenderla, y enviar una serie de pulsos que tu amigo puede interpretar siguiendo un lenguaje que hayáis acordado previamente. Enhorabuena, acabas de enviar un mensaje utilizando modulación ASK, la misma que utilizan que nuestros mandos.

La siguiente imagen muestra cómo funciona la modulación ASK:
![Modulación ASK](images/reading-rf-signals/ask.png)
Como ves, cada pulso de luz, son en realidad muchas ondas cortas. Esto se debe a que nuestra linterna no puede crear ondas tan largas como para que a tu amigo le de tiempo a darse cuenta de una única onda.

`Utilizar ondas cortas para enviar información más lenta se llama MODULACIÓN.`

### Diseñando un lenguaje para comunicarnos
Imagina que queremos informar a nuestro amigo de 4 cosas:
* Si tenemos sueño
* Si tenemos hambre
* Si tenemos miedo
* Si necesitamos ayuda

Si utilizamos nuestra linterna, la primera idea que podríais tener, es que podrias encenderla o apagarla durante 4 segundos. Pero enseguida os dais cuenta de que esto presenta el siguiente problema:

Si queremos decir que solo tenemos hambre, solo encenderemos la linterna durante 1 segundo. ¿Pero cómo sabrá el amigo que ese único segundo es porque tenemos hambre, y no porque necesitamos ayuda? Tendríamos que acordar unas horas concretas en las que los mensajes deben ser enviados, es decir, tendremos que tener cada uno un reloj y tenerlo en hora. Además, no podremos enviar el mensaje cuando queramos, tendremos que esperar a que llegue la hora acordada.

La siguiente idea que se os acabaría ocurriendo, sería que cada vez que queramos enviarle un mensaje podemos encender la linterna 4 veces, y dependiendo de si queremos decir que si o no, encenderemos la linterna durante un tiempo corto, o uno más largo. De esta manera podríamos enviar un mensaje en cualquier momento, y no haria falta que cada uno de vosotros tenga un reloj en hora.

Nuestros mandos de parking utilizan exactamente el mismo lenguaje que acabamos de describir, como veremos más adelante.

## Recibiendo señales

### Tus ojos y la radio del coche funcionan igual
Los humanos disponemos de 6 receptores de ondas electromagnéticas, 3 en cada uno de nuestros ojos. Estos receptores filtran físicamente un rango de frecuencias específico, por ejemplo, los receptores del color rojo filtran las ondas de entre 400THz y 480THz. Esto significa, que podríamos utilizar una linterna de color rojo, y él podría detectar los pulsos con 2 de sus 6 receptores. Si la linterna es de color blanco, la onda que emitiremos estará compuesta por una multitud de frecuencias, que activaremos sus 6 receptores. 

Las frecuencias que componen la luz visible tienen desventajas si queremos utilizarlas para controlar máquinas:
* Podrían ser molestas: Imagina que cada vez que quieres controlar la televisión tuvieses que usar un rayo de luz, podría resultar molesto si quieres ver una película a oscuras.
* Las ondas de tan alta frecuencia no son capaces de atravesar materiales sólidos con cierto grosor: Imagina que el WiFi solo funcionase si puedes ver el router.

Es por esto, que los dispositivos electrónicos habitualmente utilizan frecuencias que nuestros ojos no pueden detectar.
En Europa, los automatismos se comunican predominantemente a través de la modulación ASK (Amplitude Shift Keying) con una onda portadora de 433.92 MHz.

### Como ver varios colores a la vez
Mi proyecto comenzó con la adquisición de una herramienta modesta pero potente: un 'dongle' SDR (Radio Definida por Software). Estos dispositivos descomponen las diferentes frecuencias, en lugar de filtrarlas físicamente como hacen nuestros ojos o la radio de nuestro coche. Esto nos permite detectar la presencia de múltiples "colores" al mismo tiempo.

El algoritmo más esencial para conseguir esto es el algoritmo FFT (Transformada Rápida de Fourier), que descompone las señales recibidas en sus frecuencias constituyentes, lo que nos permite ver en tiempo real las técnicas de modulación. 

La belleza de la transformación de fourier, en mi opinión, es que es lo más parecido que tenemos a poder ajustar nuestros ojos para poder ver rangos de colores que resultan imposibles de imaginar para nosotros.

Para aprender más sobre el algoritmo FFT, te recomiendo los siguientes dos videos:
* [La Historia Sorprendente Detrás del Algoritmo Más Importante de Todos los Tiempos](https://www.youtube.com/watch?v=nmgFG7PUHfo) de Veritasium, donde se discute la historia y la importancia de este algoritmo.
* [Pero, ¿qué es la Transformada de Fourier? Una introducción visual.](https://www.youtube.com/watch?v=spUNpyF58BY) de 3Blue1Brown, útil para comprender lo que está sucediendo en el fondo.

No es necesario que veas los vídeos, lo más importante es que interiorices esta imágen de lo que consigue la transformación FFT:

![Visualización del algoritmo FFT](images/reading-rf-signals/fft.png)

### Escuchando colores
SDR Sharp te permite interpretar señales en tiempo real y transforma la información a impulsos de sonido para que puedas escucharla, siempre que esté dentro del rango de audición humana. Además, puedes exportar estas señales demoduladas como archivos .wav para un análisis detallado utilizando herramientas como Audacity.

## Mis mandos a distancia
Utilizando los conceptos anteriores, pude comenzar a investigar que hacían mis mandos a distancia. Para cada uno de ellos, presioné sus botones y esperé ver un "color" en la vista FFT. Si hubiera visto más de un "color" separado para alguno de los mandos, significaría que están utilizando una modulación un poco mas compleja: FSK. 

La modulación FSK consistiría en que utilizásemos una linterna verde para decir que estamos bien, y una linterna roja para decir que estamos en apuros. Afortunadamente, esto no ocurrió para ninguno de ellos, lo que significa que todos utilizan ASK.

En esta imagen, puedes ver cómo se ve un mando a distancia en SDR Sharp. Si configuramos la demodulación en modo 'AM', y seleccionamos el "color" que nos interesa, escucharemos los pulsos en la señal.
![Señal de mi mando a distancia](images/reading-rf-signals/sdr_ask.png)
En esta otra imagen, puedes ver cómo se ve la grabación .wav en Audacity. Finalmente, se puede observar la información enviada por el mando a distancia.
![Datos de mi mando a distancia](images/reading-rf-signals/audacity.png)

Tres de los cuatro mandos que tengo utilizan una onda de 433.92 MHz, un color que no podemos ver. Sin embargo, uno de los mandos, debido a su antigüedad, utiliza 280 MHz, una frecuencia que las regulaciones legales desde entonces han restringido a los aficionados.

> Un dato curioso: en el pasado, los operadores de telegrafía profesionales se referían a los aficionados como 'ham-fisted' (Manos de jamón) debido a su tendencia a cometer errores en sus mensajes. Esto finalmente ha llevado a que las bandas de frecuencia donde los aficionados tienen permiso legal para operar se denominen 'Ham-Bands' (Bandas de jamón).

A pesar de los desafíos, sigo decidido a explorar el territorio de la puerta de 280 MHz. Mantente atento para actualizaciones sobre esta intrigante búsqueda.

## Conclusión
Y con eso, concluimos nuestro viaje inicial al intrigante mundo de las señales de RF y su modulación/demodulación. Estos conocimientos sientan las bases para nuestras próximas aventuras. En los próximos artículos, aprovecharemos este conocimiento para crear nuestro propio mando a distancia de garaje multi-puerta, brindando una demostración práctica de los conceptos que hemos discutido. Así que mantente atento a la próxima entrega, donde nos sumergiremos de lleno en el diseño de la primera prueba de concepto.