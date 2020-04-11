function e = erro(val)

global N2o;     N2o = timeseries(val(1));
global alfa2;   alfa2 = val(2);
global yr;

s =  sim('modelo','StartTime','0','StopTime',num2str(20), ...
    'FixedStep',num2str(0.1)); %force to get {1x201} array

e = max(abs(s.N1 - yr)); % l∞

end

