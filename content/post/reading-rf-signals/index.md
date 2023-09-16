---
title: "Garage Remote: Part 1"
description: "Unlocking the Secrets of RF Communication: How I learnt to read RF signals"
slug: reading-rf-signals
date: 2023-09-16
image: cover.png
categories:
    - Garage Remote
tags:
    - radiofrequency
    - modulation
    - wireless
---

In the whirlwind of everyday life, we often encounter unique challenges that spark our curiosity and drive us to explore the world of technology. I recently faced one such conundrum: a growing collection of garage remotes cluttering my life, each catering to one, two at most, garage doors. The sheer number of these remotes became unwieldy, prompting me to embark on an ambitious journey. My goal? To decipher the inner workings of these devices and create a versatile solution capable of opening up to six distinct garage doors. 

This captivating adventure took me through various exciting areas, encompassing not only the intricacies of RF (Radio Frequency) communications but also delving into circuit design, battery optimization, and the fine art of low-level communication between integrated circuits (ICs).

Throughout this article series, we'll delve into these five distinct yet interconnected segments:

* **Understanding how RF communications work.** *(This article)*
* **Crafting the initial proof-of-concept remote design.** *(Coming soon)*
* **Opening my garage doors.** *(Coming soon)*
* **Streamlining the design for maximum compactness.** *(Coming soon)*
* **Guiding you through the process of building your very own multi-door remote.** *(Coming soon)*

Join me, as we unravel the mysteries of remote control technology and explore of modern electronics.

## The Journey Begins: Visualizing RF signals
My journey began with the acquisition of a modest yet potent tool: an SDR (Software-Defined Radio) dongle. In the past, probing the depths of RF signals necessitated expensive equipment, but today, SDR dongles provide an affordable means to visualize and analyze these signals in real-time. The magic unfolds through the FFT algorithm (Fast Fourier Transform), breaking down received signals into their constituent frequencies, enabling us to decipher modulation techniques. 

