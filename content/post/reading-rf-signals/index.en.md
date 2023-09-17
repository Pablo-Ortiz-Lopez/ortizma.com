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

During everyday life, I often encounter challenges that pique my curiosity and drive me to explore the world of technology. Recently, I faced one such challenge: a growing collection of garage door remotes. The sheer number of these remotes led me to embark on an ambitious project, to decipher the inner workings of these devices and create a versatile solution capable of opening up to six different garage doors.

This project has spanned several areas, encompassing not only RF (Radio Frequency) communications but also circuit design, battery optimization, and the art of low-level communication between integrated circuits.

Throughout this article series, we'll delve into these five distinct yet interconnected segments:

* **Understanding how RF communications work.** *(This article)*
* **Crafting the initial proof-of-concept remote design.** *(Coming soon)*
* **Opening my garage doors.** *(Coming soon)*
* **Streamlining the design for maximum compactness.** *(Coming soon)*
* **Guiding you through the process of building your very own multi-door remote.** *(Coming soon)*

Join me, as we explore the mysteries of remote control technology and modern electronics.
## Demodulation of Signals
To begin analyzing radio signals, we must first understand how they work.

The laws of physics stipulate that to transmit a low-frequency wave through a non-conductive medium, such as air, both the transmitter and receiver need a larger antenna compared to transmitting and receiving a higher-frequency wave. They also stipulate that if we send two waves of the same frequency, they will be impossible to distinguish on our receiving device.

As you can imagine, it's not desirable to use kilometer-long antennas in our portable devices, and we would also like multiple communication channels to be able to use the same medium simultaneously. Fortunately, the laws of physics cannot be modified, but we can use them to our advantage.

To efficiently send information, what we do is "hide" our information in electromagnetic waves that have the properties we desire; this is known as modulation.

### Example of Modulation Application
For example, imagine it's nighttime, and you want to communicate over a long distance with a friend. You have a flashlight in your hand, so you can turn it on and off, sending a series of pulses that your friend can interpret following a language you have agreed upon beforehand. Congratulations, you have just sent a message using Amplitude Shift Keying (ASK) modulation, the same one that our remotes use.

The following image shows how ASK modulation works:
![ASK Modulation](images/reading-rf-signals/ask.png)

#### Differences Between Remotes and Humans
Humans have 6 receivers of electromagnetic waves, 3 in each of our eyes. These receptors physically filter a specific range of frequencies; for example, the receptors for the color red filter waves between 400THz and 480THz. This means that we could use a red flashlight, and your friend could detect the pulses with 2 of their 6 receptors. If the flashlight is white, the wave we emit will consist of a multitude of frequencies, activating all 6 receptors.

Frequencies that make up visible light have disadvantages if we want to use them to control machines:
* They could be annoying: Imagine having to use a beam of light every time you want to control the TV; it could be bothersome if you want to watch a movie in the dark.
* Waves at such high frequencies can't penetrate solid materials with some thickness: Imagine if Wi-Fi only worked when you could see the router.

This is why electronic devices commonly use frequencies that our eyes cannot detect. In Europe, automation predominantly communicates through Amplitude Shift Keying (ASK) modulation with a carrier wave at 433.92 MHz.

#### Designing a Language to Communicate
Imagine we want to send a sequence of 8 zeros (00000000) to our friend. If we modulated it directly as ASK, it would translate to complete darkness. As you can imagine, a receiver would have difficulty understanding that this silence means 8 zeros if it doesn't have a reference for when we started transmitting and at what rate we are sending pulses. For this reason, to hide a binary message in a wave, we must first encode it, translating bits of information into sequences that facilitate clock recovery at the receiver's end. For example, each 1 could be translated as '110', and each 0 as '100'.

## Visualizing RF Signals
My project began with the acquisition of a modest yet powerful tool: a Software Defined Radio (SDR) dongle. These SDR dongles break down different frequencies through algorithms, rather than physically filtering them as our eyes or car radios do. This allows us to visualize and analyze these signals in real-time. The most essential algorithm to achieve this is the Fast Fourier Transform (FFT) algorithm, which decomposes received signals into their constituent frequencies, allowing us to see modulation techniques in real time.

To learn more about the FFT algorithm, I recommend the following two videos:
* [The Amazing History Behind the Most Important Algorithm of All Time](https://www.youtube.com/watch?v=nmgFG7PUHfo) by Veritasium, which discusses the history and importance of this algorithm.
* [But what is the Fourier Transform? A visual introduction.](https://www.youtube.com/watch?v=spUNpyF58BY) by 3Blue1Brown, helpful for understanding what's happening in the background.

You don't need to watch the videos; the most important thing is to grasp the image of what the FFT transformation achieves:
![FFT Algorithm Visualization](images/reading-rf-signals/fft.png)

### Demodulation with SDR Sharp
SDR Sharp allows you to demodulate signals in real-time and transforms the extracted information into sound pulses so you can hear it, as long as it's within the range of human hearing. Additionally, you can export these demodulated signals as .wav files for detailed analysis using tools like Audacity.

## My Remote Controls
Using the aforementioned concepts, I could begin reverse engineering my remote controls. For each of them, I pressed their buttons and waited to see a peak in the FFT view. If I had seen more than one separate peak for any of the remotes, it would mean they were using slightly more complex modulation: Frequency Shift Keying (FSK).

FSK modulation would be like using a green flashlight to say we're okay and a red flashlight to say we're in trouble. Fortunately, this didn't happen for any of them, which means they all use ASK (we can rule out more complex modulations like PSK or QAM because these are economical remotes).

In this image, you can see what a remote control looks like in SDR Sharp. If we set the demodulation to 'AM' mode, we'll hear variations in amplitude.
![My Remote Control Signal](images/reading-rf-signals/sdr_ask.png)
In this other image, you can see what the .wav recording looks like in Audacity. Finally, you can observe the information sent by the remote control.
![My Remote Control Data](images/reading-rf-signals/audacity.png)

Three out of the four remotes I have use a carrier wave at 433.92 MHz. However, one of the remotes, due to its age, uses 280 MHz, a frequency that legal regulations have since restricted to amateur use.

> Fun fact: In the past, professional telegraph operators referred to amateurs as 'ham-fisted' due to their tendency to make mistakes in their messages. This eventually led to the frequency bands where amateurs are legally allowed to operate being called 'Ham-Bands.'

Despite the challenges, I remain determined to explore the 280 MHz gate territory. Stay tuned for updates on this intriguing quest.

## Conclusion
With that, we conclude our initial journey into the intriguing world of RF signals and their modulation/demodulation. This knowledge lays the foundation for our upcoming adventures. In the next articles, we will leverage this knowledge to create our own multi-door garage remote control, providing a practical demonstration of the concepts we have discussed. So, stay tuned for the next installment, where we will delve into the design of the first proof of concept.