%% �ɵ��õķ���
function [ OutMe ] = testDuibidu( imgUrl )
I0 = imgUrl;
I1 = rgb2gray(I0);%�Ҷȱ任
% figure,imshow(I1);title('�Ҷ�ͼ��', 'FontWeight', 'Bold');
I3=wiener2(I1,[3 3]);%ά���˲�
% figure,imshow(I3);
I4=BJxc(I3);
% figure,imshow(I4);title('����������ͼ��', 'FontWeight', 'Bold');
thresh=graythresh(I4);%Otsu��ֵ��
I6=im2bw(I4,thresh);
% figure,imshow(I6);title('��ֵ����ͼ��', 'FontWeight', 'Bold');
%     I0 = rgb2gray(I0);%�Ҷ�
%     K2 = imadjust(I0, [0.5 0.7], []);
%     K2 = ordfilt2(K2 ,5,ones(3,3));%�˲�
%     level = graythresh(K2);
%     I1=im2bw(K2,level);%OTUS��ֵ��
%     I1 =bwareaopen(I1,50);
% %     figure,imshow(I1);
% I7 =bwareaopen(I6,50);
% figure,imshow(I7);
OutMe = I6;
end