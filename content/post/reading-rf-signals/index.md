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

In the whirlwind of everyday life, we often encounter unique challenges that spark our curiosity and drive us to explore the world of technology. I recently faced one such conundrum: a growing collection of garage remotes cluttering my life, each catering to one, two at most, garage doors. The sheer number of these remotes became unwieldy, prompting me to embark on an ambitious journey. My goal? To decipher the inner workings of these devices and create a versatile solution capable of opening up to six distinct garage doors. This captivating adventure took me through various exciting areas, encompassing not only the intricacies of RF (Radio Frequency) communications but also delving into circuit design, battery optimization, and the fine art of low-level communication between integrated circuits (ICs).

Throughout this article series, we'll delve into these five distinct yet interconnected segments:

* Understanding how RF communications work.
* Crafting the initial proof-of-concept remote design.
* Opening my garage doors
* Streamlining the design for maximum compactness.
* Guiding you through the process of building your very own multi-door remote.

Together, we'll traverse this technological landscape, unraveling the mysteries of garage remote control and exploring the depths of modern electronics.

## The Journey Begins: Exploring RF Signals
My journey began with the acquisition of a modest yet potent tool: an SDR (Software-Defined Radio) dongle. In the past, probing the depths of RF signals necessitated expensive equipment, but today, SDR dongles provide an affordable means to visualize and analyze these signals in real-time. The magic unfolds through the FFT algorithm (Fast Fourier Transform), breaking down received signals into their constituent frequencies, enabling us to decipher modulation techniques. 

To learn more about the FFT algorithm, I recommend the following two videos:
* [The Remarkable Story Behind The Most Important Algorithm Of All Time](https://www.youtube.com/watch?v=nmgFG7PUHfo) by Veritasium, where the history and importance of this algorithm are discussed.
* [But what is the Fourier Transform? A visual introduction.](https://www.youtube.com/watch?v=spUNpyF58BY) by 3Blue1Brown, useful to understand what is going on behind the scenes.

The following image shows how the FFT plots signals in the frequency domain:

![Visualization of the FFT algorithm](images/reading-rf-signals/fft.png)

### OOK Modulation
Using SDR Sharp software, I could demodulate and scrutinize the signal. In Europe, consumer-grade automation predominantly communicates through OOK (On-Off keying), a type of ASK (Amplitude Shift Keying) modulation with a 433.92 MHz carrier wave. OOK is a straightforward yet widely used modulation technique where data is conveyed by toggling the carrier wave on and off. It's worth noting that OOK modulation employs unique encoding, translating bits of information into sequences that facilitate clock recovery on the receiver's end. For example, 1's could be translated to '110', and 0's to '100'.

### My remotes
Three out of four remotes I encountered operated using OOK modulation at 433.92 MHz. However, one remote, due to its age, utilized a 280 MHz carrier wave. My quest to replicate this frequency range led me to discover a discontinued chip. Legal regulations have restricted the use of this frequency band to amateurs
> A fun fact: Back in the day, professional telegraph operators referred to amateurs as 'ham-fisted' due to their tendency to produce errors in their messages. This has ultimately led to the frequency bands where amateurs are legally allowed to operate being designated as the 'Ham-Bands'.

Despite the challenges, I remain determined to explore the uncharted territory of the 280 MHz door. Stay tuned for updates on this intriguing pursuit.