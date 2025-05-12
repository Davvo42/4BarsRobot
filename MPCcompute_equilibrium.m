function [x_bar, u_bar] = compute_equilibrium(x1_ref)
    % compute_equilibrium
    % Compute the equilibrium (x_bar, u_bar) such that x1_bar = x1_ref

    K = 1.53;
    tau = 0.0439;
    
    x1_bar = x1_ref;
    x2_bar = 0;

    u_bar = 0;
    x_bar = [ x1_bar;
              x2_bar ];
    
end
