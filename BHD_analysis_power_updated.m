close all; clear all;
q = 1.6e-19;
g = 2.1e5;
G = 1;    %%%FACTOR OF 2 FROM IMPEDANCE MIS-MATCH. REMAINDER OF GAIN IS FIT & FROM DATA SHEET
h = 6.626e-34;
c = 3e8;
lamb = 1550e-9;
E_p = h*c/lamb;


flistfull = ls("LO_Data\*.mat");
[s, ~] = size(flistfull);
mus = zeros(1, s);
sigmas = zeros(1, s);
powers = zeros(1, s);

for i = 1:1:s
    f = string(flistfull(i, :));
    power = erase(erase(string(flistfull(i, 1:4)), "m"), "i");
    
    load(append("C:\Users\haley\OneDrive\Documents\RIOSweep\", f))
    dt = time(2) - time(1);
    
    n = 200; % number of values per chunk
    a = sig;
    T_sym = dt*n; 
    
    N_LO =  str2double(power)*10^(-6)/E_p;
    C = 1/(2*g*G*q*sqrt(N_LO*T_sym));
    
    sig = arrayfun(@(i) C*sum(a(i:i+n-1)*dt),1:n:length(a)-n+1)'; % the averaged vector
    powers(i) = str2double(power);
    sigmas(i) = var(sig);
end

[ux,~,idx] = unique(powers);
% Accumulate 
ymean = accumarray(idx,abs(sigmas).^2,[],@mean);
% Plot
plot(ux,ymean, '-*')
xlabel("Power (\muW)")
ylabel("\sigma^2")
hold on 
plot(ux, .25+zeros(1, length(ux)), '--', 'LineWidth',1.5)
legend("Scaled Voltage (Normalized to Shot Noise)", ".25 line")
saveas(gcf, 'shotnoiselimit.png')

