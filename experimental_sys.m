% List of parameters:
delay = 0.01/10;
K = 1.53;
tau = 0.0439/10;
approx_order = 1;


% Get the transfer function from the parameters
TF_nodelay1 = tf(K,[tau 1 0]);
TF_delay1 = exp(-delay * tf('s'));
TF1 = TF_nodelay1 * TF_delay1;
% What we got is a TF with 2 1+poles - 1 in the origin - and a delay
% By definition the static gain is infinite

TF2_nodelay = tf(K,[tau 1]);
TF2_delay = exp(-delay * tf('s'));
TF2 = TF2_nodelay * TF2_delay;

% Time domain analysis - step response
t = 0:0.01:100;
[y,t] = step(TF1, t);
% the step response of an integrator cannot be red in terms of overshoot
% and settling time, still we can appreaciate the delay
[z,t] = step(TF2, t);
% Settling time:
info = stepinfo(z, t, 'SettlingTimeThreshold', 0.01);
fprintf('Tempo di stabilizzazione al 1%%: %.2f secondi\n', info.SettlingTime);
fprintf('Sovraelongazione: %.2f%%\n', info.Overshoot);

% Frequency domain analysis

% Let's analyze first the TF_nodelay
[gain_margin1, phase_margin1, ~, wc1] = margin(TF_nodelay1);
% as expected the gain margin is infinite (the sys is an integrator), the
% phase margin is 86.4° and the cutoff frequency is 1.53 rad/s
poles1 = pole(TF_nodelay1);
% the system has 2 poles, 1 in 0 and the other in -24.1546: 
% the system is only stable...

% Now we need to analyze the TF with the delay, there are 2 ways:
% #1 By inspection of the bode diagram
% #2 By means of the Padé approximation

% BODE DIAGRAM
% wc = 1.53, so the effect of the delay is almost negligible: also the
% poles didn't vary significantly. -180° are instead reached at w = 322
% rad/s, so the gain margin is 69dB, the phase margin 86°.
% The system is stable but the margin of stability are huge

% PADE APPROXIMATION
[num_delay1, den_delay1] = pade(delay, approx_order);
[num_pade1, den_pade1] = series(num_delay1, den_delay1, TF_nodelay1.num{1}, TF_nodelay1.den{1});
TF_pade1 = tf(num_pade1, den_pade1);
[gain_margin_pade1, phase_margin_pade1, ~, wc_pade1] = margin(TF_pade1);
% The result even varying the order of approximation result the same

% The system is impressively robust, gain margin close to infinity and
% phase margin remarkable. This can also be observed by means of the
% nyquist plot of the TF_pade function
delay = 0.01;
TF_nodelay2 = tf(K,[tau 1 0]);
TF_delay2 = exp(-delay * tf('s'));
TF2 = TF_nodelay2 * TF_delay2;
% What we got is a TF with 2 poles - 1 in the origin - and a delay
% By definition the static gain is infinite
% Frequency domain analysis

% Let's analyze first the TF_nodelay
[gain_margin2, phase_margin2, ~, wc2] = margin(TF_nodelay2);
% as expected the gain margin is infinite (the sys is an integrator), the
% phase margin is 86.4° and the cutoff frequency is 1.53 rad/s
poles2 = pole(TF_nodelay2);
% the system has 2 poles, 1 in 0 and the other in -24.1546: 
% the system is only stable...

% Now we need to analyze the TF with the delay, there are 2 ways:
% #1 By inspection of the bode diagram
% #2 By means of the Padé approximation

% BODE DIAGRAM
% wc = 1.53, so the effect of the delay is almost negligible: also the
% poles didn't vary significantly. -180° are instead reached at w = 322
% rad/s, so the gain margin is 69dB, the phase margin 86°.
% The system is stable but the margin of stability are huge

% PADE APPROXIMATION
[num_delay2, den_delay2] = pade(delay, approx_order);
[num_pade2, den_pade2] = series(num_delay2, den_delay2, TF_nodelay2.num{1}, TF_nodelay2.den{1});
TF_pade2 = tf(num_pade2, den_pade2);
[gain_margin_pade2, phase_margin_pade2, ~, wc_pade2] = margin(TF_pade2);


delay = 0.01*10;
TF_nodelay3 = tf(K,[tau 1 0]);
TF_delay3 = exp(-delay * tf('s'));
TF3 = TF_nodelay3 * TF_delay3;
% What we got is a TF with 2 poles - 1 in the origin - and a delay
% By definition the static gain is infinite
% Frequency domain analysis

% Let's analyze first the TF_nodelay
[gain_margin3, phase_margin3, ~, wc3] = margin(TF_nodelay3);
% as expected the gain margin is infinite (the sys is an integrator), the
% phase margin is 86.4° and the cutoff frequency is 1.53 rad/s
poles3 = pole(TF_nodelay3);
% the system has 2 poles, 1 in 0 and the other in -24.1546: 
% the system is only stable...

% Now we need to analyze the TF with the delay, there are 2 ways:
% #1 By inspection of the bode diagram
% #2 By means of the Padé approximation

% BODE DIAGRAM
% wc = 1.53, so the effect of the delay is almost negligible: also the
% poles didn't vary significantly. -180° are instead reached at w = 322
% rad/s, so the gain margin is 69dB, the phase margin 86°.
% The system is stable but the margin of stability are huge

% PADE APPROXIMATION
[num_delay3, den_delay3] = pade(delay, approx_order);
[num_pade3, den_pade3] = series(num_delay3, den_delay3, TF_nodelay3.num{1}, TF_nodelay3.den{1});
TF_pade3 = tf(num_pade3, den_pade3);
[gain_margin_pade3, phase_margin_pade3, ~, wc_pade3] = margin(TF_pade3);

figure;

h1 = bodeplot(TF_pade1);
hold on;
h2 = bodeplot(TF_pade2);
h3 = bodeplot(TF_pade3);

legend('d = 0.01/10', 'd = 0.01', 'd = 0.01*10');
grid on;

% Aggiungere titoli e etichette
title('Bode Diagrams with different delays');