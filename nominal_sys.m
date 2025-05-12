% List of parameters:
K = 1.53;
tau = 0.0439;

% Get the transfer functions from the parameters
TF = tf(K,[tau 1 0]);
% What we got is a TF with 2 poles - 1 in the origin
% By definition the static gain is infinite
TF2 = tf(K,[tau 1 ]);
% Time domain analysis - step response with integrator
t = 0:0.001:100;
[y,t] = step(TF, t);
[z,t] = step(TF2, t);
% the step response of an integrator cannot be red in terms of overshoot
% and settling time, still we can appreaciate the delay

% Settling time:
info = stepinfo(z, t, 'SettlingTimeThreshold', 0.01);
fprintf('Tempo di stabilizzazione al 1%%: %.2f secondi\n', info.SettlingTime);
fprintf('Sovraelongazione: %.2f%%\n', info.Overshoot);

% Frequency domain analysis
% Let's analyze the TF
[gain_margin, phase_margin, ~, wc] = margin(TF);
% as expected the gain margin is infinite (the sys is an integrator), the
% phase margin is 86.26° and the cutoff frequency is 1.53 rad/s
poles = pole(TF);
% the system has 2 poles, 1 in 0 and the other in -23.36: 
% the system is only stable