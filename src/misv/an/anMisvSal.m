function anMisvSal(src, wsSmp, wsSal, varargin)
% Animate segmentation for high-speed video.
%
% Input
%   src      -  source
%   wsSeg    -  segmentation
%   sSegs    -  segment's saliency, 1 x mSeg
%   varargin
%     fig    -  figure number, {2}
%     sizMa  -  maximum figure size, [1000, 1000]
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-24-2013
%   modify   -  Feng Zhou (zhfe99@gmail.com), 03-11-2014

% function option
fig = ps(varargin, 'fig', 10);
sizMa = ps(varargin, 'sizMa', [700 1200]);
ftSiz = ps(varargin, 'ftSiz', 15);
ftCl = ps(varargin, 'ftCl', [0 0 0]);
ftBkCl = ps(varargin, 'ftBkCl', [1 1 1]);

% save option
prex = src.tag;
prIn('anMisvSal', 'new, %s', prex);

% video in
hrVdo = misvRIn(src);

% sampling
[nF, pFs] = stFld(wsSmp, 'nF', 'pFs');

% sal in
hrSal = vdoRIn(wsSal.vdo, 'comp', 'mat');
siz = stFld(hrSal, 'siz');
R0 = stFld(wsSal, 'R');
R = ranConv(2000, 'both', R0);

% figure
rows = 3; cols = 4;
[Ax, figSiz] = iniAx(fig, rows, cols, siz([1 2]) .* [rows cols], 'hGap', 0, 'wGap', 0, 'sizMa', sizMa);
AxT = iniAxIn(Ax, [0.4, 0.85, .2, 0.1]);
%%%% how to save video%%%%%%
% mov(1:nF) = struct('cdata', [],...
%                         'colormap', []);
aviobj = avifile('mymovie.avi','fps',30); 
% plot frame
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);
    pF = pFs(iF);

    %% read video
    F0 = vdoR(hrVdo, pF);
    F = imresize(F0, siz);

    %% read saliency
    mat = vdoR(hrSal, iF);
    S = stFld(mat, 'S');
    S = ranNor(S, R(:, iF));
    
    %% overlay
    FS = heatmap_overlay(F, S);
%%%%%SHst%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SHst=stFld(mat,'SHst');
    SHst=ranNor(SHst, R(:, iF));
%     F2 = heatmap_overlay(F, SHst);
    F2 = SHst;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPri=stFld(mat,'SPri');
    SPri=ranNor(SPri, R(:, iF));
%     F3 = heatmap_overlay(F, SPri);
        F3 = SPri;
    %%%%%%%%%%%%%%%%%%%%
    SHstF=stFld(mat,'SHstF');
    SHstF=ranNor(SHstF, R(:, iF));
%     F4 = heatmap_overlay(F, SHstF);
F4 = SHstF;
    %%%%%%%%%%%%%%%%%%%%%%%%
    SHstM=stFld(mat,'SHstM');
    SHstM=ranNor(SHstM, R(:, iF));
%     F5 = heatmap_overlay(F, SHstM);
F5 = SHstM;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    SHstO=stFld(mat,'SHstO');
    SHstO=ranNor(SHstO, R(:, iF));
%     F6 = heatmap_overlay(F, SHstO);
F6 = SHstO;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPriS=stFld(mat,'SPriS');
    SPriS=ranNor(SPriS, R(:, iF));
%     F7 = heatmap_overlay(F, SPriS);
F7 = SPriS;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPriM=stFld(mat,'SPriM');
    SPriM=ranNor(SPriM, R(:, iF));
%     F8= heatmap_overlay(F, SPriM);
 F8= SPriM;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPriB=stFld(mat,'SPriB');
    SPriB=ranNor(SPriB, R(:, iF));
%     F9= heatmap_overlay(F, SPriB);
 F9= SPriB;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SPriA=stFld(mat,'SPriA');
    SPriA=ranNor(SPriA, R(:, iF));
%     F10 = heatmap_overlay(F, SPriA);
F10 = SPriA;
    
    
    
    
    %% show
    if iF == 1
        hFS = shImg(FS, 'ax', Ax{1, 1});
        hS = shImg(S, 'ax', Ax{1, 2});
        
        hS2 = shImg(F2, 'ax', Ax{1, 3});
        hS3 = shImg(F3, 'ax', Ax{1, 4});
        hS4 = shImg(F4, 'ax', Ax{2, 1});
        hS5 = shImg(F5, 'ax', Ax{2, 2});
        hS6 = shImg(F6, 'ax', Ax{2, 3});
        hS7 = shImg(F7, 'ax', Ax{2, 4});
        hS8 = shImg(F8, 'ax', Ax{3, 1});
        hS9 = shImg(F9, 'ax', Ax{3, 2});
        hS10 = shImg(F10, 'ax', Ax{3, 3});
        hS11 = shImg(F, 'ax', Ax{3, 4});
        
        
        
shStr('Heat Map', 'ax', AxT{1, 1}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('Saliency', 'ax', AxT{1, 2}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SHst', 'ax', AxT{1, 3}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SPri', 'ax', AxT{1, 4}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SHstF', 'ax', AxT{2, 1}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SHstM', 'ax', AxT{2, 2}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SHstO', 'ax', AxT{2, 3}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SPriS', 'ax', AxT{2, 4}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SPriM', 'ax', AxT{3, 1}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SPriB', 'ax', AxT{3, 2}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('SPriA', 'ax', AxT{3, 3}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);
shStr('Original', 'ax', AxT{3, 4}, 'ftCl', ftCl, 'ftSiz', ftSiz', 'ftBkCl', ftBkCl);

    else
        shImgUpd(hFS, FS);
        shImgUpd(hS, S);
        shImgUpd(hS2, F2);
        shImgUpd(hS3, F3);
        shImgUpd(hS4, F4);
        shImgUpd(hS5, F5);
        shImgUpd(hS6, F6);
        shImgUpd(hS7, F7);
        shImgUpd(hS8, F8);
        shImgUpd(hS9, F9);
        shImgUpd(hS10, F10);
        shImgUpd(hS11, F);
        
    end
     
    pause(.1);
     frame = getframe(gcf);
  aviobj = addframe(aviobj,frame);
   
%    mov(iF) = getframe(gcf);
   
end
aviobj = close(aviobj);
% movie2avi(mov, 'myPeaks.avi', 'compression', 'None');
prCOut(nF);

prOut;
