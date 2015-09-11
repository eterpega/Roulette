colors = [[1 0 0];
	  [1 0.5 0];
	  [1 0.9 0];
	  [0 1 0];
	  [0 1 1];
	  [0 0 1];
	  [0 0.5 0.5];
	  [0.5 0 0.5];
	 ];
device = '-depsc';
suffix = 'eps';
seed = 1;
plotdir = 'Plots';
set(0,'DefaultTextFontsize', 24);
set(0,'DefaultAxesFontsize', 24);
set(0,'DefaultLineLinewidth', 3);
set(0,'DefaultAxesLineWidth', 3); 
version = '0.9';

rootdir = pwd;
path(path,[rootdir]);
path(path,[rootdir '/Curves/']);
path(path,[rootdir '/Tests_and_Examples/']);
path(path,[rootdir '/Roulettes/']);
debug = 0;
