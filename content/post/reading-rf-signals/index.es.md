---
title: "Mando de Parking: Parte 1"
description: "Descifrando los secretos de la comunicación por radio: Cómo aprendí a leer señales de radio, y tu puedes también."
slug: leyendo-senales-rf
date: 2023-09-16
image: cover.png
categories:
    - "Mando de Parking"
tags:
    - radio
    - frecuencia
    - modulación
    - color
    - luz
    - comunicación
---
Durante la vida cotidiana, a menudo me encuentro con desafíos que despiertan mi curiosidad y me impulsan a explorar el mundo de la tecnología. Recientemente, me enfrenté a uno: una creciente colección de mandos de parking. La cantidad de estos mandos me llevó a embarcarme en un ambicioso proyecto, para descifrar el funcionamiento interno de estos dispositivos y crear un dispositivo capaz de abrir hasta seis puertas de parking distintas.

Este proyecto ha abarcado varias áreas, no solo las comunicaciones por radio, sino también el diseño de circuitos, la optimización de baterías y el arte de la comunicación a bajo nivel entre circuitos integrados.

A lo largo de esta serie de artículos, profundizaremos en estos cinco segmentos distintos pero interconectados:

* **Conceptos básicos de las comunicaciones por radio.** *(Este artículo)*
* **Diseño de mi primer mando a distancia.** *(Próximamente)*
* **Abriendo mis puertas de garaje.** *(Próximamente)*
* **Optimización del diseño para lograr el mínimo tamaño.** *(Próximamente)*
* **Guía para que puedas construir tu propio mando multi-puerta.** *(Próximamente)*

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
Imagina que es de noche, y quieres comunicarte desde una gran distancia con un amigo tuyo. Tienes una linterna en la mano, por lo que puedes apagarla y encenderla, y enviar una serie de pulsos que tu amigo puede interpretar siguiendo un lenguaje que hayáis acordado previamente. Enhorabuena, acabas de enviar un mensaje utilizando *modulación ASK*, la misma que utilizan que nuestros mandos.

`ASK significa "Amplitude Shift Keying". Esto significa que utilizamos cambios en la altura (AMPLITUD) de la onda para comunicarnos.`

La siguiente imagen muestra cómo funciona la modulación ASK:
![Modulación ASK](images/reading-rf-signals/ask.png)
Como ves, cada pulso de luz, son en realidad muchas ondas cortas. Esto se debe a que nuestra linterna no puede crear ondas tan largas como para que a tu amigo le de tiempo a darse cuenta de una única onda.

`Utilizar ondas cortas para enviar información más lenta se llama MODULACIÓN.`

### Diseñando un lenguaje para comunicarnos
Imagina que queremos informar a nuestro amigo de 4 cosas:
* ¿Tenemos sueño?
* ¿Tenemos hambre?
* ¿Tenemos miedo?
* ¿Necesitamos ayuda?

Si utilizamos nuestra linterna, la primera idea que podríais tener, es que para cada pregunta, si queremos decir que sí, encendemos la linterna, y si queremos decir que no, la apagamos.

* Tenemos que definir cuanto rato dedicamos a responder cada pregunta.
* Si queremos decir que solo tenemos hambre, solo encenderemos la linterna durante un rato. ¿Pero cómo sabrá el amigo que ese destello es porque tenemos hambre, y no porque necesitamos ayuda? Tendríamos que acordar cuando empezaremos a enviar los mensajes, es decir, tendremos que tener cada uno un reloj y tenerlo en hora. 
* No podremos enviar el mensaje cuando queramos, tendremos que esperar a que lleguen las horas acordadas para enviar mensajes. 
* Si se nos rompe la linterna, nuestro amigo pensará que todo va bien, no se dará cuenta de que no podemos enviar más mensajes.

La siguiente idea que se os acabaría ocurriendo, sería que cada vez que queramos enviarle un mensaje podemos encender la linterna 4 veces:
* Si queremos decir que no, encenderemos la linterna durante un rato corto, y la dejamos apagada un rato más largo.
* Si queremos decir que sí, encenderemos la linterna durante un rato largo, y la dejamos apagada un rato más corto.

De esta manera solucionaríamos todos los problemas que hemos encontrado con el primer método.
Nuestros mandos de parking utilizan exactamente el mismo lenguaje que acabamos de describir, como veremos más adelante.

![Datos enviados por un mando a distancia](images/reading-rf-signals/audacity.png)
*Imagen que veremos más adelante, y muestra el mensaje que envía un mando de parking*

## Recibiendo señales

### Tus ojos son antenas de radio
Los humanos disponemos de 6 receptores de ondas electromagnéticas, 3 en cada uno de nuestros ojos. Estos receptores detectan físicamente la presencia de un color específico, es decir, ondas con una longitud concreta.

Por ejemplo, los receptores del color rojo filtran las ondas con una longitud de unos 700nm, tan largas como una bacteria.
Si utilizamos una linterna de color rojo, el amigo detectará los pulsos con 2 de sus 6 receptores. Una linterna de color blanco emite una señal mucho más caótica, es como si chapoteásemos en el agua.

La señal caótica de la linterna blanca está compuesta por muchas ondas mezcladas, y activará sus 6 receptores, ya que entre otros, contiene todos los colores que podemos ver.

> Teniendo en cuenta que vivirás unos 80 años acorde con la esperanza de vida media en Europa, vivirás 2.524.608.000 segundos. Si queremos llegar a 480.000.000.000.000 segundos, necesitaremos llenar el Camp Nou i el Santiago Bernabéu a su máxima capacidad. Las ondas del color rojo oscilan 480.000.000.000.000 veces cada segundo.

