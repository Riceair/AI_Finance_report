function [label_1,label_2] = knmTrain(train_data,train_ans)
%	�ϥΦ�function�ݶǤJ �V�m���(�Ѽ�1) �V�m����(�Ѽ�2) ��:�V�m���ץ��� 1 or -1
%   �^��label_1 ���ݩ� label 1 �������I
%   �^��label_2 ���ݩ� label 2 �������I
[row,column]=size(train_data); %���otrain_data���x�}�j�p

count_label_1=0; %���ݩ�label1���`��
count_label_2=0; %���ݩ�label2���`��
sum_label_1=zeros(1,column); %���ݩ�label1���[�`
sum_label_2=zeros(1,column); %���ݩ�label2���[�`

for i = 1 : length(train_data) %�̷�label�����å[�`
    if train_ans(i)==1
        count_label_1 = count_label_1 + 1;
        sum_label_1 = sum_label_1 + train_data(i,:);
    elseif train_ans(i)==-1
        count_label_2 = count_label_2 + 1;
        sum_label_2 = sum_label_2 + train_data(i,:);
    end
end
label_1=sum_label_1./count_label_1; %�N�[�`�����^��
label_2=sum_label_2./count_label_2;
