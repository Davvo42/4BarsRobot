% List of parameters:
delay = 0.01;
K = 1.53;
tau = 0.0439;
approx_order = 1;

% Get the transfer function from the parameters
TF_nodelay = tf(K,[tau 1 0]);
TF_delay = exp(-delay * tf('s'));
TF = TF_nodelay * TF_delay;
% What we got is a TF with 2 poles - 1 in the origin - and a delay
% By definition the static gain is infinite

% Frequency domain analysis - step response
t = 0:0.01:100;
[y,t] = step(TF, t);
% the step response of an integrator cannot be red in terms of overshoot
% and settling time, still we can appreaciate the delay


% Frequency domain analysis

% Let's analyze first the TF_nodelay
[gain_margin, phase_margin, ~, wc] = margin(TF_nodelay);
% as expected the gain margin is infinite (the sys is an integrator), the
% phase margin is -94.49 + 360 and the cutoff frequency is 1.53 rad/s
poles = pole(TF_nodelay);
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
[num_delay, den_delay] = pade(delay, approx_order);
[num_pade, den_pade] = series(num_delay, den_delay, TF_nodelay.num{1}, TF_nodelay.den{1});
TF_pade = tf(num_pade, den_pade);
[gain_margin_pade, phase_margin_pade, ~, wc_pade] = margin(TF_pade);
% The result even varying the order of approximation result the same

% The system is impressively robust, gain margin close to infinity and
% phase margin remarkable. This can also be observed by means of the
% nyquist plot of the TF_pade function

% SENSITIVITY TO PARAMETERS
% Again we can go for 2 approaches, the first is by means of experiments:
% the code will try every combination of the three parameters (K, delay,
% tau) according to the elements of the following test_vector, in general
% K test = K original * test_vector(element)

parameter_tests = {};
test_vector = [0.95, 0.9, 0.8, 0.75, 1.1, 1.2, 1.25];

for i = 1:length(test_vector)
    K_test = K*test_vector(i);
    
    for j = 1:length(test_vector)
        tau_test = tau*test_vector(j);
    
        for k = 1:length(test_vector)
            delay_test = delay*test_vector(k);

            TF_nodelay_test = tf(K_test,[tau_test 1 0]);
            [num_delay, den_delay] = pade(delay_test, approx_order);
            [num_pade, den_pade] = series(num_delay, den_delay, TF_nodelay_test.num{1}, TF_nodelay_test.den{1});
            TF_pade_test = tf(num_pade, den_pade);
            [gain_margin_pade_t, phase_margin_pade_t, ~, wc_pade_t] = margin(TF_pade_test);
            parameter_tests{end+1} = [gain_margin_pade_t, phase_margin_pade_t, wc_pade_t];

        end
    end
end

% By changing the test vector one can perform several test, the result is
% that indeed the system considered is impressively resistent to
% sensitivity of the parameters

% Let's now extract the worst gain margin, phase margin and cutoff
% frequency we can have
min_gain_margin = min(cellfun(@(x) x(1), parameter_tests));
min_phase_margin = min(cellfun(@(x) x(2), parameter_tests));
min_cutoff_frequency = min(cellfun(@(x) x(3), parameter_tests));


% Another approach is by inspection of the derivative, done in the py file