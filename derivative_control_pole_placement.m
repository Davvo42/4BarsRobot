K = 1.53;
tau = 0.0439;
G = tf(K,[tau 1 0]);

A = [0 1; 0 -1/tau];
B = [0 K/tau]';
C = [1 0];
D = 0;
n=2;
p=1;

A_eng = [A, [0; 0];- C 0]
B_eng = [B; -D]
M_eng = [0; 0; 1]

%CONDITIONS FOR THE ENLARGEMENT
MR = ctrb(A,B);
rank(MR)==n;

MO = obsv(A, C);
rank(MO)==n;

tzero(A, B, C, D)

% pole placement
pp_desired = [-40, -60];
Kp = acker(A,B, pp_desired);


p_eng_desired = [pp_desired, -17];
K_eng = acker(A_eng,B_eng, p_eng_desired);

 K_x = K_eng(:, 1:n)
 K_v = K_eng(:, n+1:end)

% Luenberger observer
MO = obsv(A, C);
L_desired_eigenvalues = [-400, -600];
L = [0 0]';
Aobs = A-L*C;
Bobs = [B, L];
Cobs = eye(2);
Dobs = zeros(2, 2);

% Cutoff freq

AA = [ A,       -B*K_v,     -B*K_x;       -C,      -D*K_v,     -D*K_x;
       L*C,     -B*K_v,     Aobs-B*K_x];

BB = [ zeros(n, p);       eye(p);
       zeros(n, p) ];

CC = [ C, zeros(p, p), zeros(p, n) ];

[num,den] = ss2tf(AA, BB,CC, 0);
colse_loop_tf_1 = tf(num,den)
