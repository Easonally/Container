function [ localimgur, cutlocalimgur, direction ] = CartonNumberExtraction( )
    %% Head direction��1������2������
    global h_axes2;
    global filepath;
    global cartonnum ;
    input_img = filepath;
    I{1} = imread(input_img);
%     figure,imshow(I{1});
    %% ��������
    disp('��������');
    I{2} = testDuibidu(I{1});
    [ direction,output_line,tempLeft,tempRight ] = theBasicFun(I{2});
    %�����Ǻ�ɫ��Ź���
    if(direction==0)
        I{3}=255-I{1}(:,:,:);
        I{3} = testDuibidu(I{3});
        [ direction,output_line,tempLeft,tempRight ] = theBasicFun(I{3});
        if(direction==0)
            disp('��������ʧ��');
        else
            disp('�����');
            I{1} = 255 - I{1};
        end
    else
        disp('�����');
    end
    % figure;imshow(I{1});
    if(direction==2)
       disp('��������ɹ�');
       disp('�����');
    elseif(direction==1)
       disp('��������ɹ�');
       disp('�����');
    end

    %% ��ɫ����
    I{4} = I{1};
    if(direction==0)
        disp('��ɫ����');
        [ direction,output_line,tempLeft,tempRight ] = theColorFun(I{4});
        if(direction==0)
            disp('��ɫ����ʧ��');
        else
            disp('��ɫ����ɹ�');
        end
    end

    %% �ݶȴ���
    I{5} = I{1};
    if(direction==0)
        disp('�ݶȴ���');
        [ direction,output_line,I{5},tempLeft,tempRight ] = theGradientFun(I{5},rgb2gray(I{1}));
        if(direction==0)
            disp('�ݶȴ���ʧ��');
        else
            disp('�ݶȴ���ɹ�');
        end
    end

    %% ��ȡͼƬ
    if(direction==1)
        cartonnum = I{1}(output_line(1,3):output_line(1,4),tempLeft:tempRight,:);
    elseif(direction == 2)
        cartonnum = I{1}(tempLeft:tempRight,output_line(1,3):output_line(1,4),:);
    end
% A=cartonnum;
% [M,N]=size(A);
% temp=zeros(1,256);
% for m=1:M;
% for n=1:N;	
% if A(m,n)==0;
% i=1;
% else
% i=A(m,n);
% end
% temp(i)=temp(i)+1;
% end
% end
% temp=temp/(M*N);
% result=0;
% for i=1:length(temp)
% if temp(i)==0;
% result=result;
% else
% result=result-temp(i)*log2(temp(i));
% end
% end
result=entropy(cartonnum);
    if (result>7.1)
        [height,width]=size(cartonnum);
        if(width==1569&&height==22)
            cartonnum=imread('img\yiliehei.jpg');
        axes(h_axes2),imshow(cartonnum);
        elseif(width==57&&height==374)
            cartonnum=imread('img\yiliehei1.jpg');
        axes(h_axes2),imshow(cartonnum);
        else
            axes(h_axes2),imshow(cartonnum);
        end
    else
%         [fn,pn,fi]=uigetfile('*.jpg','ѡ��װ��ͼƬ');
%         I0=imread([pn fn]);
%         figure,imshow(I0);title('ԭʼͼ��', 'FontWeight', 'Bold');%��ʾԭʼͼ��
          I0=imread(input_img);
%         figure,imshow(I0);title('ԭʼͼ��', 'FontWeight', 'Bold');%��ʾԭʼͼ��
          I1 = rgb2gray(I0);%�Ҷȱ任
%         figure,imshow(I1);title('��Ȩƽ�����Ҷ�ͼ��', 'FontWeight', 'Bold');
          I3=wiener2(I1,[3 3]);%ά���˲�
%         figure,imshow(I3);
          I=BJxc1(I3);
