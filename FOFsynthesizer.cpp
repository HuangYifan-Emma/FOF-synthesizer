// FOFsynthesizer.cpp
// compile: g++ -std=c++11 -Istk/include/ -Lstk/src/ -D__MACOSX_CORE__ FOFsynthesizer.cpp -lstk -lpthread -framework CoreAudio -framework CoreMIDI -framework CoreFoundation -o FOFsynthesizer && ./FOFsynthesizer


#include "RtWvOut.h"
#include "JCRev.h"
#include "Modulate.h"
#include "Chorus.h"
#include <cmath>
#include <vector>

using namespace stk;

class FOFGenerator
{
public:
  FOFGenerator(float amplitude, float attackTime, float centerFrequency,
               float bandwidth, float sampleRate = 44100, float phase = 0)
      : amplitude(amplitude),
        attackTime(attackTime), centerFreq(centerFrequency),
        bandwidth(bandwidth), sampleRate(sampleRate), phase(phase)
  {
    float alpha = bandwidth * M_PI;
    const int totalLength = static_cast<int>(-log(0.001) / alpha * sampleRate);
    FOF_IR.resize(totalLength);
    initialIR();
  }
  ~FOFGenerator() {}

  float getValueAtSampleN(int n, float f0)
  {
    const float interval = sampleRate / f0;
    int endPosition = n >= FOF_IR.size() ? FOF_IR.size() : n;

    float result = 0;
    for (int pulse = n % static_cast<int>(std::round(interval));
         pulse < endPosition;
         pulse += interval)
    {
      result += FOF_IR[pulse];
    }
    return result;
  }

  std::vector<float> getIR() { return FOF_IR; }

private:
  const float amplitude;
  const float attackTime;
  const float centerFreq;
  const float bandwidth;
  const float phase;
  const float sampleRate;
  std::vector<float> FOF_IR;

  void initialIR()
  {
    float alpha = bandwidth * M_PI;
    float beta = M_PI / attackTime;
    const float Ts = 1 / sampleRate;
    for (int k = 0; k < FOF_IR.size(); k++)
    {
      if (k <= M_PI / (attackTime * Ts))
      {
        FOF_IR[k] = 0.5 * (1 - cos(beta * k * Ts)) * exp(-alpha * k * Ts) *
                    sin(centerFreq * 2 * M_PI * k * Ts + phase);
      }
      else
      {
        FOF_IR[k] =
            exp(-alpha * k * Ts) * sin(centerFreq * 2 * M_PI * k * Ts + phase);
      }
    }
    for (int i = 0; i < FOF_IR.size(); i++)
    {
      // scale by amplitude
      FOF_IR[i] *= amplitude;
    }
  }
};

int main()
{
  const int SampleRate = 44100;
  const int f0 = 220;
  //const double alpha = 100 * M_PI;
  // const double Ts = 1 / SampleRate;
  const float Dur = 5; // Duration time /second
  // const int NumFOF = 5;

  Stk::setSampleRate(SampleRate);
  JCRev reverb(2.0);
  Modulate modulator;
  modulator.setVibratoRate(0.0);//5
  modulator.setVibratoGain(0.0);//0.3
  Chorus chorusEffect;
  chorusEffect.setModDepth(0.002);//0.002
  chorusEffect.setModFrequency(6);
  // Blit blit;
  // blit.setFrequency(f0);
  //int FOFLength = -log(0.001) / alpha; // t60 amplitude=0.001, n is the sample length
  // double FOF_IR[FOFLength];

  FOFGenerator formant1(0.029, 0.002, 260, 70, SampleRate);
  FOFGenerator formant2(0.021, 0.0015, 1764, 45, SampleRate);
  FOFGenerator formant3(0.0146, 0.0015, 2510, 80, SampleRate);
  FOFGenerator formant4(0.011, 0.003, 3090, 130, SampleRate);
  FOFGenerator formant5(0.00061, 0.001, 3310, 150, SampleRate);

  unsigned int nFrames = SampleRate * Dur;



  // Create a one-channel realtime output object.
  RtWvOut output(2);
  output.start();

  // Start the runtime loop and run for nFrames.

  float formantFreq = f0;
  for (unsigned int n = 0; n < nFrames; n++)
  {
    StkFloat FOFOutput = formant1.getValueAtSampleN(n, formantFreq) +
    formant2.getValueAtSampleN(n, formantFreq) +
    formant3.getValueAtSampleN(n, formantFreq) +
    formant4.getValueAtSampleN(n, formantFreq) +
    formant5.getValueAtSampleN(n, formantFreq);
    output.tick(reverb.tick(chorusEffect.tick((modulator.tick() + 0.8) * FOFOutput)));
  }
  return 0;
}
