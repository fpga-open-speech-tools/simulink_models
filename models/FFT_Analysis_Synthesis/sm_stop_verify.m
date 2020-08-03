%% Verification
function mp = sm_stop_verify(mp)
% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.
mp.left_error_max  = max(abs(mp.test_signal.left(:)-mp.left_data_out(:)));
mp.right_error_max = max(abs(mp.test_signal.left(:)-mp.right_data_out(:)));
mp.precision = 2^(-mp.F_bits);
% display popup message
    str1 = [' Max Left Error = ' num2str(mp.left_error_max) '\n Max Right Error = ' num2str(mp.right_error_max)];
if (mp.left_error_max <= mp.precision) && (mp.right_error_max <= mp.precision)
    str1 = [str1 '\n Error is within exceptable range \n Least significant bit precision (F_bits = ' num2str(mp.F_bits) ') is ' num2str(2^(-mp.F_bits))];
    helpdlg(sprintf(str1),'Verification Message: Passed')
else
    str1 = [str1 '\n Error is **NOT** within exceptable range \n Least significant bit precision (F_bits = ' num2str(mp.F_bits) ') is ' num2str(2^(-mp.F_bits))];
    helpdlg(sprintf(str1),'Verification Message: Failed')
end

%%
