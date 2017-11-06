%% ��ջ�������
clc;
clear;
close all;
format compact;
%% �������������
tic;
Files=dir('data\10.jpg');
rand = randperm(length(Files));
randFiles = Files(rand(1:10),:);
LengthFiles=length(randFiles);
for i=1: LengthFiles
    input_img = imread(strcat('data\',Files(i).name));
    cartonnum = CartonNumberExtraction(input_img);
    zifufenge=CharacterSegmentation(cartonnum);
    [xianghao,Accuracy]=CharacterRecognition( );
    totalxianghao{i,:}=xianghao;
end
toc;
time=strcat('����ʱ�䣺',num2str(toc),'s');