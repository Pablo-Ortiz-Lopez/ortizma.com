---
title: Garage Remote
description: "Unlocking the Secrets of RF Communication: My Journey to Build a Multi-Door Garage Remote"
slug: garage-remote
date: 2023-09-10
image: cover.jpg
categories:
    - Personal
tags:
    - atmega328p
    - radiofrequency
    - modulation
    - battery
    - low-power
    - cc1101
    - max7060
    - wireless
---

In the ever-evolving landscape of technology, my insatiable curiosity often propels me into thrilling explorations. Today, I invite you to embark on a voyage of discovery as I share my journey, where a practical need for a multi-door garage remote ultimately led me to delve deep into the intricacies of RF (radio frequency) communication. Join me as we unravel the mysteries of RF signals, modulation techniques, circuit design, and more.

## The Journey Begins: Exploring RF Signals
My journey began with the acquisition of a modest yet potent tool: an SDR (Software-Defined Radio) dongle. In the past, probing the depths of RF signals necessitated expensive equipment, but today, SDR dongles provide an affordable means to visualize and analyze these signals in real-time. The magic unfolds through FFT (Fast Fourier Transform) visualization, breaking down received signals into their constituent frequencies, enabling us to decipher modulation techniques.

### OOK Modulation
Using SDR Sharp software, I could demodulate and scrutinize the signal. In Europe, consumer-grade automation predominantly communicates through OOK (On-Off keying), a type of ASK (Amplitude Shift Keying) modulation with a 433.92 MHz carrier wave. OOK is a straightforward yet widely used modulation technique where data is conveyed by toggling the carrier wave on and off. It's worth noting that OOK modulation employs unique encoding, translating bits of information into sequences that facilitate clock recovery on the receiver's end. For example, 1's could be translated to '110', and 0's to '100'.

### My remotes
Three out of four remotes I encountered operated using OOK modulation at 433.92 MHz. However, one remote, due to its age, utilized a 280 MHz carrier wave. My quest to replicate this frequency range led me to discover a discontinued chip. Legal regulations have restricted the use of this frequency band to amateurs
> A fun fact: Back in the day, professional telegraph operators referred to amateurs as 'ham-fisted' due to their tendency to produce errors in their messages. This has ultimately led to the frequency bands where amateurs are legally allowed to operate being designated as the 'Ham-Bands'.

Despite the challenges, I remain determined to explore the uncharted territory of the 280 MHz door. Stay tuned for updates on this intriguing pursuit.

## The First Garage Remote
With the newfound knowledge, I embarked on the task of unlocking the mysteries of my garage doors. I knew there were three doors I could potentially open with my available hardware. To initiate this adventure, I initially employed a basic yet functional SAW-based emitter. These emitters operate by generating a continuous oscillation at 433.92 MHz. This oscillation is then directed to the antenna through a transistor, but only when the microcontroller sets a specific pin to Logic High.

However, the initial attempt with this emitter encountered a minor hiccup. The frequency of the carrier wave produced by the inexpensive emitter did not precisely match the frequencies emitted by the remotes, and only one of the three garage doors responded to my signals. This discrepancy led me to speculate that the receivers might be exceedingly meticulous regarding the frequency and, as a result, were disregarding my signals.

### Opening the second door
Determined to overcome this hurdle, I decided to shift my strategy. I turned to a remarkably versatile module based on the CC1101 chip. This module provided a significantly more elaborate degree of control over the RF signals generated. Armed with this newfound capability, I meticulously aligned the signal frequency to match each of the remotes. However, despite these efforts, the doors remained frustratingly unresponsive.

Undeterred, I embarked on a quest to uncover potential mistakes in the way I interpreted the codes from the remotes. It was during this meticulous analysis that I stumbled upon a crucial revelation. A "squelch" threshold, a mechanism designed to suppress noise, had been inadvertently set. This threshold silenced the initial pulses of the signal before the software could activate the sound processing. Once I rectified this oversight, I succeeded in opening a second door. Yet, the third door continued to resist my commands.

### Opening the third door
My determination to conquer the unforgiving third door led me to an interesting discovery. The signal from the original remote for this door exhibited peculiar characteristics. Contrary to expectations, the 'high' pulses in this signal were not a continuous stream but were instead punctuated at a constant rate. Essentially, an additional frequency was multiplexed with the 433.92 MHz signal to produce the carrier wave.

To tackle this unique challenge, I transformed the signal sequences: I translated '1's into '1010101010101010' and '0's into '0000000000000000'. This intricate adjustment proved to be the key that finally unlocked the third door.

## The First PCB Design
Let's dive deeper into the beginning of my initial PCB design, uncovering the important lessons I learned along the way. This design can be divided into several parts, each playing a crucial role:

### ATMEGA-328P: The Core Microcontroller
At the center of my design is the ATMEGA-328P microcontroller, a well-known component often used in Arduino boards. To ensure smooth communication and operation, I added two output pin headers:

