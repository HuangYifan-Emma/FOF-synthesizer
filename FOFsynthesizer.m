%function y = FOFsynthesizer(Fc,Attack,BW,Phi,Amp,N,fs)
% Fc = vector of center frequencies for the FOFs
% Attack = vector of attack time in samples
% Phi = vector of phase (in radians)
% BW = vector of bandwidth in samples
% Amp = vector of amplitude of each formant
% N = numbers of FOFs desired
% fs = sample rate
% y = vector contain the result of FOF synthesizer

f0 = 210; %fundemental frequency
Fc = [260 1764 2510 3090 3310];
Attack = [0.002 0.0015 0.0015 0.003 0.001];
Phi = [pi 0 0 0 0];%Phi = [0 pi 0 0 0]
BW = [70 45 80 130 150];
Amp = [0.029 0.021 0.0146 0.011 0.00061];
N = 5;
fs = 44100;

duration = 2;
Ts=1/fs;
t = (0:Ts:duration-Ts); %time vector
y = zeros(1,length(t));

formant1 = FOFfunction(Fc(1),Attack(1),BW(1),Phi(1),Amp(1),fs);
formant2 = FOFfunction(Fc(2),Attack(2),BW(2),Phi(2),Amp(2),fs);
formant3 = FOFfunction(Fc(3),Attack(3),BW(3),Phi(3),Amp(3),fs);
formant4 = FOFfunction(Fc(4),Attack(4),BW(4),Phi(4),Amp(4),fs);
formant5 = FOFfunction(Fc(5),Attack(5),BW(5),Phi(5),Amp(5),fs);


    
for i = 0:length(y)-1
    y(i+1) = OverlapAdding(i, f0, fs, formant1)+OverlapAdding(i, f0, fs, formant2)+OverlapAdding(i, f0, fs, formant3)+OverlapAdding(i, f0, fs, formant4)+OverlapAdding(i, f0, fs, formant5);
end

plot((1000:1500),y(1000:1500));
title('FOFsynthesizer Output');
xlabel('Sample');
ylabel('Amplitude');
soundsc(y,fs);
audiowrite('FOFVoice.wav',y,fs);

%plot spectrum
figure
f = 0:fs/(length(y)):fs-fs/(length(y));
Y=fft(y);
plot(f,20*log10(abs(Y)));
xlim([0 fs/2]);
%xline(f0,'--r','Foundamental Frequency');
title('FOFsynthesizer spectrum');
xlabel('Frequency(kHz)');
ylabel('Magnitude(dB)');
