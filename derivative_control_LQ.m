K = 1.53;
tau = 0.0439;
G = tf(K,[tau 1 0]);

A = [0 1; 0 -1/tau];
B = [0 K/tau]';
C = [1 0];
D = 0;
n=2;
p=1;
m = 1;

A_eng = [A, [0; 0];- C 0]
B_eng = [B; -D]
M_eng = [0; 0; 1]

%CONDITIONS FOR THE ENLARGEMENT
MR = ctrb(A,B);
rank(MR)==n;

MO = obsv(A, C);
rank(MO)==n;

tzero(A, B, C, D)

% LQ parameters
Q = eye(n+p);
R = eye(m);
W_cut = 10;

% LQ hypothesis
rank(ctrb(A_eng + 0.05*eye(n+p), B_eng)) == n+p
rank(obsv(A_eng + 0.05*eye(n+p), sqrt(Q))) == n+p

% LQ implementation
Klq = lqr(A_eng + W_cut*eye(n+p), B_eng, Q, R)
Klq_x = Klq(:, 1:n);
Klq_eta = Klq(:, n+1:end);

% Luenberger observer
MO = obsv(A, C);
L_desired_eigenvalues = [-400, -600];
L = [0 0]';
Aobs = A-L*C;
Bobs = [B, L];
Cobs = eye(2);
Dobs = zeros(2, 2);

% Cutoff freq

AA = [ A,       -B*Klq_eta,     -B*Klq_x;       -C,      -D*Klq_eta,     -D*Klq_x;
       L*C,     -B*Klq_eta,     Aobs-B*Klq_x];

BB = [ zeros(n, p);       eye(p);
       zeros(n, p) ];

CC = [ C, zeros(p, p), zeros(p, n) ];

[num,den] = ss2tf(AA, BB,CC, 0);
colse_loop_tf_1 = tf(num,den)
