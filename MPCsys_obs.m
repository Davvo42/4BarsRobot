
%system

K = 1.53;
Tau = 0.0439;
G = tf(K,[Tau 1 0]);
A = [0 1; 0 -1/Tau];
B = [0 K/Tau]';
C = [1 0];
D = 0;
n=2;
p=1;


% Luenberger observer

MO = obsv(A, C);
L_desired_eigenvalues = [-400, -600];
L = acker(A', C', L_desired_eigenvalues)';
Aobs = A-L*C;
Bobs = [B, L];
Cobs = eye(2);
Dobs = zeros(2, 2);