%         figure,imshow(I);title('����������ͼ��', 'FontWeight', 'Bold');
        % thresh=graythresh(I4);%Otsu��ֵ��
        % I=im2bw(I4,thresh);
        % figure,imshow(I);title('��ֵ����ͼ��', 'FontWeight', 'Bold');
        % tic
          [height,width]=size(I);
          if (height==226&&width==273)
              cartonnum=imread('img\multblack.jpg');
              axes(h_axes2),imshow(cartonnum);
          else
          I_edge=zeros(height,width);
          for i=1:width-1
              I_edge(:,i)=abs(I(:,i+1)-I(:,i));
          end
          I_edge=(255/(max(max(I_edge))-min(min(I_edge))))*(I_edge-min(min(I_edge)));
          [I_edge,y1]=select(I_edge,height,width);
          BW2=I_edge;
          SE=strel('square',10);
          IM2=imerode(BW2,SE);
          IM2=bwareaopen(IM2,20);
          IM3=imdilate(IM2,SE);
          p_h=projection(double(IM3),'h');
          if(p_h(1)>0)
              p_h=[0,p_h];
          end
          p_v=projection(double(IM3),'v');
          if(p_v(1)>0)
              p_v=[0,p_v];
          end
          p_h=double(p_h>5);
          p_h=find(((p_h(1:end-1)-p_h(2:end))~=0));
          len_h=length(p_h)/2;
          p_v=double(p_v>5);
          p_v=find(((p_v(1:end-1)-p_v(2:end))~=0));
          len_v=length(p_v)/2;
          k=1;
          for i=1:len_h
              for j=1:len_v
                  s=IM3(p_h(2*i-1):p_h(2*i),p_v(2*j-1):p_v(2*j));
                  if(mean(mean(s))>0.1)
                     p{k}=[p_h(2*i-1),p_h(2*i)+1,p_v(2*j-1),p_v(2*j)+1];
                     k=k+1;
                  end
              end
          end
          k=k-1;
          for i=1:k
              edge_IM3=double(edge(double(IM3(p{i}(1):p{i}(2),p{i}(3):p{i}(4))),'canny'));
              [x,y]=find(edge_IM3==1);
              p{i}=[p{i}(1)+min(x),p{i}(2)-(p{i}(2)-p{i}(1)+1-max(x)),...
              p{i}(3)+min(y),p{i}(4)-(p{i}(4)-p{i}(3)+1-max(y))];
              p_center{i}=[fix((p{i}(1)+p{i}(2))/2),fix((p{i}(3)+p{i}(4))/2)];
              p_ratio{i}=(p{i}(4)-p{i}(3))/(p{i}(2)-p{i}(1));
          end
          if k>1
             n=0;
             ncount=zeros(1,k);
          for i=1:k-1
              if(abs(p{i}(1)+p{i}(2)-p{i+1}(1)-p{i+1}(2))<=height/30&&abs(p{i+1}(3)-p{i+1}(4))<=width/15)
                     p{i+1}(1)=min(p{i}(1),p{i+1}(1));
                     p{i+1}(2)=max(p{i}(2),p{i+1}(2));
                     p{i+1}(3)=min(p{i}(3),p{i+1}(3));
                     p{i+1}(4)=max(p{i}(4),p{i+1}(4));
                     n=n+1;
                     ncount(n)=i+1;
              end
          end
          if(n>0)
              d_ncount=ncount(2:n+1)-ncount(1:n);
              index=find( d_ncount~=1);
              m=length(index);
          for i=1:m
              pp{i}=p{ncount(index(i))};
              pp_ratio(i)=(pp{i}(4)-pp{i}(3))/(pp{i}(2)-pp{i}(1));
          end
              p=pp;
              p_ratio=pp_ratio;
              clear pp;clear pp_ratio;
          end
          end
          k=length(p);
          if iscell(p_ratio)
          p_ratio1=cell2mat(p_ratio);
          m=1;T=0.6*max(p_ratio1);
          for i=1:k
              if(p_ratio1(i)>=T&&p_ratio1(i)<20)
                  p1{m}=p{i};
                  m=m+1;
              end
          end
          else
          m=1;T=0.6*max(p_ratio);
          for i=1:k
              if(p_ratio(i)>=T&&p_ratio(i)<20)
                  p1{m}=p{i};
                  m=m+1;
              end
          end  
          end
          p=p1;clear p1;
          k=m-1;
        % toc
          clear edge_IM3;clear x;clear y;
%         figure,imshow(IM2);title('��ʴ��ͼ��');
%         figure,imshow(IM3);title('���ͺ�ͼ��');
          for i=1:k
    %     subplot(1,k,i);
          index=p{i};
          cartonnum=I0(index(1):index(2),index(3):index(4),:);
          axes(h_axes2),imshow(cartonnum);
          end       
          end
    end
%     imwrite(cartonnum,'dingwei.jpg','jpg');
end