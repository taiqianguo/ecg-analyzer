This project is based on pynq system, aiming at study IIC ptotocol implementation and DSP as well as interfaces between PL and PS system .
This project include a pluse sensor which sensing electrocardiography as analog value output and collected by ADC module ADS1115, ADS1115 mudule use IIC protocol connected to PL GPIO.
The design of analog defection filter out 50HZ eletric power noise , and the noise from baseline wander is tackled by an average digital filter 
for the reason that the baseline wandering has very low freqency ranging around 1HZ ( mostly from breathing), and is hard to be filtered by analog filter.

During the design of IIC protocol for ADS115, I gain a good experience from hardware level how communication initialized, how and when the transfer and ACK happened.
after this IIC implementation, i recalled from textbook, how the throughput and delay are estimated , 
then get a better understanding the essences of IIC is a ' low speed peripheral deveice'.
This part i studied and referred from  https://learn.lushaylabs.com/i2c-adc-micro-procedures
An elegant design based on finite state machines, what i learned from this design 
is that the protocol can be divided into independent FSMs , with appropraite partition, the design complexity can be significantly reduced.

As for digital filter, theoritically, ECG signal requires dedicated complex filters in order to promise performance including interference repression and real time character.
But here for study purposises, only a simple average filter to reduce breath interference, basically we subtract the value from that average filter.
Here the delay of digital filter must be well considered .

Finally , the asyncronous recieve and pipline of data been processed in PS part (arm core) must be considered. 
By using FIFO data sturcture and multi thread, we reduced the waiting during transfer before processing heart rate counting and ecg distortion analysis.

![image](https://github.com/taiqianguo/ecg-analyzer/assets/58079218/fad51e88-98e7-48bc-8ea6-06905d269466)
![image](https://github.com/taiqianguo/ecg-analyzer/assets/58079218/fb45d1e0-aa4d-4125-98d8-66aeae5b1673)


