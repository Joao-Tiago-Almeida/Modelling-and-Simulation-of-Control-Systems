close all; clear;

x = linspace(0.05,0.25,1001); 

y = get_m_limit(x);

figure(); clf;
plot(x,y);
xlabel("Posição na barra");
ylabel("Mínimo de m");
sgtitle("BONUS");

min(y)