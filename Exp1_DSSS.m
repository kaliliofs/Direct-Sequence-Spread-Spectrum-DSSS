%//////////////////////////// EXPERIMENT_1 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

clear all;
close all;
%% MSG
msg=randi([0,1],1,1000);                                                    % generating random binary sequence of 1000 bit
P_msg=((2*msg)-1);                                                          % polarizing the message
Rect_msg=rectpulse(P_msg,28);
t=[0:0.001:27.999];
plot(t,Rect_msg)                                                            
title('msg')
acf_msg=xcorr(Rect_msg);                                                    % Autocorrelation function of the message
t_1=linspace(-length(acf_msg)/2,length(acf_msg)/2,length(acf_msg));
figure
plot(t_1,acf_msg)
title('ACF of the msg')
psd=abs(fftshift(fft(acf_msg)));                                            %power sectral density of the message

figure
plot(t_1,psd)
title('PSD of msg')

%% CODE
code=[1 1 1 -1 -1 1 -1];
Rect_code=rectpulse(code,28);
t_2=[0:0.001/7:0.195/7];
figure
plot(t_2,Rect_code)
title('code')
acf_code=xcorr(code);                                                       % Autocorrelation function of the spreading code
t_3=linspace(-length(acf_code)/2,length(acf_code)/2,length(acf_code));
figure
plot(t_3,acf_code)
title('ACF of code')
PSD_code=abs(fftshift(fft(acf_code)));                                      %power sectral density of the spreading code
figure
plot(t_3,PSD_code)
title('PSD of code')
%% SPREDED MSG
% simple method
smsg=kron(Rect_msg,code);                                                   % spreading the message
acf_smsg=xcorr(smsg);                                                       % Autocorrelation function of the spreaded message
t_4=linspace(-length(acf_smsg)/2,length(acf_smsg)/2,length(acf_smsg));
figure
plot(t_4,acf_smsg)
title('acf of smsg')
PSD_smsg=abs(fftshift(fft(acf_smsg)));                                      %power sectral density of the spreaded message
figure
plot(t_4,PSD_smsg)
title('psd of smsg')
P_G=length(smsg)/length(Rect_msg)
%% DESPREDED MSG
adj_code=ones([1,28000]);                                                   
lon_code=kron(adj_code,code);
rec_msg=smsg.*lon_code;                                                     %despreading the message
dsmsg=downsample(rec_msg,7);                                                 
check=isequal(Rect_msg,dsmsg)                                               %checking if the despreaded message is the same as the i/p random sequence 
t_5=[0:0.001:27.999];
figure
plot(t_5,dsmsg)
title('reconstructed msg')
%% MATCHED FILTER
%matched code
h=fliplr(code);                                                             %generating the matched filter
MF_out=conv(smsg,h);                                                        %despreading the message using the matched filter
MF_sampled=MF_out(7:7:end);
d=MF_sampled >0;
dsmsg_2=2*d-1;
check_1= isequal(dsmsg,dsmsg_2)                                             %checking if the despreaded message is the same as the i/p random sequence 
figure
plot(t,dsmsg_2)
title('reconstructed msg in case of matched code')

%mismatch code
code_2=[-1 1 -1 1 -1 -1 -1 ];                                               
h2=fliplr(code_2);                                                          %generating the mismatched code for the matched filter
MF_out2=conv(smsg,h2);                                                      %despreading the message using the mismatched code
MF_sampled2=MF_out2(7:7:end);                                                   
d2=MF_sampled2 >0;
dsmsg_3=2*d2-1;
check_2= isequal(dsmsg,dsmsg_3)                                             %checking if the despreaded message is the same as the i/p random sequence
figure
plot(t,dsmsg_3)
title('reconstructed msg in case of mismatched code')







