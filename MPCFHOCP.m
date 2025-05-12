function u_opt = FHOCP(xk, Q, R, N, x_bar, u_bar, tau_s)
    % FHOCP
    % Solve the Finite Horizon Control Optimization Problem
    
    % Parameters
    % - xk: The current state
    % - Q: The state weight
    % - R: The input weight
    % - N: The prediction horizon
    % - x_bar: The target state equilibrium
    % - u_bar: The target input equilibrium
    % - tau_s: the sampling time
       
    % Import the CasADi toolkit
    import casadi.*;
    opti = casadi.Opti();
    
    % Declare the optimization variables
    u = opti.variable(1, N);   
    x = opti.variable(2, N+1);
    
    % Initial state
    opti.subject_to(x(:, 1) == xk);
    
    % Input constraints
    opti.subject_to(-10 <= u <= 10);
    
    % State constraints
    %opti.subject_to(0.1 <= x(1, :) <= 1.3);
    %opti.subject_to(0.1 <= x(2, :) <= 1.2);
    
    % Terminal constraint
    opti.subject_to(x(:, end) == x_bar);
    
    % Cost function initialization
    J = 0;
    
    for ii=1:N
        % Compute x(k+1) = x(k) + f(x(k), u(k)) * Ts
        [ xkp1, ~ ] = model_step(x(:, ii), u(:, ii), tau_s);
        
        % System dynamics constraint
        opti.subject_to(x(:, ii+1) == xkp1);
        
        % Cost function function
        J = J ...
            + (u(:, ii) - u_bar).' * R * (u(:, ii) - u_bar) ...
            + (x(:, ii) - x_bar).' * Q * (x(:, ii) - x_bar);
    end
    
    % Set the initial guess
    % x(k+i|k) = x(k) ∀i = 1, ..., N
    opti.set_initial(x, repmat(xk, 1, N+1));    
    % u(k+i|k) = wn
    opti.set_initial(u, repmat(1e-4, 1, N)); 
    
    % Declare the cost function
    opti.minimize(J);                   % We shall minimize J
    
    % CASADI settings
    prob_opts = struct;
    prob_opts.expand = true;
    prob_opts.ipopt.print_level = 0;    % Disable printing
    prob_opts.print_time = false;       % Do not print the timestamp
    
    % IPOPT settings
    ip_opts = struct;
    ip_opts.print_level = 0;            % Disable printing
    ip_opts.max_iter = 1e5;             % Maximum iterations
    ip_opts.compl_inf_tol = 1e-6;
    
    % Set the solver
    opti.solver('ipopt', prob_opts, ip_opts);
    
    try
        % SOLVE THE FHOCP
        sol = opti.solve();
        
        % Extract the optimal control action
        u_opt = sol.value(u(:, 1));
        
    catch EX
        keyboard;
    end
end
