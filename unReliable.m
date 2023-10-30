function unreliable = unReliable(disparityMap,immid)
unreliable=false(size(disparityMap));
for a=1:length(disparityMap(:,1))
  for b=1:length(disparityMap)
      if isnan(disparityMap(a,b))|| immid(a,b)==0
         unreliable(a,b)=1;
      else
         unreliable(a,b)=0; 
      end 
  end
end