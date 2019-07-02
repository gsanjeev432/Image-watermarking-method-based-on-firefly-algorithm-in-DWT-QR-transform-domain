% function [best] = firefly

d=2;         % Number of Decision Variables
n=10;           % Number of Fireflies
smin=-10;       % Lower Bound value
smax=10;        % Upper Bound value
wdamp=0.99;     % Mutation Coefficient Damping Ratio
alpha=0.01;      % Mutation Coefficient/step size
beta0=1;        % maximum attractiveness
gamma=1;         % Light Absorption Coefficient
max_iter=10;        % Maximum Number of Iterations

cost_func=@(x) Griewank(x); % Cost Function

% Empty Firefly Structure
fly=struct();
fly.pos=[];
fly.cost=Inf;

final=repmat(fly,n,1);

% Initialize Best Solution
best=Inf;
pos_best=[];

% Create Initial Fireflies
for i=1:n
  final(i).pos=unifrnd(smin,smax,1,d);
  final(i).cost=cost_func(final(i).pos);
  if final(i).cost<best
    best=final(i).cost;
    pos_best=final(i).pos;
  end
end

%% Firefly Algorithm

for t=1:max_iter
  new_final=repmat(fly,n,1);
  for i=1:n
    new_final(i).cost=Inf;
    for j=1:n
            
      if final(j).cost>final(i).cost
        rs=sum((final(i).pos-final(j).pos).^2);
        beta=beta0*exp(-gamma*rs);
        epsilon=normrnd(0,(smax-smin)/12,1,d);
        
        new_fly.pos=final(i).pos+beta*(final(j).pos-final(i).pos)+alpha*epsilon;
        new_fly.pos=max(new_fly.pos,smin);
        new_fly.pos=min(new_fly.pos,smax);
        
        new_fly.cost=cost_func(new_fly.pos);
        
        if new_fly.cost<new_final(i).cost
          new_final(i).pos=new_fly.pos;
          new_final(i).cost=new_fly.cost;
        end                         
      end
    end 
    if new_final(i).cost<best
      pos_best=new_final(i).pos;
      best=new_final(i).cost;
    end
  end

  final=[final
         new_final];
     
  [~, SortOrder]=sort([final.cost]);
  final=final(SortOrder);
  final=final(1:n);
  
  alpha=alpha*wdamp;
  
  disp(['Iteration : ' num2str(t) ' Minimum value = ' num2str(best) ' Best solution is : ' num2str(pos_best)]);
end
  
% end   
  
