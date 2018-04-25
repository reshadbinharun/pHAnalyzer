%% pH Analyzer
% -> Extracts RGB signals from regions of interest in pH-sensitive on-body patches
% -> Calculates average change in RGB values over reference pools for each
%   dye on patch
% -> Outputs .csv for graphing on EXCEL
%Last updated: April 6th, 2018
%Md Reshad Bin Harun

clear
%filters for all files that are .JPG in path specified
path = '/Users/reshadbinharun/Documents/School/Spring18/BME8';
filter = '*.JPG';

%prompts user for determining sampling circle size
ellsize = inputdlg('What pixel diameter sampling circle do you want to use? (50 recommended)');
ellsize = str2double(ellsize{:});

answer = questdlg('Import image?',...
	'Yes', 'No');
switch answer
    case 'Yes'
        more = 1;
    case 'No'
        more = 0;
end

%initializes empty struct to store RGB intensity changes and empty cell to
%store matrix representing relevant image maks
results = struct([]);
masks = {};

%loop continues until user chooses to not import a new image
while (more)
    %allows user to select file
    [file, path] = uigetfile(fullfile(path , filter));
    I = imread([path '/' file]);
    table.filename = file;
    
    %allows user to crop to image area of interest
    I_crop = imcrop(I);
    pause(0.5)
    close gcf
    
    figure
    imshow(I_crop);
    title('cropped image')
    grid on
    
    %prompts user for pH that was used on patch
    pH = inputdlg('What pH concentration was tested?');
    table.pH = pH{1};

    %storing titles to guide user to current pool of interest
    promptvect = ["Drag circle to dye 1 reference","Drag circle to dye 1 sample",
        "Drag circle to dye 2 reference", "Drag circle to dye 2 sample", 
        "Drag circle to dye 3 reference", "Drag circle to dye 3 sample"];

    %Extracting R,G,B from image
    R = double(I_crop(:,:,1));
    G = double(I_crop(:,:,2));
    B = double(I_crop(:,:,3));

    %loop to visit every dye and reference on patch to create mask for
    %region of interest
    for i = 1:6
        title(promptvect(i));
        hellip = imellipse(gca,[10 10 ellsize ellsize]);
        setResizable(hellip,false);
        wait(hellip)
        mask = hellip.createMask();
        masks{i} = mask;
    end
    close gcf 
    
    %converting masks from logicals to doubles
    for i=1:6
        masks{i} = double(masks{i});
    end

    %%EXTRACTING DATA RGB CHANNELS USING MASKS CREATED
    
    %%Dye1
    %dye1 RGB values
    dye1r = masks{4}.*R;
    dye1g = masks{4}.*G;
    dye1b = masks{4}.*B;

    %averages of base dye1
    avg1r = sum(sum(dye1r))./sum(sum(masks{1}));
    avg1g = sum(sum(dye1g))./sum(sum(masks{1}));
    avg1b = sum(sum(dye1b))./sum(sum(masks{1}));


    %dye1 ref RGB values
    dye1r_ref = masks{1}.*R;
    dye1g_ref = masks{1}.*G;
    dye1b_ref = masks{1}.*B;

    %average dye1 ref RGB values
    avg1ref_r = sum(sum(dye1r_ref))./sum(sum(masks{2}));
    avg1ref_g = sum(sum(dye1g_ref))./sum(sum(masks{2}));
    avg1ref_b = sum(sum(dye1b_ref))./sum(sum(masks{2}));
    
    %change in dye1 RGB intensities
    dye1delr = avg1r - avg1ref_r;
    dye1delg = avg1g - avg1ref_g;
    dye1delb = avg1b - avg1ref_b;
    %euclidean distance to quantify overall change
    ed_dye1 = sqrt((dye1delr)^2+(dye1delg)^2+(dye1delb)^2);
    
    %storing dye1 changes in empty table struct
    table.dye1red_change = dye1delr;
    table.dye1green_change = dye1delg;
    table.dye1blue_change = dye1delb;
    table.dye1ed = ed_dye1;

    %%Dye2
    %dye2 RGB values
    dye2r = masks{5}.*R;
    dye2g = masks{5}.*G;
    dye2b = masks{5}.*B;

    %averages of base dye2
    avg2r = sum(sum(dye2r))./sum(sum(masks{4}));
    avg2g = sum(sum(dye2g))./sum(sum(masks{4}));
    avg2b = sum(sum(dye2b))./sum(sum(masks{4}));

    %dye2 ref RGB values
    dye2r_ref = masks{2}.*R;
    dye2g_ref = masks{2}.*G;
    dye2b_ref = masks{2}.*B;
    
    %averages of ref dye2
    avg2ref_r = sum(sum(dye2r_ref))./sum(sum(masks{3}));
    avg2ref_g = sum(sum(dye2g_ref))./sum(sum(masks{3}));
    avg2ref_b = sum(sum(dye2b_ref))./sum(sum(masks{3}));

    %change dye2
    dye2delr = avg2r - avg2ref_r;
    dye2delg = avg2g - avg2ref_g;
    dye2delb = avg2b - avg2ref_b;
    ed_dye2 = sqrt((dye2delr)^2+(dye2delg)^2+(dye2delb)^2);
    
    %storing dye2 changes in table struct
    table.dye2red_change = dye2delr;
    table.dye2green_change = dye2delg;
    table.dye2blue_change = dye2delb;
    table.dye2ed = ed_dye2;
    
    %%Dye3
    %dye2 RGB values
    dye3r = masks{6}.*R;
    dye3g = masks{6}.*G;
    dye3b = masks{6}.*B;

    %averages of base dye1
    avg3r = sum(sum(dye3r))./sum(sum(masks{6}));
    avg3g = sum(sum(dye3g))./sum(sum(masks{6}));
    avg3b = sum(sum(dye3b))./sum(sum(masks{6}));

    %dye2 ref RGB values
    dye3r_ref = masks{3}.*R;
    dye3g_ref = masks{3}.*G;
    dye3b_ref = masks{3}.*B;

    %average of dye3 references
    avg3ref_r = sum(sum(dye3r_ref))./sum(sum(masks{5}));
    avg3ref_g = sum(sum(dye3g_ref))./sum(sum(masks{5}));
    avg3ref_b = sum(sum(dye3b_ref))./sum(sum(masks{5}));
    
     %change in dye3
    dye3delr = avg3r - avg3ref_r;
    dye3delg = avg3g - avg3ref_g;
    dye3delb = avg3b - avg3ref_b;
    ed_dye3 = sqrt((dye3delr)^2+(dye3delg)^2+(dye3delb)^2);
    
    %storing dye2 changes in empty table struct
    table.dye3red_change = dye3delr;
    table.dye3green_change = dye3delg;
    table.dye3blue_change = dye3delb;
    table.dye3ed = ed_dye3;
    
    %adds a new row to table for each image
    results = [results table];
    %asks user if another image is to be inputed
    answer = questdlg('Import another image?',...
	'Yes', 'No');
    switch answer
        case 'Yes'
            more = 1;
        case 'No'
            more = 0;
    end
end

%imports data into a .csv file for analysis in EXCEL
output = struct2table(results);
writetable(output, 'results.csv');


