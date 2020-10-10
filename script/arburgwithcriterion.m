function varargout = arburgwithcriterion( x,criterion )
%ARBURGWITHCRITERION   AR parameter estimation via Burg method.
%   A = ARBURGWITHCRITERION(X) returns the polynomial A corresponding to the AR
%   parametric signal model estimate of vector X using Burg's method.
%   模型阶次选择默认为最小预测定误差阶准则（Final Prediction Error Criterion,FPE）
%   可选用的模型定阶准则有FPE, AIC, MDL, CAT定阶准则
%
%   [A,E] = ARBURGWITHCRITERION(...) returns the final prediction error E (the variance
%   estimate of the white noise input to the AR model).
%
%   [A,E,K] = ARBURGWITHCRITERION(...) returns the vector K of reflection 
%   coefficients (parcor coefficients).
%
%   [A,E,K,P] = ARBURGWITHCRITERION(...)returns the order P of the AR
%   model.

%   Ref: 祈才君，数字信号处理技术的算法分析与应用
%              机械工业出版社, 2005, Chapter 8

%   最初版本：V1.0       时间：2009.03.31

narginchk(1,2)

if nargin == 1
    criterion = 'FPE';
end

[mx,nx] = size(x);
if isempty(x) || min(mx,nx) > 1,
   error('X must be a vector with length greater than twice the model order.');
elseif ~(strcmp(criterion,'FPE') || strcmp(criterion,'AIC') || strcmp(criterion,'MDL') || strcmp(criterion,'CAT'))
   error('不正确的定阶准则。')
end
if issparse(x),
   error('Input signal cannot be sparse.')
end

x  = x(:);
N  = length(x);

% Initialization
orderpridict = 1;
ef = x;
eb = x;
a = 1;

% Initial error
E = x'*x./N;
if strcmp(criterion,'FPE')
    objectfun = (N+1)/(N-1)*E;
elseif strcmp(criterion,'AIC')
    objectfun = N*log(E)+2*1;
elseif strcmp(criterion,'MDL')
    objectfun = N*log(E)+1*log(N);
elseif strcmp(criterion,'CAT')
    temp = (N-1)/(N*E);
    objectfun = 1/N*(N-1)/(N*E)-(N-1)/(N*E);
end

% Preallocate 'k' for speed.
% 一般AR模型阶次P<N/3，为k预分配N个空间
k = zeros(1, N);

for m = 1:N-1
   % Calculate the next order reflection (parcor) coefficient
   efp = ef(2:end);
   ebp = eb(1:end-1);
   num = -2.*ebp'*efp;
   den = efp'*efp+ebp'*ebp;
   
   k(m) = num ./ den;
   
   % Update the forward and backward prediction errors
   ef = efp + k(m)*ebp;
   eb = ebp + k(m)'*efp;
   
   % Update the AR coeff.
   a=[a;0] + k(m)*[0;conj(flipud(a))];
   
   % Update the prediction error
   E(m+1) = (1 - k(m)'*k(m))*E(m);
   
   % 判断是否达到所选定阶准则的要求
   if strcmp(criterion,'FPE')
       objectfun(m+1) = (N+(m+1))/(N-(m+1))*E(m+1);
   elseif strcmp(criterion,'AIC')
       objectfun(m+1) = N*log(E(m+1))+2*(m+1);
   elseif strcmp(criterion,'MDL')
       objectfun(m+1) = N*log(E(m+1))+(m+1)*log(N);
   elseif strcmp(criterion,'CAT')
       for index = 1:m+1
           temp = temp+(N-index)/(N*E(index));
       end
       objectfun(m+1) = 1/N*temp-(N-(m+1))/(N*E(m+1));
   end
   
   if objectfun(m+1) >= objectfun(m) % 该阶预测误差大于上一阶预测误差，则阶次定为上一阶
       orderpredict = m;
       break;
   end
end

% 实际k矩阵
k = k(1:orderpredict);

a = a(:).'; % By convention all polynomials are row vectors
varargout{1} = a(1:orderpredict);
if nargout >= 2
    varargout{2} = E(orderpredict);
end
if nargout >= 3
    varargout{3} = k(:);
end
if nargout >= 4
    varargout{4} = orderpredict;
end

% [EOF] arburgwithcriterion.m