%função que permite descobrir os mínimos globais de para cada par de valores (xx,yy)
function [val,z_search] = minimos(xx,yy)
    total=length(xx)*length(yy);d=1;
    z_search=zeros(length(xx)*length(yy),2);                                    % array with calculated variables
    val = zeros(1,length(xx)*length(yy));                                       % error for each pair  
    for i = 1:length(xx)
        for j = 1:length(yy)
            z_search((i-1)*length(yy)+j,:) = fminsearch(@erro,[xx(i), yy(j)]);  % get variables
            val(1,(i-1)*length(yy)+j) = erro(z_search((i-1)*length(yy)+j,:));   % set the error
            w = waitbar(d/total);d=d+1;
        end
    end
    w.delete;%close waitbar window
    
end

