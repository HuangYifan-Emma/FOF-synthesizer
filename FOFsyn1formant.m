f0 = 440; %fundemental frequency
Fc = [300 1764 2510 3090 3310];
Attack = [0.006 0.0015 0.0015 0.003 0.001];
Phi = [0 0.5*pi 0 0 0];
BW = [50 45 80 130 150];
Amp = [0.029 0.021 0.0146 0.011 0.00061];
N = 1;
fs = 44100;

duration = 2;
Ts=1/fs;
t = (0:Ts:duration-Ts); %time vector
y = zeros(1,length(t));

formant1 = FOFfunction(Fc(1),Attack(1),BW(1),Phi(1),Amp(1),fs);



    
for i = 0:length(y)-1
    y(i+1) = OverlapAdding(i, f0, fs, formant1);
end

plot((10000:11000),y(10000:11000));
title('FOFsynthesizer Output');
xlabel('Sample');
ylabel('Amplitude');
soundsc(y,fs);
audiowrite('OneFormant.wav',y,fs);

%plot spectrum
figure
f = 0:fs/(length(y)):fs-fs/(length(y));
Y=fft(y);
plot(f,20*log10(abs(Y)));
xlim([0 fs/2]);
xline(f0,'--r','Fundamental Frequency');
title('FOFsynthesizer spectrum');
xlabel('Frequency(kHz)');
ylabel('Magnitude(dB)');
