function multiBodes(l,m,t)
    % plot multiple diagrams
    % specifies plot's title if nargin > 2
    
    l = sort(reshape(l,[],1));   % change every kind of vector, to 1D sorted array
    
    f = figure(); clf; hold on; 
    for i = 1:length(l)
        % get only the system with y1 = x1
        s = set_system9(l(i),m);
        transFunc = tf(s.sys);
        bodes = tf([transFunc.Numerator{1}],[transFunc.Denominator{1}]);
        bode(bodes);
    end
    grid on;
    % format graphs
    fLegend({['$l_1$ = ' num2str(l(1), '%.4f'), ' m'], ['$l_2$ = ' num2str(l(2),'%.4f') ' m']},'northeast');
    if nargin > 2
        title(t,'FontSize', 14);
        f.CurrentAxes.XAxis.Label.FontSize = 13;
        f.CurrentAxes.YAxis.Label.FontSize = 13;
        f.CurrentAxes.FontName = 'Arial';
    end
end

