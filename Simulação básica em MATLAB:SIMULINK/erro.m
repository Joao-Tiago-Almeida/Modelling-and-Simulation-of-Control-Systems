function e = erro(val)

N2o = timeseries(val(1));
alfa2 = val(2);
global yr;
samp_time = 0.1; %force to get {1x201} array

delta2 = -1.5;
delta1 = 3.1;
alfa1 = 1.4;
N1o = timeseries(4);


options.SrcWorkspace = 'current';
stop_time = 20;

s = sim('modelo', options);

e = max(abs(s.N1 - yr)); % l∞

end

