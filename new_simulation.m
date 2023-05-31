%new simulation
close all;
clear all;

alpha = -10:.1:10;
x = sqrt(2)*alpha;
n = 10;

p_a = sqrt(2/pi).*exp(-2.*alpha.^2)./(2^n.*factorial(n)).*(hermiteH(n,x)).^2;
figure;

plot(alpha, p_a)
xlabel("\alpha", 'fontname', 'times')
ylabel('pdf', 'fontname', 'times')
saveas(gcf, "photonnumberpdf.png")
figure;
plot(alpha.^2, p_a)

th = -pi/2:pi/4:pi/2;
alpha_theta = real((0:.01:3)*exp(-1i*pi/2));
beta = 2;
xlabel('|\alpha|^2', 'fontname', 'times')
ylabel('pdf', 'fontname', 'times')
saveas(gcf, "photonnumbersquared.png")



[X,Y] = meshgrid(th,alpha_theta);
beta_theta = real(beta*exp(-1i*X));
p_a_coherent = exp(-2*(Y-beta_theta).^2)./sqrt(pi/2);
surf(X,Y,p_a_coherent)
xlabel("\Theta", 'fontname', 'times')
ylabel("\alpha_\Theta", 'fontname', 'times')

saveas(gcf, "2_pi_2_phase.png")