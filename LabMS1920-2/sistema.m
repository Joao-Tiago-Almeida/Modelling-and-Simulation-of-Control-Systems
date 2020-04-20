function sistema(b,t,u)
% sistema

% controlador
Gs = tf(1 ,[1 b 0]);

%equações de estado
%dx=Ax+Bu
%y=Cx+Du

A = [0 1; 0 -b];
B = [0; 1];
C = [1 0];
D = 0;

sys = ss(A,B,C,D,max(t));

Gz = tf(sys);

figure(3);hold on;grid on;

l = lsim(Gz,u);
plot(t,l);

end

