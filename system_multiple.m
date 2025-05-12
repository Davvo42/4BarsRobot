% Define the transfer function elements
G11 = tf(1.53, [0.0439 1 0]);
G12 = 0;
G21 = 0;
G22 = G11;
% Construct the transfer function matrix
G = [G11 G12; G21 G22];
% Display the transfer function matrix
disp('Transfer Function Matrix G(s):');
G
% Step response of the MIMO system
figure;
step(G);
title('Step Response of the MIMO System');
grid on;
% Analyze the poles and zeros
figure;
pzmap(G);
title('Pole-Zero Map of the MIMO System');
grid on;
% Calculate step response characteristics for each element
info_G11 = stepinfo(G11);
info_G12 = stepinfo(G12);
info_G21 = stepinfo(G21);
info_G22 = stepinfo(G22);
% Display step response characteristics
disp('Step Response Characteristics of G11:');
disp(info_G11);
disp('Step Response Characteristics of G12:');
disp(info_G12);
disp('Step Response Characteristics of G21:');
disp(info_G21);
disp('Step Response Characteristics of G22:');
disp(info_G22);
% Define a frequency (in rad/s) at which to evaluate the condition number
frequency = 400; % For example, 1 rad/s

% Compute the frequency response at the specified frequency
G_freq_response = evalfr(G, 1i*frequency);

% Calculate the condition number of the frequency response matrix
condNumber = cond(G_freq_response);

% Display the condition number
disp(['Condition Number at ', num2str(frequency), ' rad/s: ', num2str(condNumber)]);