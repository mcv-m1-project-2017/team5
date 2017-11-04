function [BB] = Chanfer(image)
    templ_dir = 'mask_templ';
    maxsize=220;
    minsize=40;
    templ_files = ListFiles(templ_dir);
    edgeim=edge(image,'canny');
    [rim,cim]=size(image);
    expanded_im = zeros(rim+maxsize,cim+maxsize);
    expanded_im(maxsize/2:end-(maxsize/2)-1,maxsize/2:end-(maxsize/2)-1)=edgeim;
    dt=bwdist(expanded_im);
    BB=[];
    for tf = 1:length(templ_files)
        template = imread(strcat(templ_dir,filesep,templ_files(tf).name))>0;
        [r,c]=size(template);
        
        for templ_size=round(linspace(maxsize,minsize,6))
            templ_size2=round((templ_size/r)*c);
            templ_resized=zeros(templ_size+2,templ_size2+2);
            templ_resized(2:end-1,2:end-1)=imresize(template,[templ_size templ_size2]);
            curtemplate = edge(templ_resized,'canny');
            curtemplate = curtemplate/sum(curtemplate(:));
            
            aux = imfilter(dt,curtemplate);
            aux = aux(maxsize/2:end-(maxsize/2)-1,maxsize/2:end-(maxsize/2)-1);
            [mind,i]=min(aux);
            [mind,j]=min(mind);
            i=i(j);
            if mind<3
                BB=[BB; struct('y',round(i-templ_size/2),...
                    'x',round(j-(templ_size/r)*c/2),...
                    'w',round((templ_size/r)*c),'h',templ_size)];
            end
        end
    end
end

