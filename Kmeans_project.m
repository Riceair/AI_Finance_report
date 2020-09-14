clc;
close all;
clear;
% �Ҩ�N�X1    �~��2   ����(�ʸU��)3	���L��(��)_�~4	���q��5	�ѻ��b�Ȥ�6	
% �ѻ��禬��7	M�b�ȳ��S�v�w�|��8	�겣���S�vROA9	��~�Q�q�vOPM10	�Q�����NPM11 �t��/�b�Ȥ�12	
% M�y�ʤ�v13	M�t�ʤ�v14	M�s�f�g��v (��)15	M�����b�ڶg�স16	M��~�Q�q�����v17	
% M�|��b�Q�����v18	Return19	ReturnMean_year_Label20
labelname= {'�Ҩ�N�X1  ' ,'�~��2 ' , '����(�ʸU��)3'	,'���L��(��)_�~4	','���q��5','�ѻ��b�Ȥ�6','�ѻ��禬��7',	'M�b�ȳ��S�v�w�|��8','�겣���S�vROA9'	,'��~�Q�q�vOPM10'	,'�Q�����NPM11' ,'�t��/�b�Ȥ�12'	,'M�y�ʤ�v13',	'M�t�ʤ�v14',	'M�s�f�g��v (��)15'	,'M�����b�ڶg�স16'	,'M��~�Q�q�����v17'	,'M�|��b�Q�����v18',	'Return19',	'ReturnMean_year_Label20'};
datalist=dir('top200.xls');
stockreturn =[];
the_return =[];
the_stock=[];
current_return=[];
current_length=1;
data=xlsread(datalist(1,1).name); %Ū�ixls�ɮרåh���Ĥ@�C
data(:,2)=[]; %�h���ĤG�椤��W��
label=[7,9,10,12,15]; %9 10 12  %���q��99999

%%
%�������
set_num=[]; %�x�s�C200���ƪ�range ex.1��200 201��400....
count_set=1; %�x�s�{�b����ĴX�~
for i = 1 : length(data)
    if mod(i,200)==1
        set_num(count_set,1) = i;
    elseif mod(i,200)==0
        set_num(count_set,2) = i;
        count_set=count_set+1;
    end
end

%%
for j = 1 : length(set_num)
    for i = 1 : length(label)
        X(:,i)=data(set_num(j,1):set_num(j,2),label(i)); %set_num(j,1) set_num(j,2)
    end
    stockreturn(:,1) = data(set_num(j,1):set_num(j,2),1);  %column 1 �Ѳ��N�X
    stockreturn(:,2) = data(set_num(j,1):set_num(j,2),19); %column 2 19�檺return
    opts = statset('Display','iter');
    
    %% �p��Ӧ~���`return
    real_returnsum=0;
    real_returncount=0;
    for i = 1 : length(stockreturn)
        if stockreturn(i,2)~=-100
            real_returnsum = real_returnsum + stockreturn(i,2);
            real_returncount = real_returncount+1;
        end
    end
    the_return(j,1)= real_returnsum/real_returncount;
    
    %% �k�@��
    datalength = length(X);
    minValue = min(X);
    maxValue = max(X);
    ranges = maxValue - minValue;
    X = (X- repmat(minValue,datalength,1))./repmat(ranges,datalength,1);
    %%
    %�I�sKmeans�禡
    %X N*P����Ưx�}
    %Idx N*1���V�q,�x�s���O�C���I���E���и�
    %Ctrs K*P���x�},�x�s���OK�ӻE����ߦ�m
    %SumD 1*K���M�V�q,�x�s���O�����Ҧ��I�P��������I�Z�����M
    %D N*K���x�}�A�x�s���O�C���I�P�Ҧ���ߪ��Z��;
    %eva=evalclusters(X,'kmeans','CalinskiHarabasz','KList',[1:10])  %���ճ̨δX�s
    %plot(eva)  %��ܩ��㪺���s�Ʀr
    
    K=5;
    [Idx,Ctrs,SumD,D] = kmeans(X,K,'Start','cluster','Replicates',3);
    stockreturn(:,3) = Idx;  %column 3 �x�s����
    
    for i=1:K
    sumreturn = 0;
    countreturn = 0;
        for k = 1:length(stockreturn)
            if stockreturn(k,3)==i
                sumreturn = sumreturn + stockreturn(k,2);
                countreturn = countreturn + 1;
            end
        end
        current_return(i,1)=sumreturn;  %�`return
        current_return(i,2)=countreturn;
        current_return(i,3)=sumreturn/countreturn;
    end
    [the_max,index]=max(current_return(:,3)); %the_max��
    
    for i = 1 : length(stockreturn)
        if stockreturn(i,3)==index;
            the_stock(current_length,1:2)=data(set_num(j,1)+i,1:2);
            current_length=current_length+1;
        end
    end
    
    the_return(j,2)=the_max;
end

%% �e��
figure(1); %�L�Xreturn
the_year=[1:length(set_num)];
plot(the_year,the_return(:,1),'b.-','MarkerSize',12);
hold on;
xlabel ('year');
ylabel('return');
plot(the_year,the_return(:,2),'r.-','MarkerSize',12)
hold on
grid on %���X��u
title ([labelname(label(:,:))]);
legend('realreturn' ,'prediction' ,'Location','NW')