* **ICSP (In-Circuit Serial Programming):** I chose to program the microcontroller using ICSP rather than the serial protocol, because I wanted to avoid the potential problems of an asynchronous protocol. Here I made my first mistake: I accidentally routed VCC (later renamed VBAT+) instead of +5V, which required me to find another source for the +5V signal—a frustrating oversight.

* **Serial:** I added this header in case I needed to debug issues with the program's flow. It revealed signal irregularities with frequent glitches, possibly due to capacitance issues. These anomalies reaffirmed my earlier decision to use ICSP.

### MAX7060: A Hard-to-Find RF Transmitter
The MAX7060 RF transmitter is a powerful component capable of emitting both FSK and ASK modulated signals. It can operate within a frequency range of 280MHz to 450MHz, potentially unlocking all my garage doors. However, finding this component proved to be a challenge. So, in its absence, I decided to use the more readily available CC1101 chip as a substitute.

### CC1101: An extremely powerful and common RF Transceiver
This is a very common RF chip, and compared to the MAX7060:
  * It is capable to receive information
  * It can use additional modulations aside from FSK and ASK
  * It can operate at frequencies in the 315/433/868/915 MHz ISM SRD bands
  * Crucially, it is not capable of emitting at 280 MHz, a feature which I need.
  
I used a TXS108EPWR chip to translate the SPI communication between the 5V ATMEGA328P and the 3.3V CC1101. I used an AMS1117 LDO regulator to produce a constant 3.3V out of the 5V.

### The Power Supply & User Input
I faced a significant challenge in this project: creating a stable 5V power supply for my Arduino while dealing with the unpredictable voltage fluctuations of batteries. I also needed to ensure that my design was energy-efficient to make the most of the battery's life. Here's a breakdown of the key elements of this challenge:

1. **Battery Voltage Fluctuation**: Batteries have a tendency to provide unstable voltage levels that often fall below the 5V required by the Arduino.

2. **Efficient Voltage Regulation**: I needed a solution to regulate the voltage to a steady 5V without constantly draining the battery.

3. **Low-Power Operation**: Instead of orchestrating all ICs to operate at low-power when needed, I had to find a simple way to toggle the circuit.

4. **User Input**: My design includes physical buttons that users press to initiate various operations.

**The Solution**

To address these challenges, I implemented a clever solution:

1. **Boost Converter/Step-Up Module**: To boost the battery voltage to 5V, I used a boost converter or step-up module. These modules are effective but the ones i had around were bulky due to an adjustable voltage divider. This divider is necessary to provide the control chip with a 0.6V reference voltage. However, I optimized this by using a pair of resistors instead, reducing both power consumption and size.

2. **OR Circuit with Diodes**: I created an OR circuit using diodes, combining the output signals from all buttons. This unified signal indicates if any button is pressed.

3. **NPN BJT Transistor**: I routed the OR circuit output to the base of an NPN BJT transistor. This transistor allowed current to flow from GND to GND2 (which I later renamed VBAT-), the negative terminal of the battery.

4. **Current Limiting Resistor**: To ensure the BJT transistor's base received a safe current, I incorporated a current-limiting resistor. This is essential because BJTs cannot handle high currents on their base.

5. **Protection diodes**: GND2 had a voltage approximately 0.2V lower than GND, which necessitated diodes on the BXX signals to prevent negative voltage on IO pins.

**Design Challenges and Improvements:**

While I am happy with my design, I did notice a few errors later on:

- **Pull-Down Placement**: I initially placed pull-down resistors to GND2 behind the diodes, which didn't properly connect the IO pins to ground. For ideal operation, they should be placed after the diodes, directly to GND.

- **Unused Integrated Pull-Up Resistors**: I overlooked utilizing the integrated pull-up resistors of the ATMEGA328P, which could have reduced the component count and simplified the design.


## The second design
Once I had manufactured a few units of my first design, realized about its mistakes, heard everyone complain about its bulky size, and worried about the Li-Po battery burning my car, I decided it was time to produce an improved version.

The enhanced version incorporated valuable feedback and introduced the following improvements:
* In the new design, I didn't need to allocate space for the MAX7060 component. I could utilize the same boards from the first design for future testing.
* I used much smaller SMD diodes.
* I used the ATMEGA328P's internal pull-ups to reduce the component count.
* I managed to use the ATMEGA328P at 3.3V and 1MHz, instead of 5V and 16MHz.
* I leveraged the possibility of the CC1101 to regulate its output power.

### Using the internal pull-ups
To achieve this, I had to find a way to complete the circuit on the battery's terminals when one of the buttons is pressed, and when this happens, only one of the buttons has to produce a low voltage signal. Here's how I achieved this using minimal components:

The button connects VBAT- on one side, with the IO pin, through the rectifier diode, and GND, through the schottky diode, on the other side. This means that once the button is pressed, GND will be able to flow to VBAT-, and the IO pin will see a low voltage level, just what I wanted. 

