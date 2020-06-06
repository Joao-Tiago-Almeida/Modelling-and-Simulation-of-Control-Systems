function l_return = lgetNLS(bpm,l,s,c) % c is needed in SIMULINK
    % approx the values from a linear system to a nonlinear system
    % return BPM of a system, and plot a figure with time response and
    %   searchs the best ls, using a convergence method
    
    % bpm's goal
    bpm = reshape(bpm,[],1);   % change every kind of vector to 1D vector

    options.SrcWorkspace = 'current'; % set function's worspace for simulink
    
    nr = 10; % number max of points up to test. Most likely to converge before reach that much
    new_l = zeros(nr,length(bpm));
    bpm_vect = zeros(nr,length(bpm));
    
    for i = 1:length(bpm) % for each bpm's goal
        
        s = set_system9(l(i),s.m);    % set system with l for linear system
        y=sim('metron',options);    % simulation
        bpm_vect(1,i) = getBPM(y,s);     % bpm for linear system
        
        if bpm_vect(1,i) > bpm(i) % ponctual mass is to close from the spring
            new_l(:,i) = linspace(l(i),0.25,nr);
        elseif bpm_vect(1,i) < bpm(i) % ponctual mass is to far from the spring
            new_l(:,i) = linspace(0.05,l(i),nr);
            new_l(:,i) = flip(new_l(:,i)); % decreasing length 
        else % bpm for nonlinear system and linear system is equal 
            new_l(nr,i) = l(i); % previously computed
            bpm_vect(nr,i) = bpm(i); % previously computed
            continue;
        end
        
        for j = 2:nr    % simulate new values
            
            s = set_system9(new_l(j,i),s.m);    % set system with l for linear system
            y=sim('metron',options);    % simulation
            bpm_vect(j,i) = getBPM(y,s);     % bpm for linear system
          
            if bpm_vect(j,i) == bpm(i)  % found the exact length
                new_l(nr,i) = new_l(j,i); % returnable values
                bpm_vect(nr,i) = bpm_vect(j,i); % returnable values
                break
            end
            
            if j < nr % there is still values to compute
            % convergence of new_l based on last two lengths 
                if bpm(i) < bpm_vect(j,i) % bpm's goal is lower so the next length up to test has to be bigger 
                    if  bpm(i) < bpm_vect(j-1,i) % did not cross the goal, same way
                        new_l(j+1,i) =  new_l(j,i) + (new_l(j,i)-new_l(j-1,i)); % increase a little
                    else % crossed the goal, change increment sinal
                        new_l(j+1,i) = (new_l(j,i) + new_l(j-1,i))/2; % convergence
                    end
                else % bpm's goal is bigger so the next length up to test has to be lower
                    if  bpm(i) > bpm_vect(j-1,i) % did not cross the goal, same way
                        new_l(j+1,i) =  new_l(j,i) + (new_l(j,i)-new_l(j-1,i)); % decrease a little
                    else % crossed the goal, change increment sinal
                        new_l(j+1,i) = (new_l(j,i) + new_l(j-1,i))/2; % convergence
                    end
                end
            end    
        end
    end
    l_return =  new_l(nr,:);
end

