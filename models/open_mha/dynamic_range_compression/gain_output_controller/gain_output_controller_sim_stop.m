% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Calculate the Results

% Desired output is a signal showing gain values corresponding to frequency
% band numbers for easy validation
for i = 1:4   
    adjusted_gain_signal = [adjusted_gain_signal 1.*ones(1,band_sizes(1)) 2.*ones(1,band_sizes(2)) 3.*ones(1,band_sizes(3)) 4.*ones(1,band_sizes(4)) 5.*ones(1,band_sizes(5)) 6.*ones(1,band_sizes(6)) 7.*ones(1,band_sizes(7)) 8.*ones(1,band_sizes(8)) 8.*ones(1,band_sizes(8)-1) 7.*ones(1,band_sizes(7)) 6.*ones(1,band_sizes(6)) 5.*ones(1,band_sizes(5)) 4.*ones(1,band_sizes(4)) 3.*ones(1,band_sizes(3)) 2.*ones(1,band_sizes(2)) 1.*ones(1,band_sizes(1)-1) ones(1,44)];
end

%% Plot Results

if debug == true
    figure()
    plot(adjusted_gain_signal(72:length(gain_sim_out)),'r');
    hold on;
    plot(gain_sim_out(72:end),'g--');
    hold off;
    legend('MATLAB','Simulink','Location','southeast');
    title('Gain Outputs');
    xlabel('Sample Number');
    ylabel('Gain Value (linear factor)');
    
    figure()
    plot(real(FFT_data_sim_out));
    legend('Simulink','Location','southeast');
    title('Real Part of FFT Data (Post Gain Application)');
    xlabel('Sample Number');
    ylabel('FFT Data - Real Component');
    
else 
    figure()
    plot(gain_sim_out(72:end),'g');
    legend('Simulink');
    title('Gain Output');
    xlabel('Sample Number');
    ylabel('Gain Value (linear factor)');
    
    figure()
    plot(real(FFT_data_sim_out));
    legend('Simulink');
    title('Real Part of FFT Data (Post Gain Application)');
    xlabel('Sample Number');
    ylabel('FFT Data - Real Component');
    
end

