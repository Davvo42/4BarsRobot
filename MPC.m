classdef MPC < matlab.System
    % MPC Model Predictive Control Block
   
    % Define the properties of the block, that can be changed 
    properties(Nontunable)
        % N Prediction Horizon
        N = 100;
        % Q Q Matrix
        Q = [100 0; 0 1];
        % R R Matrix
        R = 1;
        % tau_s Sampling Time
        tau_s = 0.01;
    end


    methods(Access = protected)
        
        function u_opt = stepImpl(obj, xk, x1_ref)
            
            % Given y_ref, compute (x_bar, u_bar)
            [x_bar, u_bar] = compute_equilibrium(x1_ref);
            % Solve the FHOCP
            u_opt = FHOCP(xk, obj.Q, obj.R, obj.N, x_bar, u_bar, obj.tau_s);

        end


        function n_in = getNumInputsImpl(~)

            % Define total number of input signals of the block
            n_in = 2;

        end

        function n_out = getNumOutputsImpl(~)

            % Define total number of output signal of the block
            n_out = 1;

        end

        function out_size = getOutputSizeImpl(~)

            % Return the size of the output signal
            out_size = [1 1];

        end

        function out = getOutputDataTypeImpl(~)

            % Return data type for each output port
            out = "double";

        end

        function out = isOutputComplexImpl(~)

            % Return true for each output port with complex data
            out = false;

        end

        function out = isOutputFixedSizeImpl(~)

            % Return true for each output port with fixed size
            out = true;

        end

        function sts = getSampleTimeImpl(obj)

            % Define sample time type and parameters
            sts = obj.createSampleTime("Type", "Discrete", "SampleTime", obj.tau_s);

        end

    end

end