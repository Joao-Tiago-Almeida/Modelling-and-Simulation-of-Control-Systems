function sys = sistema(b,t_ger,u_ger)


if nargin == 0
    teste
    return
end



% sistema

% controlador
Gs = tf(1 ,[1 b 0]);

%equações de estado
%dx=Ax+Bu
%y=Cx+Du

A = [0 1; 0 -b];
B = [0; 1];
C = [0 1];
D = 0;

sys = ss(A,B,C,D);

Gz = tf(sys);

figure(4);hold on;grid on;

t_cont = linspace(min(t_ger),max(t_ger),length(t_ger));

l = lsim(Gz,u_ger,t_cont,[1;0]);
plot(t_ger,l);
%plot(t_cont,l);

end

