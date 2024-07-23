% This code is able to calcualte the velocity curves of several bioassay
% experiements, as loong as the videos of each esperiment are located in
% the corresponding subfolde.

%% Cleans up - if previous analysis performed.
clc;clear;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
%%
% Define a starting folder.
start_path = fullfile(matlabroot, 'C:\Users\Ward Lab\Desktop\Jingxiang\matlab-tracking\track in petri dish');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
    return;
end
% Get list of all subfolders. videos of each bioassay experiement were
% placed in the conrespongding subfolder.
allSubFolders = genpath(topLevelFolder);% this will include foldername and all the subfolder names.
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
    [singleSubFolder, remain] = strtok(remain, ';');%break string by white space
    if isempty(singleSubFolder)
        break;
    end
    listOfFolderNames = [listOfFolderNames singleSubFolder];
end
%% Setting Initial Conditions.
numberOfFolders = length(listOfFolderNames);
actv=cell(1,numberOfFolders-1);
actv_velocity=cell(1,numberOfFolders-1);
speed_up=10;%speed up times
HeightScaleBar=[9.2];% unit is cm. This is the scale reference for videos in each subfolder.
%%
% Process all image files in those folders.
for im =1:numberOfFolders-1 %im is the subfolder number
    % open subfolder
    thisFolder = listOfFolderNames{im+1};
    % Get all mp4 files in this subfolder
    filePattern = sprintf('%s/*.mp4', thisFolder);
    baseFileNames = dir(filePattern);
    %% process the background video in this subfolder
    userpath(thisFolder)
    videoBG=VideoReader(baseFileNames(1).name);%check the string type/
    frame_numberBG=floor(videoBG.Duration * videoBG.FrameRate);
    BG=zeros(720,1280,3);
    for i=1:frame_numberBG-2
        I0=read(videoBG,i);
        i0=im2double(I0)/frame_numberBG;% the background of the experimental setup was calcualted by averaging all the frames from a representative clip.
        BG=BG+i0;
    end
    BG=imrotate(BG,180);
    imshow(BG)% Figure S2b
    %% find marks in this subfolder (areas for different trials),and calculate the scale bar
    I2=imread(strcat(baseFileNames(1).name,'.jpg')); % Figure S2c
    I3=(I2(:,:,3)-250)*255;
    Rse=strel('disk',7);
    I3=imopen(I3,Rse);
    %%
    [labeled,rec]=bwlabel(I3,8);
    m=rec
    stats=regionprops(labeled,'BoundingBox');
    BoundingBoxs = [stats.BoundingBox];
    scale=HeightScaleBar/BoundingBoxs(4);
    %% calculate the total framenumber
    frame_number=zeros(length(baseFileNames),1);
    for ive=2:length(baseFileNames)
        video=VideoReader(baseFileNames(ive).name);
        frame_number(ive)=frame_number(ive-1)+floor(video.Duration * video.FrameRate);
    end
    frame_withdraw_number=floor(frame_number(ive)/speed_up);
    trial=cell(1,rec-1);
    r0=cell(1,rec-1);
    actv{1,im}=zeros(frame_withdraw_number,(rec-1)+1);
    total_area_per_trial=zeros(rec-1,1);
    %%    load the video need to be analyzed.
    ive=2;
    video=VideoReader(baseFileNames(ive).name);
    for iv=1:frame_withdraw_number
        if 1+(iv-1)*speed_up>frame_number(ive)
            ive=ive+1;
            video=VideoReader(baseFileNames(ive).name);
        end
        I0=read(video,2+(iv-1)*speed_up-frame_number(ive-1));
        I0=imrotate(I0,180);% One frame withdrawn from the video.
        Id=im2double(I0);
        z=imsubtract(BG,Id);% substact background from this frame.
        mark=[im iv]% this code is used to show the progress.
        z1=(uint8(z(:,:,3)*255)-45)*255;% Binarization of the image.
        for idx=2:rec
            trial{idx}=imcrop(z1,BoundingBoxs((idx-1)*4+1:idx*4));%find the position of each Petri dish with insects.
            r=im2double(trial{idx})*255;
            
            if iv ==floor(frame_withdraw_number*0.9)
                total_area_per_trial(idx-1)=sum(sum(im2double(trial{idx})));
            end
            if iv==1
                r0{1,idx}=zeros(size(trial{1,idx}));
                actv{1,im}(iv,1)=iv;
                actv{1,im}(iv,idx)=0;
            end
            if iv>1
                x=abs(imsubtract(r,r0{1,idx}));
                Rse=strel('disk',3);
                X=imopen(x,Rse);
                actv{1,im}(iv,1)=iv;
                actv{1,im}(iv,idx)=sum(sum(X))/255;
                r0{1,idx}=r;
            end
        end
    end
    %% average the three trials and get the velocity.
    actv_velocity{1,im}(:,1)=actv{1,im}(:,1);
    %%
    for idx=2:rec
        actv_velocity{1,im}(:,idx)=scale*actv{1,im}(:,idx)/total_area_per_trial(idx-1);
    end
    %%
    actv_m=actv{1,im};
    actv_velocity_m=actv_velocity{1,im};
    %% save data
    subfolder_name=listOfFolderNames{im+1};
    subfolder_name=subfolder_name(end-7:end);
    save (strcat(subfolder_name,'_velocity'),'actv_velocity_m')%SAVE DATA
end