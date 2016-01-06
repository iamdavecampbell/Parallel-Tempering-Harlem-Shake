function [newpoint chains_swap, MHaccepts]= mog_mh_PT(mixes, currentpoint, cur_cov,proposal_cov,temp,MHaccepts,iter);

% [PTsamples(m,:) chains_swap{m}(iter,:), MHaccepts(m,:)]= mog_mh_PT(mixes{m}, PTsamples(m,:), cur_cov,proposal_cov,temp,MHaccepts(m,:),iter);        
% mixes = mixes{m}
% currentpoint = PTsamples(m,:),MHaccepts=MHaccepts(m,:)

newpoint = currentpoint;

% Propose to swap between chains.
chain1 = ceil(rand*(length(temp)));
chain2 = ceil(rand*(length(temp)));
chains_swap=[sort([chain1,chain2]),0];

if chains_swap(1)==chains_swap(2)  || max(chains_swap)>length(temp)
    chains_swap=[0,0,0];
end

if max(chains_swap)>0
    %We are proposing a swap move
    prop_temp = mix_gaussians_tempered_log_pdf( currentpoint{chains_swap(1)}(iter,:), mixes ,temp(chains_swap(2)))+...
                mix_gaussians_tempered_log_pdf( currentpoint{chains_swap(2)}(iter,:), mixes ,temp(chains_swap(1)));
    
    last_temp = mix_gaussians_tempered_log_pdf( currentpoint{chains_swap(1)}(iter,:), mixes ,temp(chains_swap(1)))+...
                mix_gaussians_tempered_log_pdf( currentpoint{chains_swap(2)}(iter,:), mixes ,temp(chains_swap(2)));
    
    % do the acceptance step
    % note that if rand < ratio then we don't need to do anything but alter
    % the chains_swap to highlight the swap acceptance
    if rand< exp(prop_temp - last_temp)
        % swap 8^)
        
        newpoint{chains_swap(1)}(iter+1,:) = currentpoint{chains_swap(2)}(iter,:);
        newpoint{chains_swap(2)}(iter+1,:) = currentpoint{chains_swap(1)}(iter,:);
        chains_swap(end) = 1;
    else
        % no swap 8^(
        newpoint{chains_swap(1)}(iter+1,:) = currentpoint{chains_swap(1)}(iter,:);
        newpoint{chains_swap(2)}(iter+1,:) = currentpoint{chains_swap(2)}(iter,:);

        
    end
end


for kk=1:(length(temp))
    if kk~=chains_swap(1) && kk~=chains_swap(2)
        [newpoint{kk}(iter+1,:) MHaccepts(kk)] = tempered_mog_mh( mixes, currentpoint{kk}(iter,:), proposal_cov{kk} ,temp(kk),MHaccepts(kk));
    end
end
