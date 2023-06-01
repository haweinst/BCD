% Find a VISA-USB object.

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
close all; clear all;
instrreset;
filename = "phase_pulse_on";
obj1 = visa('NI', 'USB0::0x0699::0x052C::SGVJ0002506::0::INSTR');
num_pts = 2e6;
chan = 1;

obj1.InputBufferSize = num_pts*4;

% Connect to instrument object, obj1.
fopen(obj1);

fprintf(obj1,[':DATa:SOUrce CH' num2str(chan)]);
fprintf(obj1,':DATa:STARt 1');
fprintf(obj1,[':DATa:STOP ' num2str(num_pts)]);
fprintf(obj1,':DATa:ENCdg ASCIi');
preamble = query(obj1,':WFMOutpre?');
preC = strsplit(preamble,';');
bytesperpoint = str2double(preC{1}); bitsperpoint = str2double(preC{2});
encoding = preC{3}; bifmt = preC{4}; bitorder = preC{5};
WFID = preC{6}; num_pts_dev = preC{7}; %pt_fmt = preC{8}; pt_order = preC{9};
xunit = preC{10}; xinc = str2double(preC{11}); xzero = str2double(preC{12}); % pt_off = preC{13};
yunit = preC{14}; ymult = str2double(preC{15}); 
yoff = str2double(preC{16}); yzero = str2double(preC{16});

signal = query(obj1,':CURVE?');

fclose(obj1);
delete(obj1);
clear obj1

%
sig = strsplit(signal,',');
sig = ymult*str2double(sig);
N = length(sig);
xstop = xzero + xinc*(N-1);
time = xzero:xinc:xstop;
%
figure
plot(time, sig)
xlabel('Time [s]')
ylabel('Signal [V]')
saveas(gcf, append(filename, '.png'))
filename_ = append('C:\Users\haley\OneDrive\Documents\microsphere\', filename);
save(append(filename_, '.mat'),'time','sig')