This concept has a potential issue: both diodes have a voltage drop, and more current is flowing through the GND->VBAT- diode, so the drop there would be larger if both diodes were equal, resulting in negative voltage on the IO pin. I solved this by using a schottky diode on the higher-current path, therefore ensuring that the voltage drop is lower on the GND->VBAT- path, and the IO pin has a low (about 0.2V) voltage when its button is pressed.

### Using the ATMEGA328P in a low-power configuration
The Atmega328P, like most AVR microcontrollers, features a set of fuses (Low, High, Extended and Lock), which can be used to configure the working parameters of the device. 

#### Voltage level
As per the datasheet, the voltage level can be reduced down to 1.8V, but to do this, you need to use some of the fuses to adjust the Brown-out Detector (BOD) feature. The BOD, basically, prevents the microcontroller from operating if the supply voltage falls below a certain threshold, to prevent erratic behavior in critical operations which could endanger the safety of people or critical assets. 

In my case, I chose to use it at 3.3V, this way I could avoid the logic-level translation between microcontroller and RF chip while still considerably reducing power consumption. This means that I just have to avoid setting the BOD to its 4.2V setting, all the other settings are fine for me.

#### Clock speed
The fuses can also control if the clock used to drive the chip is to be an external one, or rather the internal RC oscillator circuit provided by the chip. The internal RC oscillator has the downside of being less precise, but since we don't plan to do any time keeping, and we use SPI, which is a synchronous protocol, this will be alright for our application. The RC oscillator resonates at 8MHz, but we can further divide it into 1MHz, which is still enough for our application.

#### Adjusting the program to the slower clock
In my first iteration of the firmware, I directly used the CC1101 driver implementation by Elechouse. It was a practical choice as it saved me a significant amount of time compared to reading through the CC1101 datasheet and building the driver from scratch. 
However, there was a notable issue with this implementation: it didn't make the most efficient use of the CC1101's FIFO queue, which is designed for packet sending.

The CC1101 has two 64 byte FIFO queues, one for sending data, and another one for receiving. Additionally, the CC1101 offers two configurable IO pins, and I was particularly interested in leveraging these features.

Elechouse's approach to sending data with the CC1101 involved filling up the FIFO with the bytes to be sent and then configuring GDO0 to indicate when the FIFO had been emptied. This signaled that the data transmission was complete, and the method returned control to the user's code.

However, there was a limitation in this approach: the CC1101's FIFO queue could only hold up to 64 bytes. This became a problem when I needed to transmit larger packets, such as the 216-byte codes for one of my doors. 

In order to use the Elechouse implementation, what i did was wait for long periods of zeros to send the next chunk of data. At 16MHz I had enough time to do this between long runs of zeros, but now at 1MHz this trick was not enough so I had to get clever. 

To address this challenge, I delved into the CC1101 datasheet and made modifications to the SendData routine. I also configured the second IO pin, GDO2, to monitor the available free space in the FIFO queue. 

Here's how the revised routine worked:

1. **Filling the FIFO**: Initially, I filled the FIFO with the first chunk of data to be transmitted.

2. **Initiating Transmission**: Then, I initiated the transmission process.

3. **Monitoring Free Space**: At this point, I continuously monitored GPIO2 to detect whether the FIFO had more than 31 free bytes available for data.

4. **Sending Additional Data**: Whenever GPIO2 indicated that there was space for an additional 31 bytes, I sent another chunk of data, and I repeated this process until the entire packet had been transmitted.

This approach allowed me to send all the required data using significantly less energy. By efficiently managing the FIFO, I achieved a substantial reduction in power consumption, making my project more energy-efficient while accommodating the transmission of larger packets.

#### The Advantages of Energy Efficiency

Since the device now uses less energy, this allowed me to opt for smaller coin cell batteries instead of larger Li-Po batteries. Coin cell batteries offer the benefit of compact size and significantly lower quiescent current, potentially enabling a battery life that spans decades. This also eliminates the need for a battery charging module, reducing the overall size of the project. They are also less likely to catch fire.

Currently, I've employed two stacked batteries to generate 6V, which I can then regulate down to 3.3V using an AMS1117 LDO (Low Dropout Regulator). The LDO is slightly smaller than the step-up circuit a single 3V battery would require. This dual-battery setup also provides me with a greater margin for energy usage compared to using just one battery. However, I'm open to the possibility of transitioning to a single battery design in the future.

## Conclusion
Overall, I find that this project has brought me to a new level of understanding about what goes on in the RF realm, invisible to all of us but ever present in our daily lives. I remain determined to produce a 280MHz carrier wave, which I think will be a remarkable feat once achieved. I also look forward to finishing the shell case of the final design, so that it can be more comfortable and durable for daily use.

I encourage you to explore the [GarageRemote GitHub Repository](https://github.com/Pablo-Ortiz-Lopez/GarageRemote)

Stay tuned for a post on how to build your own GarageRemote.