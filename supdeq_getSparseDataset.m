%% SUpDEq - Spatial Upsampling by Directional Equalization
%
% function [sparseHRTFdataset, sparseHRIRdataset] = supdeq_getSparseDataset(sparseGrid,NmaxSparse,referenceOrder)
%
% This function returns a sparse HRTF or HRIR dataset by spatial
% subsampling of a high order reference HRTF dataset of the Neumann KU100 
% at order N = 35 or N = 44.
%
% Output:
% sparseHRTFdataset     - Struct with sparse HRTF dataset. 
% sparseHRIRdataset     - Struct with sparse HRIR dataset. 
%
% Input:
% sparseGrid            - Sparse sampling grid, e.g. created with one of
%                         the supdeq grid functions (supdeq_lebedev, supdeq_gauss, etc.)
% NmaxSparse            - Highest stable grid order of sparse grid. Only
%                         required for metadata of sparseHRTFdataset struct
% referenceOrder        - Chose N = 35 or N = 44 (SH order used to
%                         transform the reference dataset)
%                         Default: N = 35
%
% Dependencies: SOFiA toolbox, AKtools
%
% (C) 2020 by JMA, Johannes M. Arend
%             TH K�ln - University of Applied Sciences
%             Institute of Communications Engineering
%             Department of Acoustics and Audio Signal Processing

function [sparseHRTFdataset, sparseHRIRdataset] = supdeq_getSparseDataset(sparseGrid,NmaxSparse,referenceOrder)

if nargin < 1
    error('Please define a sparse grid.');
end

if nargin < 2
    error('Please define NmaxSparse.');
end

if nargin < 3 || isempty(referenceOrder)
    referenceOrder = 35;
end

if referenceOrder ~= 35 && referenceOrder ~= 44
    error('Reference dataset only available at N = 35 or N = 44.');
end

%% Get sparse datasets

%Load reference dataset
if referenceOrder == 35
    referenceHRTFdataset = importdata('HRIRs_sfd_N35.mat');
end
if referenceOrder == 44
    referenceHRTFdataset = importdata('HRIRs_sfd_N44.mat');
end

%Get HRTFs from referenceHRTFdataset
[sparseHRTFdataset.HRTF_L, sparseHRTFdataset.HRTF_R] = supdeq_getArbHRTF(referenceHRTFdataset,sparseGrid,'DEG',2,'ak');
%Fill struct with additional info
sparseHRTFdataset.f = referenceHRTFdataset.f;
sparseHRTFdataset.Nmax = NmaxSparse;
sparseHRTFdataset.FFToversize = referenceHRTFdataset.FFToversize;
sparseHRTFdataset.samplingGrid = sparseGrid;
if isfield(referenceHRTFdataset,'sourceDistance')
    sparseHRTFdataset.sourceDistance = referenceHRTFdataset.sourceDistance;
end

%Get HRIRs from referenceHRTFdataset
[sparseHRIRdataset.HRIR_L, sparseHRIRdataset.HRIR_R] = supdeq_getArbHRIR(referenceHRTFdataset,sparseGrid,'DEG',2,'ak');
sparseHRIRdataset.Nmax = NmaxSparse;
sparseHRIRdataset.samplingGrid = sparseGrid;
if isfield(referenceHRTFdataset,'sourceDistance')
    sparseHRIRdataset.sourceDistance = referenceHRTFdataset.sourceDistance;
end

end

