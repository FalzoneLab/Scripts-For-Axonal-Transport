
% Single Particle Tracking Script
% Datatips must be generated over the trajectory from the bottom to the top of the kymograph

clear all; clc; close all; % commands that clear uneeded variables, clear command window and close all graphics

CalibP=1;           % pixel size (can be adjusted, but we recommend leaving it in 1 and adjusting size in spreadshit when analysing data)
CalibT=1;           % frame duration (same as above)
dx=2;               % pixels considered horizontally to search for the particle  (can be increased if the kymographs are clean)

fname =input('Filename: ','s');         % loads image (kymograph)
kymo=imread(fname);                     % saves kymograph image in variable kymo
kymo=double(kymo);                      

g=figure(1);                            % loads into figure
imagesc(kymo); colormap('gray');        % displays image in gray
h = uicontrol('Position',[5 10 150 30],'String','Continue','Callback','uiresume(gcbf)');    % places a button to continue to analysis once datatips information is exported
h = uicontrol('Position',[205 10 150 30],'String','Export','Callback','cursor_info=getCursorInfo(dcm_g);');       % places a button to export cursor info
datacursormode(g);                      
dcm_g = datacursormode(g);
set(dcm_g,'UpdateFcn',@accesory1);      % clears strings from datatips
uiwait(gcf);                            % waits untill continue button is pressed

for j=1:length(cursor_info)
    xin(j)=cursor_info(j).Position(2);
    yin(j)=cursor_info(j).Position(1);
end

xi=[xin(1):1:xin(end)];                 
yi = interp1(xin,yin,xi,'linear');         
            
for i=1:length(xi)
    x=kymo(xi(i),yi(i)-dx:yi(i)+dx);
    x=x';
    p1=1:length(x);

    ts=x;p=p1;

    grado=1;
    net=newgrnn(p,ts',grado);

    pp=[1:0.005:length(p1)];
    y=sim(net,pp);

    x_m=pp(find(y==max(y)));
    x_max(i)=x_m+yi(i)-dx-1;
    fluorescence(i)=max(y);
 end

figure(1); subplot(2,1,1); imagesc(kymo); hold on;  plot(x_max,xi,'*k'); plot(yin,xin,'om');
figure(1); subplot(2,1,2); plot(x_max,xi);

time=xi;
distance=x_max;

fname=input('save as:    ','s');                % ask for filename for particle
save(fname,'distance','time');                      % saves tracked particle

again=input('Track another particle(y/n): ','s');         % loads image (kymograph)

if again=='y'                                       % ask for repetition
    tracking_script;                                % reruns script
else
end
