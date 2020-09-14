clc;
close all;
clear;
% �Ҩ�N�X1    �~��2   ����(�ʸU��)3	���L��(��)_�~4	���q��5	�ѻ��b�Ȥ�6	
% �ѻ��禬��7	M�b�ȳ��S�v�w�|��8	�겣���S�vROA9	��~�Q�q�vOPM10	�Q�����NPM11 �t��/�b�Ȥ�12	
% M�y�ʤ�v13	M�t�ʤ�v14	M�s�f�g��v (��)15	M�����b�ڶg�স16	M��~�Q�q�����v17	
% M�|��b�Q�����v18	Return19	ReturnMean_year_Label 20
labelname= {'�Ҩ�N�X1  '  ,'�~��2 ' , '����(�ʸU��)3'	,'���L��(��)_�~4	','���q��5','�ѻ��b�Ȥ�6','�ѻ��禬��7',	'M�b�ȳ��S�v�w�|��8',	'�겣���S�vROA9'	,'��~�Q�q�vOPM10'	,'�Q�����NPM11' ,'�t��/�b�Ȥ�12'	,'M�y�ʤ�v13',	'M�t�ʤ�v14',	'M�s�f�g��v (��)15'	,'M�����b�ڶg�স16'	,'M��~�Q�q�����v17'	,'M�|��b�Q�����v18',	'Return19',	'ReturnMean_year_Label20'};
datalist = dir('top200.xls');
data = xlsread(datalist(1,1).name);
data(:,2)=[]; %�h������W��
the_data=[]; %��ܨϥΪ�data
the_stock=[]; %�x�s�諸�Ѳ�
the_accuracy=[]; %�x�sTV�����T�v
the_return=[]; %�x�sreturn�� 1���`(���)return 2���w��return 
label=[6,7,9,14,15]; %6,7,9,12

%% �������
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

%% �N��ܪ�attribute��Jthe_data
for i=1:length(label)
    the_data(:,i)=data(:,label(i));
end

%% �k�@��
datalength = length(the_data);
minValue = min(the_data);
maxValue = max(the_data);
ranges = maxValue - minValue;
the_data = (the_data- repmat(minValue,datalength,1))./repmat(ranges,datalength,1);

%% �}�lKnM
train_data=[]; %�x�s�V�m�����
train_ans=[]; %�x�s�V�m��ƪ�����
test_data=[]; %�x�s���ժ����
test_ans=[]; %�x�s���ժ�����
TV = count_set-2;
for i=1:TV-1
    train_num = set_num(i,2);  %�V�m��ĴX�����
    test_num = set_num(i+1,1);  %�q�ĴX����ƶ}�l����
    train_data = the_data(1:train_num,1:end); %�V�m���
    train_ans = data(1:train_num,20); %�V�m����
    test_data = the_data(test_num:end,1:end); %���ո��
    test_ans = data(test_num:end,20); %���յ���
    [result_1,result_2]=knmTrain(train_data,train_ans);
    the_predict=knmPredict(result_1,result_2,test_data);  %result_1 result_2���V�m���G test_data���V�m���
    KnM_accuracy=length(find(the_predict == test_ans))/length(test_ans)*100; %�⥿�T�v
    the_accuracy(i,1)=KnM_accuracy;
    
    origin_return=0; %���ո�ƩҦ���return
    origin_count=0; %���ո�Ʋέpreturn�`��
    predict_return=0; %�w����ƹw����1��return
    predict_count=0;  %�w����Ƭ�1��return�`��
    for k=1:length(the_predict) %�έpreturn��
        if data(test_num-1+k,19)~=-100
            origin_return=origin_return + data(test_num-1+k,19);
            origin_count = origin_count+1;

            if the_predict(k)==1
                predict_return = predict_return + data(test_num-1+k,19); %�w����return
                predict_count = predict_count + 1;
                the_stock(predict_count,1:2)=data(test_num-1+k,1:2);
            end
        end
    end
    the_return(i,1)=origin_return./origin_count;
    the_return(i,2)=predict_return./predict_count;
end

%% �e���
TV=[1:length(the_return)];
figure(1); %�L�Xreturn
plot(TV,the_return(:,1),'b.-','MarkerSize',12);
hold on;
xlabel ('TV');
ylabel('return');
plot(TV,the_return(:,2),'r.-','MarkerSize',12)
hold on
grid on %���X��u
title ([labelname(label(:,:))]);
legend('realreturn' ,'prediction' ,'Location','NW')
print(gcf,'-dpng','final.png'); 

figure(2); %�L�X���T�v
plot(TV,the_accuracy,'mo-','MarkerSize',12);
hold on;
xlabel ('TV');
ylabel('Accuracy');
grid on %���X��u
title ([labelname(label(:,:))]);
legend('accuracy' ,'Location','NW')
print(gcf,'-dpng','Accuracy.png'); 