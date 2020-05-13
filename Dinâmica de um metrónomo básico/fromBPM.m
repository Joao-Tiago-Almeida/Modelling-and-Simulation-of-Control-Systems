function [l,m] = fromBPM(bpm,t)
    % return values for m and l, based on kwonw BPMs
    % this function works for every format of bpm array
    % if nargin > 1 plot an 3D figure
    
    % known variables
    L = 0.25;  % m - arm length
    M = 0.1; % Kg - arm mass
    k = 0.35;    % Nm/rad
    g = 9.8;    % m/s^2 - gravitational acceleration
    beta = 0.001;   % Nms/rad
    
    mMax = (k/g -M*L/2)/L; % mass maximum to a stable system, for all lengths
    
    l = 0.05:1e-3:0.25; l=l';   % limits for l
    m = 1e-3:1e-3:mMax; m=m';   % limits for L
    
    bpm = sort(reshape(bpm,1,1,[]));   % change every kind of vector, to 3D sorted array
    wd = bpm*pi/60; % known from the question 9
     
    [l,m] = meshgrid(l,m);
    l = repmat(l,1,1,size(wd,3));  % increase 3rd dimension size to the number of bpm 
    
    num = k - g * (l.*m + M*L/2);
    J = m.*l.^2 + 3\M*L^2;  % moment of inertia
    
    wn_c = real(sqrt(num./J));  % calculated natural frequency
    
    % Due to damping ratio is not 0, natural and damping frequencies differ
    zeta = beta./(2*J.*wn_c); % damping ratio
    wd_c = real(wn_c.*sqrt(1-zeta.^2)); % relation between frequencies
    
    
    if nargin > 1   % 3D plot for BPM in order of mass and length
        figure(); clf;
        surfc(l(:,:,1),m,wd_c(:,:,1)*60/pi)   
        shading interp;
        colormap(jet);
        colorbar;
        view(75,15);
        title(t,'FontName','Arial','FontSize',14,'interpreter','latex');
        ylabel('mass [Kg]','FontName','Arial','FontSize',13,'interpreter','latex');
        xlabel('length [m]','FontName','Arial','FontSize',13,'interpreter','latex');
        zlabel('BPM','FontName','Arial','FontSize',13,'interpreter','latex');
        
        figure(); clf;
        contourf(l(:,:,1),m,wd_c(:,:,1)*60/pi)   
        colormap(jet);
        colorbar;
        title('BPM','FontName','Arial','FontSize',14,'interpreter','latex');
        ylabel('mass [Kg]','FontName','Arial','FontSize',13,'interpreter','latex');
        xlabel('length [m]','FontName','Arial','FontSize',13,'interpreter','latex');
        
    end
    
    w_dif = abs(wd_c - wd); % double matrix of differences with l1,2 * m
    
    min_m = min(w_dif,[],2);   % get the minimum difference per mass index for each matrix
    min_m = sum(min_m,3); % sum the differences of each matrix. vector with both differences per mass index (row)
    [~,row] = min(min_m);  % get minimum mass index for both lengths
       
    [~,col] = min(w_dif(row,:,:)); % get the minimum length index for each matrix for specific mass index
    col = squeeze(col); % rearange colunms
    
    l = l(row,col); % m - distance to mass, differs for each BPM
    m = m(row,col(1)); % Kg - pontual mass. constant among BPM

    disp(['[GOAL] BPM: ' num2str(squeeze(bpm)')]);
    disp(['[GOAL] natural frequency: ' num2str(squeeze(wd)')]);
    disp(['[COMPUTED] damping frequency: ' num2str(wd_c(row,col))]);
    w_dif = squeeze(w_dif(row,col,:)); disp(['[COMPUTED] differences: ' num2str(diag(w_dif)')]);
    disp(['[COMPUTED] length - l: ' num2str(l)]);
    disp(['[COMPUTED] mass - m: ' num2str(m)]);
    
 end

   