function y = RSS_mmc(v,tt,n,lambda)
    % according with rssiloc.m
    
    y = zeros(size(v)/10); % present first 10% of the matrix
    
    load('MarkovChain.mat','nodePos','sourcePos');
    sourcePos = repmat(sourcePos, size(y,2), 1); % extend sourcePos
    
    if nargin == 3
        v = v.*(v(:,1)==n); % search for states which starts with prerequisite n
        v = sortrows(v,1,'descend');    % rearrange vector
        
        count = find(v(:,1)==0,1)-1;
        if count < size(v,1)/10 % doesnt have enough data
          y = zeros(count, size(v,2)/10); % present first 10% of each run with all data available from start posotion n
        end
        
    elseif nargin == 4 % represents moving source
        sourcePos = sourcePos + cumsum(2*(rand(size(y,2),2)-0.5));
    end
    
    % default lambda
    if nargin ~= 4
        lambda = 1;
    end
    
         
    wait = waitbar(length(y),'Good things come to those who wait...','Name','RSS');
    for i = 1:size(y,1)
        for j = 1:size(y,2) % increment vector, but without forgetting 
            
            ni = normrnd(0,1e-2,[1,j]);

            [~, A, b] = RSS_m1(nodePos, sourcePos(j,:), v(i,1:j), ni);

            
            %z = pinv(A)*b;  % avoid warning (produced with A\b): Matrix is close to singular or badly scaled. Results may be inaccurate. RCOND
            
            RlsPar = struct('lam',lambda);
            [~,z,~] = qrrls(A,b,RlsPar);
            
            xe = z(1:2);
            y(i,j) = norm(sourcePos(j,:)-xe');
        
        end
        waitbar(i/size(y,1),wait);
    end
    close(wait);   % close waitbar
    
    f = figure(); hold on; grid on;
    boxplot(y,'symbol',''); % turn outilener invisible 
    h = findobj(gcf,'tag','Upper Whisker'); % get Upper Whisker info
    lim_up = max([h(end).YData(end),h(end-1).YData(end),h(end-2).YData(end)]); % major errors occurs when the method is stabilizing
    ylim([-10 10+lim_up]) % zoom interval
    f.Position(3) = f.Position(3)*2;
    title(['Erro de Estimativa da Posição da fonte para a Cadeia de Markov ' tt]);
    xlabel('Instante da Run');
    ylabel('Erro')
    
    
end