To learn more about the FFT algorithm, I recommend the following two videos:
* [The Remarkable Story Behind The Most Important Algorithm Of All Time](https://www.youtube.com/watch?v=nmgFG7PUHfo) by Veritasium, where the history and importance of this algorithm are discussed.
* [But what is the Fourier Transform? A visual introduction.](https://www.youtube.com/watch?v=spUNpyF58BY) by 3Blue1Brown, useful to understand what is going on behind the scenes.

The following image shows how the FFT plots signals in the frequency domain:

![Visualization of the FFT algorithm](images/reading-rf-signals/fft.png)

## Demodulating the signals
I could finally see the FFT in SDR Sharp software, but I didnt know how to extract the information out of there, this is because the signals are modulated, and the appropiate demodulation technique has to be chosen in order to extract the information. But before we dive into demodulation, it's essential to understand what modulation is.

### Why use modulation?
When we transmit information as electromagnetic radiation, sending it as-is isn't practical for several reasons:

* Not all waves propagate effectively.
* Antenna size varies depending on the wave.
* Often, we want to send multiple streams without interference.

To optimize information transfer, we use modulation. We mix our information with carrier waves: signals ideal for traveling through various mediums like air, cables, or optical fibers. The resulting wave inherits the carrier wave's characteristics.

The following chart shows the different types of signal modulation, depending on the type of data to be sent, and the type of carrier wave used:
![Modulation types](images/reading-rf-signals/modulations.jpg)

### Example application of modulation
For instance, consider transmitting audio. Directly sending the analog signal from a microphone without modulation poses challenges:

* It would require an extremely large antenna or a powerful power source.
* Multiple audio streams would interfere with each other.

To overcome this, we turn to modulation.  Looking at the chart, we want an analog carrier signal, because those propagate better in the air. And we have to look into the 'analog data' category, because the signal coming from our microphone is analog. From here, we can choose AM, FM, or PM. We will choose AM because it is straightforward and suitable for understanding later how remotes work.

The following illustration shows how our experiment would look like using AM:
![Modulation types](images/reading-rf-signals/am-transmission.gif)

### Demodulating with SDR Sharp
SDR Sharp empowers you to demodulate signals in real-time and listen to the demodulated output, provided it falls within the human hearing range. Additionally, you can export these demodulated signals as .wav files for detailed analysis using tools like Audacity.

As a practical example, let's tune into a local radio station.
#### Step 1: Navigating the RF Spectrum and choosing a station
The first step is to search for stations within the FFT view. In my region, FM stations typically reside in the frequency range between approximately 87.5 MHz and 108 MHz. Somewhere along this span, I encountered four distinct transmissions, each representing a different radio station. To tune into one of them, I selected its specific frequency range.

#### Step 2: Determining the modulation
Once I selected the desired radio station, all I initially heard was noise, simply because the correct demodulation technique hadn't been applied. Unlike our previous experiment, where a single frequency would show in the FFT graph, these radio stations revealed a more intricate pattern of independently varying frequencies, a hallmark of FM modulation. Recognizing this, I swiftly switched to WFM demodulation, the type of FM employed by radio stations. Finally, I could enjoy the local radio station with crystal clarity.

#### The Beauty of Distinct Carrier Waves:
As you will observe, these stations broadcast their audio on distinct carrier waves, enabling them to transmit various audio streams concurrently. Thanks to modulation, I could savor soothing jazz, while simultaneously, a teenager could indulge in their preferred obnoxious reggaeton on the station "next door."

{{<video  src="WFM.mp4" controls="yes" >}}

By the way, I've showcased FM stations because, despite my efforts, I couldn't detect any AM stations similar to those we envisioned in our previous experiment. This limitation likely stems from the constraints of my equipment: a budget-friendly dongle.

## ASK Modulation
In Europe, consumer-grade automation predominantly communicates through ASK (Amplitude Shift Keying) modulation with a 433.92 MHz carrier wave. ASK is the same as the AM we discussed earlier, but instead of an analog signal, turn on and off the carrier wave depending on a binary value. 

The following image shows how ASK modulation works:
![ASK Modulation](images/reading-rf-signals/ask.png)

Imagine we want to send a stream of 8 zeros (00000000). If we modulated this directly as ASK, it would translate to complete radio silence. As you can imagine, a receiver would have trouble figuring out that this silence means 8 zeros without a shared clock. This is why ASK modulation requires encoding, translating bits of information into sequences that facilitate clock recovery on the receiver's end. For example, each 1 could be translated to '110', and each 0 to '100'.

## My remotes
Using the concepts shown earlier, I could begin the reverse engineering of my remotes. For each of them, I clicked their buttons, and waited to see a spike in the FFT view. If I had seen more than one separate spike for any of the remotes, it would mean they're using the more complex FSK. Thankfully, none of them did, meaning they all use ASK (I can rule out PSK or QAM because these are cheap consumer-grade remotes). 

In this image, you can see how a remote looks like in SDR sharp. If we set the demodulation to 'AM' we will listen to the variations in amplitude.
![My remote's signal](images/reading-rf-signals/sdr_ask.png)
In this other image, you can see how the .wav recording looks like in Audacity. At last, the binary data sent by the remote can be observed.
![My remote's signal](images/reading-rf-signals/audacity.png)


Three out of the four remotes I have use a 433.92 MHz carrier wave. One remote, however, due to its age, uses 280 MHz, which legal regulations have since restricted to amateurs.

> A fun fact: Back in the day, professional telegraph operators referred to amateurs as 'ham-fisted' due to their tendency to produce errors in their messages. This has ultimately led to the frequency bands where amateurs are legally allowed to operate being designated as the 'Ham-Bands'.

Despite the challenges, I remain determined to explore the uncharted territory of the 280 MHz door. Stay tuned for updates on this intriguing pursuit.

## Conclusion
And with that, we conclude our initial journey into the intriguing realm of RF signals and their modulation/demodulation. These insights lay the foundation for our upcoming endeavors. In the forthcoming articles, we'll harness this knowledge to craft our very own multi-door garage remote, providing a practical demonstration of the concepts we've discussed. So, stay tuned for the next installment, where we dive headfirst into creating the first proof-of-concept remote design.