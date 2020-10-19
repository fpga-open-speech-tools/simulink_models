%#codegen
function Z = mlhdlc_fsm_moore(A)
% Moore State Machine

%------------------------------------------------------------------------%
% The following is an example Moore State Machine copied from the MATLAB
% documentation. Note that state variables should contain numerical values,
% and that the otherwise statement should be included to ensure that the
% model accounts for all conditions.
%------------------------------------------------------------------------%

% y = f(x) : 
% all actions are state actions and 
% outputs are pure functions of state only 

% define states
S1 = 0;
S2 = 1;
S3 = 2;
S4 = 3;


% using persistent keyword to model state registers in hardware
persistent curr_state;
if isempty(curr_state)
    curr_state = S1;   
end

% switch to new state based on the value state register
switch (curr_state)
    
    case S1,
        
        % value of output 'Z' depends only on state and not on inputs
        Z = true;
        
        % decide next state value based on inputs
        if (~A)
            curr_state = S1;
        else
            curr_state = S2;
        end
        
    case S2,
        
        Z = false;
        
        if (~A)
            curr_state = S1;
        else
            curr_state = S3;
        end
        
    case S3,
        
        Z = false;
        
        if (~A)
            curr_state = S2;
        else
            curr_state = S4;
        end
        
    case S4,
        
        Z = true;
        if (~A)
            curr_state = S3;
        else
            curr_state = S1;
        end
        
    otherwise,
        Z = false;
end