 fc = 260;
 attack = 0.01;
 phi = 0;
 bw = 70;
 fs = 44100;
 amp = 0.029;
 %s = vector contain the time domain samples of a FOF
 


omega = 2*pi*fc; %omega = central frequency (in rad/sec)
beta = pi/attack; % beta = parameter for the width of the skirts (pi/beta = attack time in samples)
alpha = bw * pi; % alpha = 1/(decay time-constant in samples)

FormantLength = (-1)*log(0.001)/alpha;%total time length of the formant (decay to T60)

Ts=1/fs;
n = (0:Ts:FormantLength-Ts); %time vector

s = zeros(1,length(n));
n_attack = n(1:floor(pi/beta/Ts));
n_rest = n(ceil(pi/beta/Ts):end);
s(1:floor(pi/beta/Ts)) = amp * 0.5 .* (1-cos(beta.*n_attack)).*exp((-1)*alpha.*n_attack).*sin(omega.*n_attack+phi);
s(ceil(pi/beta/Ts):(length(n))) = amp * exp((-1)*alpha.*n_rest).*sin(omega.*n_rest+phi);

%plot spectrum
f = 0:fs/(length(s)):fs-fs/(length(s));
S=fft(s);
plot(f,20*log10(abs(S)));
xlim([0 fs/2]);
xline(fc,'--r','Center Frequency');
title('Formant spectrum');
xlabel('Frequency(kHz)');
ylabel('Magnitude(dB)');


%plot this formant signal
figure
plot(n,s);
title('Formant output signal');
xlabel('Time(s)');
ylabel('Amplitude');

