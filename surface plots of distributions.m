x=-2:.2:2
y=-2:.2:2

surfac = cell(9,1)
surfac (:) = {zeros(length(x),length(y))};
for tlp = 1:length(temp)
    figure(tlp)
    for m=1:9
        for lp=1:length(x)
            for kp = 1:length(y)
                surfac{m}(lp,kp) = mix_gaussians_tempered_log_pdf( [x(lp),y(kp)], mixes{m} ,temp(tlp));
            end
        end
        subplot(3,3,m)
        contour(x,y,surfac{m}')    
    end
end


%%
jj=1;figure(jj);subplot(3,3,m);hold on;plot(PTsamples{m,jj}(:,1),PTsamples{m,jj}(:,2),'*');