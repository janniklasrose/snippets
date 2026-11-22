% Script to illustrate how to extract images and metadata from NDPI files.
%   NDPI files are just TIFF with extra tags, so we can access them
%   directly from within MATLAB. Some of this could be done with ndpitools:
%   https://www.imnc.in2p3.fr/pagesperso/deroulers/software/ndpitools/
%   which is definitely a useful tool, but sometimes you just want to read
%   the image from a known series of .NDPI files, e.g. when processing in
%   bulk, without extracting each first (can double the disk usage).

%   Copyright (c) 2019 Jan N Rose

folder = 'R:\Histology\'; % can be a network drive
filename = 'Slide001.ndpi'; % sample
file = fullfile(folder, filename);

% turn off specific warning, because MATLAB expects proper TIFF Tags
warning('off', 'imageio:tifftagsread:expectedTagDataFormat');

info_all = imfinfo(file); % struct of `imfinfo`s, one per resolution
res_idx = 4; % index for desired resolution (descending in size)

%% META DATA
info = info_all(res_idx);
imsize = [info.Height, info.Width];
make = info.Make; % Manufacturer (e.g. 'Hamamatsu')
model = info.Model; % Scanner (e.g. 'C13239-01')
datetime = info.DateTime;

% NDPI specific tags are kept as 'UnknownTags'. Unfortunately, Hamamatsu
% has not documented these but there are some attempts to identify them:
% * https://openslide.org/formats/hamamatsu/ under 'NDPI File'
% * https://www.imnc.in2p3.fr/pagesperso/deroulers/software/ndpitools/
%   -> Download source, then see tiff-VERSION/libtiff/tiff.h
ndpiTags = info.UnknownTags;
NDPITAG_USERGIVENSLIDELABEL = 65427;
slidelabel = ndpiTags([ndpiTags.ID]==NDPITAG_USERGIVENSLIDELABEL).Value;

% rename
datetime = strrep(datetime, ':', ''); % invalid (on Windows) ':' character
datetime = strrep(datetime, ' ', ''); % script-unfriendly space character
filenew = [slidelabel,'_',datetime,'.ndpi'];
%movefile(file, filenew);
%file = filenew;

%% IMAGE
im = imread(file, res_idx);
imshow(im);

%% LOOP
% use the above sections to select the desired resolution etc

files = dir([folder, '*.ndpi']); % all
for i = 1:numel(files)
    file_i = fullfile(files(i).folder, files(i).name);
    im_i = imread(file_i, res_idx);
    imshow(im_i);
    pause(0.5);
end
