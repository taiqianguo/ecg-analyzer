This project is based on the PYNQ system, aiming to study I2C protocol implementation and DSP, as well as interfaces between the PL and PS systems. 

The project includes a pulse sensor that senses electrocardiography as an analog value output and is collected by the ADC module ADS1115. The ADS1115 module uses the I2C protocol connected to PL GPIO. The design of the analog detection filter filters out 50Hz electric power noise, and the noise from baseline wander is tackled by an average digital filter. The reason for this is that baseline wandering has a very low frequency, around 1Hz (mostly from breathing), and is hard to be filtered by analog filters.

During the design of the I2C protocol for ADS1115, I gained valuable experience at the hardware level about how communication is initialized, and how and when the transfer and ACK occur. After this I2C implementation, I recalled from textbooks how throughput and delay are estimated, and then gained a better understanding that the essence of I2C is a 'low-speed peripheral device'. This part I studied and referred to from https://learn.lushaylabs.com/i2c-adc-micro-procedures. An elegant design based on finite state machines taught me that the protocol can be divided into independent FSMs. With appropriate partitioning, the design complexity can be significantly reduced.

As for the digital filter, theoretically, the ECG signal requires dedicated complex filters to ensure performance including interference suppression and real-time characteristics. However, here for study purposes, only a simple average filter is used to reduce breath interference; basically, we subtract the value from that average filter. The delay of the digital filter must be well considered.

The connection between PL and PS uses the AXI GPIO port. The IP using AXI to simulate GPIO between PS and PL transfers ecg data (16-bit in parallel) and the 'data_ready' signal from PL to PS.

Finally, the asynchronous receive and pipeline of data being processed in the PS part (ARM core) must be considered. By using a FIFO data structure and multithreading, we reduced the waiting during transfer before processing heart rate counting and ECG distortion analysis

<img src="https://github.com/taiqianguo/ecg-analyzer/assets/58079218/fad51e88-98e7-48bc-8ea6-06905d269466" width="200">
<img src="https://github.com/taiqianguo/ecg-analyzer/assets/58079218/fb45d1e0-aa4d-4125-98d8-66aeae5b1673" width="200">




