function rex = dwt_rex(signal,wavelet_level,wavelet_name)
[C,L]=wavedec(signal,wavelet_level,wavelet_name);
% cA7=appcoef(C,L,wavelet_name,wavelet_level);
rex=[];
for i=1:wavelet_level
  cd=wrcoef('d',C,L,wavelet_name,i);
  rex=[rex;cd];%i越大，频率越小
end