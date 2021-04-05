function [rtk,bias,xa,nb]=resamb(rtk)

global glc
bias=zeros(rtk.nx,1); xa=zeros(rtk.nx,1); nb=0; 
x=rtk.x; P=rtk.P; opt=rtk.opt; na=rtk.na;
rtk.sol.ratio=0;

if opt.mode<=glc.PMODE_DGNSS||opt.modear==glc.ARMODE_OFF...
        ||opt.thresar(1)<1||opt.ionoopt==glc.IONOOPT_IFLC
    return;
end

% single-difference to double-difference transformation matrix
D=zeros(rtk.nx,rtk.nx);
[rtk,D,nb]=ddmat(rtk,D);
if nb<=0,return;end

% trnasform single-difference ambiguity to double-difference ambiguity
ny=na+nb; D=D(1:ny,:);
y=D*x; Qy=D*P*D'; 
Qxx=Qy(1:rtk.ib,1:rtk.ib);
Qxb=Qy(1:rtk.ib,rtk.ib+1:end);
Qbb=Qy(rtk.ib+1:end,rtk.ib+1:end);
x_float=y(1:rtk.ib); 
bias_float=y(rtk.ib+1:end); 

%Is the Q-matrix symmetric?
if ~isequal(Qbb-Qbb'<1E-8,ones(size(Qbb)));
  fprintf('Warning:Variance-covariance matrix of ambiguity is not symmetric!\n');
  nb=0; return;
end

%Is the Q-matrix positive-definite?
if sum(eig(Qbb)>0) ~= size(Qbb,1);
  fprintf ('Warning:Variance-covariance matrix is not positive definite!');
  nb=0; return;
end;

% LAMBDA algorithm for ambiguty resolution
if opt.LAMBDAtype==glc.LAMBDA_ALL
    
    % resolve all ambiguity
    [bias_fix,sqnorm,~,~,~,~,~]=LAMBDA(bias_float,Qbb,6,'ncands',2,'P0',...
                                            0.001,'MU',1/opt.thresar(1));

    % ratio test
    if sqnorm(1)>0
        rtk.sol.ratio=sqnorm(2)/sqnorm(1);
    else
        rtk.sol.ratio=0;
    end
    if rtk.sol.ratio>999.9,rtk.sol.ratio=999.9;end
    
    if sqnorm(1)<=0||rtk.sol.ratio>=opt.thresar(1)
        rtk.xa(1:na)=rtk.x(1:na);
        rtk.Pa(1:na,1:na)=rtk.P(1:na,1:na);
        bias(1:nb)=bias_fix(:,1);
        if det(Qbb)
            rtk.xa=x_float-Qxb*cholinv(Qbb)*(bias_float-bias_fix(:,1));
            rtk.Pa=Qxx-Qxb*Qbb^-1*Qxb';
            xa=restamb(rtk,bias,nb,xa);
%             [week,sow]=time2gpst(rtk.sol.time);
%             fprintf('Info:GPS week = %d sow = %.3f,AR success\n',week,sow);
        else
            nb=0;
%             [week,sow]=time2gpst(rtk.sol.time);
%             fprintf('Info:GPS week = %d sow = %.3f,AR failed!!!\n',week,sow);
        end
    else
        nb=0;
%         [week,sow]=time2gpst(rtk.sol.time);
%         fprintf('Info:GPS week = %d sow = %.3f,AR failed!!!\n',week,sow);
    end

elseif opt.LAMBDAtype==glc.LAMBDA_PART
    % resolve partial ambiguity
    [bias_fix,~,Ps,~,~,~,~]=LAMBDA(bias_float,Qbb,5,'ncands',2,'P0',...
                                               opt.thresar(2),'MU',0.6);
    
    % success rate test
    rtk.sol.ratio=0;

    if Ps>=opt.thresar(2)
        rtk.xa(1:na)=rtk.x(1:na);
        rtk.Pa(1:na,1:na)=rtk.P(1:na,1:na);
        bias(1:nb)=bias_fix(:,1);
        if det(Qbb)
            rtk.xa=x_float-Qxb*cholinv(Qbb)*(bias_float-bias_fix(:,1));
            rtk.Pa=Qxx-Qxb*Qbb^-1*Qxb';
            xa=restamb(rtk,bias,nb,xa);
%             [week,sow]=time2gpst(rtk.sol.time);
%             fprintf('Info:GPS week = %d sow = %.3f,PAR success\n',week,sow);
        else
            nb=0;
%             [week,sow]=time2gpst(rtk.sol.time);
%             fprintf('Info:GPS week = %d sow = %.3f,PAR failed!!!\n',week,sow);
        end
    else
        nb=0;
%         [week,sow]=time2gpst(rtk.sol.time);
%         fprintf('Info:GPS week = %d sow = %.3f,PAR failed!!!\n',week,sow);
    end    
end

return

