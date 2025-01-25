% Copyright (C) 2024 Computer Vision Lab, Electrical Engineering, 
% Indian Institute of Science, Bengaluru, India.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above
%       copyright notice, this list of conditions and the following
%       disclaimer in the documentation and/or other materials provided
%       with the distribution.
%     * Neither the name of Indian Institute of Science nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
% DEALINGS IN THE SOFTWARE.
% 
% Author: Lalit Manam
%
% This file is a part of the implementation for the paper:
% Leveraging Camera Triplets for Efficient and Accurate Structure-from-Motion
% IEEE/CVF Conference on Computer Vision and Pattern Recognition, 2024.

clear; close all;

%% Hyperparameter
m=0.7; % Minimum mcore edges should satisfy

% %%
% file_path = "/Users/safuan/Python/IACV_project/datasets/Alcatraz/alcatraz_matches.txt";
% 
% % Read the data as a table, skipping the header
% opts = detectImportOptions(file_path, 'FileType', 'text');
% opts.VariableNamesLine = 1; % Specify the header line
% data_table = readtable(file_path, opts);
% 
% % Extract pair_id and other numeric columns as needed
% pair_ids = data_table.pair_id;
% rows = data_table.rows;
% cols = data_table.cols;
% config = data_table.config;
% 
% % Example usage
% numMatches = rows; % Adjust based on your specific usage
% numEdges = size(pair_ids, 1);
% 
% % Convert pair_ids to edges
% edges = nan(numEdges, 2);
% edges(:, 2) = mod(pair_ids, 2147483647);
% edges(:, 1) = (pair_ids - edges(:, 2)) / 2147483647;
%% Load Input
% Each row in input file (.txt) consists of "pair_id num_of_matches" from COLMAP DB
pair_data=load("/Users/safuan/Python/IACV_project/datasets/WaterTower/water_tower_matches.txt");
pair_ids=pair_data(:,1);
numMatches=pair_data(:,2);
clear pair_data

numEdges=size(pair_ids,1);

edges=nan(numEdges,2);

edges(:,2)=mod(pair_ids,2147483647);
edges(:,1)=(pair_ids-edges(:,2))/2147483647;

%% Check the largest connected component in the graph
G = graph(edges(:,1),edges(:,2));
bins = conncomp(G,'OutputForm','vector');
nodes=find(bins==mode(bins));
eidx=ismember(edges(:,1),nodes)&ismember(edges(:,2),nodes);

%% Extract the triplet graph
% Get the triplets
G=graph(edges(:,1),edges(:,2),1:size(edges, 1));
[~,edgecycles]=allcycles(G,'MaxCycleLength', 3);

% Check and remove the edges not participating in the triplets
ret_edges=false(size(edges,1),1);
edgecycles=cell2mat(edgecycles);
ret_edges(unique(edgecycles(:)))=true;
tripletOnlyEdges=edges(ret_edges,:);

%% Get the triplet graph
% Check for parpool
p=gcp('nocreate');
if(isempty(p))
    p=gcp;
end

G_to=graph(tripletOnlyEdges(:,1),tripletOnlyEdges(:,2));
[cycles,edgecycles]=allcycles(G_to,'MaxCycleLength',3);

cycles=cell2mat(cycles);
edgecycles=cell2mat(edgecycles);
numEdges=size(tripletOnlyEdges,1);
tripletGraphEdges=cell(numEdges,1);

parfor i=1:numEdges
    connNodes=find(i==edgecycles(:,1)|i==edgecycles(:,2)|i==edgecycles(:,3));
    if(numel(connNodes)>1)
        tripletGraphEdges{i}=[connNodes(1:end-1),connNodes(2:end)];        
    end
end
tripletGraphEdges=cell2mat(tripletGraphEdges);
tripletGraphEdges=unique(tripletGraphEdges,'rows');

%% Extract largest connected component of the Triplet graph
G_T=graph(tripletGraphEdges(:,1),tripletGraphEdges(:,2));
bins=conncomp(G_T,'OutputForm','vector');
nodes=find(bins==mode(bins)); 
edgecycles_PR=edgecycles(nodes,:);
edges_idx_PR=unique(edgecycles_PR(:));

tripletEdges=tripletOnlyEdges(edges_idx_PR,:); 

%% Get the subgraph of the original graph which contains these nodes
eidx=ismember(edges,tripletEdges,'rows');
edges=edges(eidx,:);
pair_ids_in_triplets=pair_ids(eidx);
numMatches=numMatches(eidx,:);

%% Get the threshold for pruning edges (for dt2)
G=graph(edges(:,1),edges(:,2),1:size(edges,1));
[~,edgecycles]=allcycles(G,'MaxCycleLength',3);
edgecycles=cell2mat(edgecycles);
D=degree(G);

%% Thresholding 
numImages=numel(unique(edges(:)));
max_degree=max(D);
al=max_degree/numImages;
edge_weight_th=m*(1-al)+al;

numMatches_in_triplets=[numMatches(edgecycles(:,1)),numMatches(edgecycles(:,2)),numMatches(edgecycles(:,3))];
triplet_match_ratio=numMatches_in_triplets./max(numMatches_in_triplets,[],2);

%% Edge Weighting Method
% Get the number of triplets every edge participates
tab_edges=tabulate(edgecycles(:));
edge_freq=tab_edges(:,2); 
numEdges=size(edges,1);
edge_weights=zeros(numEdges,1);

% Check for parpool
p=gcp('nocreate');
if(isempty(p))
    p=gcp;
end

%% Final Edge Weights
parfor i=1:numEdges
    commCycles=(i==edgecycles);
    edge_weights(i)=sum(triplet_match_ratio(commCycles));    
end

edge_weights=edge_weights./edge_freq;
eidx=edge_weights<edge_weight_th;
edges(eidx,:)=[];
pair_ids_in_triplets(eidx)=[];

%% Get the largest connected component
G=graph(edges(:,1),edges(:,2));
bins=conncomp(G,'OutputForm','vector');
nodes=find(bins==mode(bins)); 
eidx=ismember(edges(:,1),nodes)&ismember(edges(:,2),nodes);
eidx=~eidx;

%% Remove edges
edges(eidx,:)=[];
pair_ids_in_triplets(eidx,:)=[];

%% Save Output
% Output file (.txt) consists of "pair_id" which should be retained in COLMAP DB
writematrix(pair_ids_in_triplets, "/Users/safuan/Python/IACV_project/datasets/WaterTower/filtered_water_tower_matches.txt");
