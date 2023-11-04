function [] = createMesh(Merge,resample)
    
    % create the mesh
    Location=double(Merge.Location);
    indice=1:resample:length(Location);
    x=Location(indice,1);
    y=Location(indice,2);
    z=Location(indice,3);
    tri = delaunay(x,y);

    % calculating the edge
    X=x(tri);
    Y=y(tri);
    a=zeros(size(X));
    for cnt=1:3
    a(:,cnt)=abs(diff(angle(bsxfun(@minus,X(:,[1:cnt-1 cnt+1:end]),X(:,cnt))+1i*bsxfun(@minus,Y(:,[1:cnt-1 cnt+1:end]),Y(:,cnt))),[],2));
    end
    
    % color 
    redChannel   = Merge.Color(indice,1);
    greenChannel = Merge.Color(indice,2);
    blueChannel  = Merge.Color(indice,3);
    
    %Visualizing
    figure;
    TM = trisurf(tri, x, y, z);
    set(TM, 'FaceVertexCData', [redChannel, greenChannel, blueChannel]);
    set(TM, 'FaceColor', 'interp');
    set(TM, 'EdgeColor', 'none');
    daspect([1,1,1])
    grid off
    title("point cloud");

end