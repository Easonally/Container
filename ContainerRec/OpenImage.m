global filepath;
[filename, pathname] = uigetfile({'*.pgm;*.jpg;*tif', '(*.pgm), (*.jpg), (*.tif)'; ...
   '*.*', 'All Files(*.*)' }, '��ѡ��һ��Ҫʶ��ļ�װ��ͼ��');
if filename~=0
    filepath = [pathname,filename];
    axes(h_axes1),imshow(imread(filepath));
end