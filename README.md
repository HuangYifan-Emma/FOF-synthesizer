# FOF-synthesizer
The goal of this project is to implement the famous FOF synthesis techniques(Formant wave function). In this project, the FOFsynthesis of a human voice is implemented in two version. One is in MATLAB (for course MUMT-501), mainly focus on the paper in 1980 by Rodet to implement the algorithm and explore the spectrum of the output signal. Another is written in stk C++ (for course MUMT-307), focus on the real-time implementaton and also add some audio effects like chorus effect, vibrato, and amplitude modulation to make it more natural.

## MATLAB Implementation
**Simple usage**

  - download FOFfuncton.m, OverlapAdding.m, and FOFsynthesizer.m 
  - put them into one folder
  - run the FOFsynthesizer.m 
  
**File illustration**

- FOFfuncton.m: perform one formant FOF
- OverlapAdding.m: perform overlapp adding 
- FOFsynthesizer.m: main body to realize FOF synthesis

**Other useful files to understand the algorithm**
- fofalgorithm.m: is used to generate impulse response of one formant, it is useful to figure out the what is going on in spectra of FOF
- FOFsyn1formant,m: is used to generate the output (both in time domain and spectral domain) of one formant with the input of an impulse train. It is useful to observe the function of the parameters.

## C++ stk Implementation

**Design Idea**
- Each FOF formant is constructed as a class in C++. 
- FOF algorithm and overlap adding is implemented as the function in the class. 
- The main function is for FOF synthesis of 5 formants of a human voice
- It is run in real time

**Compile and run in mac OS**: g++ -std=c++11 -Istk/include/ -Lstk/src/ -D__MACOSX_CORE__ FOFsynthesizer.cpp -lstk -lpthread -framework CoreAudio -framework CoreMIDI -framework CoreFoundation -o FOFsynthesizer && ./FOFsynthesizer
