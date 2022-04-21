function s=FOFfunction(fc,attack,bw,phi,amp,fs)
% fc = center frequency
% attack = attack time in sampless
% phi = phase (in radians)
% bw = bandwidth in samples
% amp = amplitude of each formant
% fs = sample rate
% s = vector contain the time domain samples of a FOF

omega = 2*pi*fc; %omega = central frequency (in rad/sec)
beta = pi/attack; % beta = parameter for the width of the skirts (pi/beta = attack time)
alpha = bw * pi; % alpha = 1/(decay time-constant)

FormantLength = (-1)*log(0.001)/alpha;%total time length of the formant (decay to T60)

Ts=1/fs;
n = (0:Ts:FormantLength-Ts); %time vector

s = zeros(1,length(n));
n_attack = n(1:floor(pi/beta/Ts));
n_rest = n(ceil(pi/beta/Ts):end);
s(1:floor(pi/beta/Ts)) = amp * 0.5 .* (1-cos(beta.*n_attack)).*exp((-1)*alpha.*n_attack).*sin(omega.*n_attack+phi);
s(ceil(pi/beta/Ts):(length(n))) = amp * exp((-1)*alpha.*n_rest).*sin(omega.*n_rest+phi);

end


    