### Como ver varios colores a la vez
Hoy en día, disponemos de una herramienta conocida como SDR, esta nos permite detectar la presencia de múltiples "colores" al mismo tiempo utilizando matemáticas.

> El algoritmo más esencial para conseguir esto es el algoritmo FFT (Transformada Rápida de Fourier), que descompone las señales recibidas en sus frecuencias constituyentes, lo que nos permite ver que cantidad de cada color está presente en la luz que estamos recibiendo. Por ejemplo, si analizamos con FFT la luz que rebota en una naranja, veríamos aproximadamente el doble de rojo que de verde, y nada de azul. A continuación podrás ver una imagen que resume el funcionamiento de la transformación de fourier.

>![Visualización del algoritmo FFT](images/reading-rf-signals/fft.png)

### ¿Por qué no vemos la luz de los mandos?
Las frecuencias que componen la luz visible tienen desventajas si queremos utilizarlas para controlar máquinas:
* Podrían ser molestas: Imagina que cada vez que quieres controlar la televisión tuvieses que usar un rayo de luz, podría resultar molesto si quieres ver una película a oscuras.
* Las ondas de tan alta frecuencia (muy cortas) tienen dificultades para atravesar materiales sólidos: Imagina que el WiFi solo funcionase si puedes ver el router.

Es por esto, que los dispositivos electrónicos habitualmente utilizan ondas más largas, colores que nuestros ojos no pueden detectar, ni nuestros cerebros imaginar.

En Europa, los automatismos se comunican predominantemente a través de la modulación ASK con un único color definido por una onda de 70cm de largo. 
> Una onda de 70cm tiene una frecuencia de 433.92 MHz, esto significa que oscila 433.920.000 veces por segundo. Podrías contar hasta 433.920.000 en unos 13 años.

### Escuchando colores
SDR Sharp te permite interpretar señales en tiempo real y transforma la información a impulsos de sonido para que puedas escucharla, siempre que esté dentro del rango de audición humana. Además, puedes exportar estas señales demoduladas como archivos .wav para un análisis detallado utilizando herramientas como Audacity.

## Mis mandos a distancia
Utilizando los conceptos anteriores, pude comenzar a investigar que hacían mis mandos a distancia. Para cada uno de ellos, presioné sus botones y esperé ver un "color" en el programa. Si hubiera visto más de un "color" separado para alguno de los mandos, significaría que están utilizando una modulación un poco mas compleja: FSK. 

`FSK significa "Frequency Shift Keying". Esto quiere decir que modificamos lo largas que son las ondas para comunicarnos (cambiamos el color).`

La modulación FSK consistiría en que utilizásemos una linterna verde para decir que sí, y una linterna roja para decir que no. Afortunadamente, esto no ocurrió para ninguno de ellos, lo que significa que todos utilizan ASK.

En esta imagen, puedes ver cómo se ve un mando a distancia en SDR Sharp. Si configuramos la demodulación en modo 'AM', y seleccionamos el "color" que nos interesa, escucharemos los pulsos en la señal.
![Señal de mi mando a distancia](images/reading-rf-signals/sdr_ask.png)
En esta otra imagen, puedes ver cómo se ve la grabación .wav en Audacity. Finalmente, se puede observar la información enviada por el mando a distancia.
![Datos de mi mando a distancia](images/reading-rf-signals/audacity.png)

Tres de los cuatro mandos que tengo utilizan una onda de 70cm, un color que no podemos ver. Sin embargo, uno de los mandos, debido a su antigüedad, utiliza ondas de 1m, un color (o frecuencia) que las regulaciones legales desde entonces han prohibido a los aficionados.

> Un dato curioso: en el pasado, los operadores de telegrafía profesionales se referían a los aficionados como 'ham-fisted' (Manos de jamón) debido a su tendencia a cometer errores en sus mensajes. Esto finalmente ha llevado a que las bandas de frecuencia donde los aficionados tienen permiso legal para operar se denominen 'Ham-Bands' (Bandas de jamón).

Sigo decidido a explorar el territorio de las ondas de 1m (280MHz de frecuencia), la mayor dificultad esta siendo encontrar dispositivos que emitan este "color". Mantente atento para estar al día sobre esta intrigante búsqueda.

## Conclusión
Y con eso, concluimos nuestro viaje inicial al intrigante mundo de las señales de RF y su modulación/demodulación. Estos conocimientos sientan las bases para nuestras próximas aventuras. En los próximos artículos, aprovecharemos este conocimiento para crear nuestro propio mando a distancia de garaje multi-puerta, brindando una demostración práctica de los conceptos que hemos discutido. Así que mantente atento a la próxima entrega, donde nos sumergiremos de lleno en el diseño de la primera prueba de concepto.

## Para profundizar
Si quieres aprender más sobre la radiación electromagnética y la luz visible, te recomiendo estos vídeos:
* [This demo surprised me (a lot) | Barber pole, part 1](https://www.youtube.com/watch?v=QCX62YJCmGk) de 3Blue1Brown, donde presenta un fenómeno visual que expone propiedades interesantes de la luz.
* [The origin of light, scattering, and polarization | Barber pole, part 2](https://www.youtube.com/watch?v=aXRTczANuIs) también de 3Blue1Brown, donde empieza a explicar los conceptos detrás del fenómeno previamente visto para poder entenderlo intuitivamente.

Para aprender más sobre la transformación de Fourier, te recomiendo estos vídeos:
* [The Remarkable Story Behind The Most Important Algorithm Of All Time](https://www.youtube.com/watch?v=nmgFG7PUHfo) de Veritasium, donde se discute la historia y la importancia de este algoritmo.
* [But what is the Fourier Transform? A visual introduction.](https://www.youtube.com/watch?v=spUNpyF58BY) de 3Blue1Brown, útil para comprender lo que está sucediendo en el fondo.