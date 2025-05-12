function [ xkp1, yk ] = model_step(xk, uk, tau)
    % model_step
    % Function implementing the discrete-time evolution of the system state x(k+1) and output y(k).
    % Obtained discretizing the system dynamics via Forward Euler.
    %
    % x(k+1) = f(x(k), u(k))
    % y(k) = x(k)
    
    K = 1.53;
    Tau = 0.0439;
    
    
    x1dot = xk(2);
    x2dot = -xk(2)/Tau +K/Tau*uk;
    
    % Discretization via Forward Euler
    xkp1 = [ xk(1) + tau * x1dot;
             xk(2) + tau * x2dot; ];
    yk = xk(1);

end