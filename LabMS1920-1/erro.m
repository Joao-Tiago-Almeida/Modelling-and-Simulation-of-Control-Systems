function e = erro(val, yr)

global N2o;
N2o = timeseries(val(1));
global alfa2;
alfa2 = val(2);

%myoptions = simset('SrcWorkspace','current');
%s = sim('modelo',[0 0.1 20], myoptions);

s =  sim('modelo','StartTime','0','StopTime',num2str(20), ...
    'FixedStep',num2str(0.1));

e = max(abs(s.N1 - yr));

end

