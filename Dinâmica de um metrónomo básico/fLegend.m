function fLegend(label,pos)
    % prints labels formatted
    %
    % if it is called before quiver function, quiver legend will also be
    % displayed

    l = legend(label);
    l.Interpreter = 'latex';
    l.FontName = 'Arial';
    l.FontSize = 13;
    l.Location = 'best'; % default position

    if (nargin == 2) && strcmp(pos,'outside')
        l.Location = 'bestoutside'; 
    end

end