function convertAnnotationsDeeplab()
% convertAnnotationsDeeplab()
%
% Convert the COCO-Stuff annotation files into a suitable format for
% DeepLab. Offsets the label indices by -1 and converts them to uint8.
%
% Copyrights by Holger Caesar, 2016

% Settings
cocoStuffFolder = cocoStuff_root();
annotationFolder = fullfile(cocoStuffFolder, 'dataset', 'annotations');
saveFolder = fullfile(cocoStuffFolder, 'models', 'deeplab', 'cocostuff', 'data', 'annotations');

% Get all images
imgs_dir = dir(fullfile(annotationFolder, '*.mat'));

% Create saveFolder if necessary
if ~exist(saveFolder, 'dir')
    mkdir(saveFolder)
end

for i = 1 : numel(imgs_dir)
    fprintf(1, 'Processing image %d of %d ...\n', i, numel(imgs_dir));
    
    labelStruct = load(fullfile(annotationFolder, imgs_dir(i).name));
    labelMap = labelStruct.S;
    assert(max(labelMap(:)) <= 182);
    labelMap = labelMap - 1;
    labelMap(labelMap == -1) = 255;
    labelMap = uint8(labelMap);
    
    imwrite(labelMap, fullfile(saveFolder, strrep(imgs_dir(i).name, '.mat', '.png')));
end
