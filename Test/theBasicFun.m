function [ direction, output_line,tempLeft,tempRight ] = theBasicFun( input_img )
    I{1} = input_img;
%     figure,imshow(I{1});
    I{2} = edge(I{1},'canny');%��Canny�ı�Ե���
%     figure,imshow(I{2});
    [m,n]=size(I{2});%���ͼ��ĳ���
    validMark = 0;
    direction = 0;
    output_line = 0;
    %����λ�ı�ǣ�1�����ڵĴ�����2�����׵Ĵ�����3�ϱ߽磬4�±߽�,5��¼�ĺ�ɫ
    tarP{5} = 0;
    for i=1:5
        tarP{i} = 0;
    end
%     figure;subplot(2,2,1);plot(sum(I{2}'));title('ˮƽͶӰ');
%     subplot(2,2,2);imshow(I{2});
%     subplot(2,2,4);plot(sum(I{2}));title('��ֱͶӰ');
%% �����Ƕ�ͼ�����Ŷ�λ
    I{3} = I{2};
    for tarx=1:m
        if(sum(I{3}(tarx,:))<30)
            I{3}(tarx,:)=0;%ͼ��ȫ�ڵ�,tarP{1}��1
        elseif(sum(I{3}(tarx,:))>80) %ͼ���ɫ�����5�ģ�tarP{2}��1
           I{3}(tarx,:)=0;%ͼ��ȫ�ڵ�,tarP{1}��1
        end
    end
    for tarx=1:m
        if(sum(I{3}(tarx,:))==0)
            tarP{1} = tarP{1}+1;
            if(tarP{1}>5)
                if(tarP{3}>0)
                    tarP{4} = tarx;
%                         disp(['�±߽綨λ�ɹ�:',num2str(tarP{4}),';',num2str(tarP{3})]);
                    if((tarP{4}-tarP{3})>20)
                       isTrueNum = verifyConDomain(I{1},tarP{3},tarP{4},1);
                        if(isTrueNum ==1)
%                             disp(6['��λ�ɹ����ϣ�',num2str(tarP{3}),'X�£�',num2str(tarP{4}),')']);
                            validMark = 1;
                            break;
                        else
                            for i=1:5
                                tarP{i} = 0;
                            end
                        end
                    else
                        tarP{4}=0;
                        tarP{3}=0;
                    end
                else
                    tarP{5} = tarx;
                end

                if(tarP{2}<15&&tarP{2}>5)%������ڵ�ʱͼ���������ɫ��С��20����5����ɫ��������
                    tarP{2} = 0;
    %                 disp(['���P2:',num2str(tarx)]);
                end
            end
        else
          tarP{2} = tarP{2}+1;
            if(tarP{2}>2)
                if(tarP{3}==0)
                    tarP{3} = tarP{5};
    %                     disp(['�ϱ߽綨λ�ɹ�:',num2str(tarP{3})]);
        %             break;
                end
             end
            tarP{1} = 0;
        end
    end
   if(validMark==1)
    %     imwrite(input_Img(tarP{3}-4:tarP{4}+4,:),'sensitiveArea.jpg')%����ͼ��Ϊ�ļ�
    for i=0:3
            I{2}(tarP{3}-4+i,:)=1;
            I{2}(tarP{4}+4-i,:)=1;
    end
        output_line = tarP;
        direction = 1;
        if iscell(output_line)
        output_line=cell2mat(output_line);
        end
if (output_line~=0)          
   com=zeros(1,n);
for j=1:n %��ˮƽ��λ���������������ֱͶӰ
    for i=output_line(1,3):output_line(1,4)
        if I{1}(i,j)~=0
            com(j)=com(j)+1;
        end
    end
end

for j=1:n %��λ����������߽�
    if com(j)>4
        tempLeft=j;
        break;
    end
end
for j=n:-1:tempLeft+1 %��λ���������ұ߽�
    if com(j)>8
        tempRight=j;
        break;
    end
end
else
        tempLeft=0;
        tempRight=0;
end
% cartonnum = I{1}(output_line(1,3):output_line(1,4),tempLeft:tempRight,:);
% figure,imshow(cartonnum);
end

     
%% �����Ƕ�ͼ������Ŷ�λ
 if(validMark==0)
    for i=1:5
        tarP{i} = 0;
    end
     I{4} = I{2};
        for tary=1:n
            if(sum(I{4}(:,tary))<30)
                I{4}(:,tary)=0;%ͼ��ȫ�ڵ�,tarP{1}��1
            elseif(sum(I{4}(:,tary))>80) %ͼ���ɫ�����5�ģ�tarP{2}��1
               I{4}(:,tary)=0;%ͼ��ȫ�ڵ�,tarP{1}��1
            end
        end
        for tary=1:n
            if(sum(I{4}(:,tary))==0)
                tarP{1} = tarP{1}+1;
                if(tarP{1}>5)
                    if(tarP{3}>0)
                        tarP{4} = tary;
%                             disp(['�ұ߽綨λ�ɹ�:',num2str(tarP{4}),';',num2str(tarP{3})]);
                        if((tarP{4}-tarP{3})>10)
                            isTrueNum = verifyConDomain(I{1},tarP{3},tarP{4},2);
                            if(isTrueNum ==1)
%                                 disp(['��λ�ɹ�����',num2str(tarP{3}),'���ң�',num2str(tarP{4}),')']);
                                validMark = 2;
                                break;
                            else
                                for i=1:5
                                    tarP{i} = 0;
                                end
                            end
                        else
                            tarP{4}=0;
                            tarP{3}=0;
                        end
                    else
                        tarP{5} = tary;
                    end

                    if(tarP{2}<15&&tarP{2}>5)%������ڵ�ʱͼ���������ɫ��С��20����5����ɫ��������
                        tarP{2} = 0;
        %                 disp(['���P2:',num2str(tary)]);
                    end
                end
            else
              tarP{2} = tarP{2}+1;
                if(tarP{2}>2)
                    if(tarP{3}==0)
                        tarP{3} = tarP{5};
        %                     disp(['�ϱ߽綨λ�ɹ�:',num2str(tarP{3})]);
            %             break;
                    end
                 end
                tarP{1} = 0;
            end
        end

        if(validMark==2)
            for i=0:3
                I{2}(:,tarP{3}-4+i)=1;
                I{2}(:,tarP{4}+4-i)=1;
            end
            output_line = tarP;
            direction = 2;
        end
        if iscell(output_line)
        output_line=cell2mat(output_line);
        end
        if (output_line~=0)
        com=zeros(1,m);
for j=1:m %��ˮƽ��λ���������������ֱͶӰ
    for i=output_line(1,3):output_line(1,4)
        if I{1}(j,i)~=0
            com(j)=com(j)+1;
        end
    end
end

for j=1:m %��λ���������ϱ߽�
    if com(j)>0
        tempLeft=j;
        break;
    end
end
for j=m:-1:tempLeft+1 %��λ���������±߽�
    if com(j)>0
        tempRight=j;
        break;
    end
end 
        else
          tempLeft=0;
          tempRight=0;
        end
  end
end


