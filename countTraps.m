% %% This script collects trap statistics from the CCD280 pocket pumping
% data taken for the beta parameter measurment. Each data frame is loaded
% from the selected device and the number of traps in each frame is
% counted, along with the dipole orientation, dipole intensity and trap
% location.

% Select the device
chip='FS'; 
direc=['../' chip '/_parPumpDel10DN_10000pumps_4000rowCI_-125degC_1/imgs_rep1_pumpMode1_parPumpDel200DN_delayunitmicrosec10ParTrapPump_measurement_Vgd'];

% Set the electronic gain measurements made by Steve Parsons. Variable 'g'
% indicates which row (device) to select from.
gain=[1.399 1.522; 1.431 1.508; 1.475 1.495];
if strcmp(chip,'FM1') g=1;
elseif strcmp(chip,'FM2') g=2;
else g=3;
end

% Set boundaries of the image sections of the frame.
window1=[511 4510; 26 2280];
window2=[511 4510; 2341 4595];

% Initialize variables.
allTraps=[];
trpsPerCol=[];
trpcnt=[];
N=zeros(1,100);

% Main loop. 
for i=1:21
    i
    % Load file and bias subtract + convert to electrons.
    filename=[direc num2str(i+149) '.mat'];
    load(filename);
    dataImg=double(squeeze(mean(imgs,1)));
    dataImg=biasSubtract(dataImg,gain(g,:));

    % Find traps in the left section and then right section of the frame.
    [trps1 N1 trpsPerCol1]=findTrps(dataImg,window1,4);
    [trps2 N2 trpsPerCol2]=findTrps(dataImg,window2,4);

    % Put trap statistics together for the current frame and roll the
    % numbers in the running counts.
    allTraps=[allTraps; trps1; trps2];

    % Roll the numbers into the running counts.
    trpsPerCol=[trpsPerCol; trpsPerCol1; trpsPerCol2];
    N=N+N1+N2;
end

%%
% Miscellaneous ways to massage the resulting data to visualize trap
% statistics.

% A=allTraps(:,1); B=allTraps(:,2); C=(1:numel(B))';
% G=findgroups(A);
% sel=splitapply(@(b,c) c(find(b==min(b),1)),B,C,G);
% Selection=allTraps(sel,:);
% [n edges]=histcounts(Selection(:,2),10.^(linspace(1,4.65,101)));
[trpcnt edges]=histcounts(allTraps(:,2),10.^(linspace(1,4.65,101)));
% figure; histogram('BinCounts',trpcnt./N,'BinEdges',edges,'DisplayStyle','stairs'); 
% set(gca,'XScale','log','YScale','log','FontSize',14);
% grid on