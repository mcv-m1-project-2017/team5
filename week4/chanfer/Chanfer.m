function [BB] = Chanfer(image)
    % Parameters
    templ_dir = 'mask_templ';
    maxsize=184;
    minsize=40;
    
    templ_files = ListFiles(templ_dir);
    
    % Generate the DT
    edgeim=edge(image,'canny');
    [rim,cim]=size(image);
    expanded_im = zeros(rim+maxsize,cim+maxsize);
    expanded_im(maxsize/2:end-(maxsize/2)-1,maxsize/2:end-(maxsize/2)-1)=edgeim;
    dt=bwdist(expanded_im);
    
    BB=[];
    for tf = 1:length(templ_files)
        % Read the mask template
        template = imread(strcat(templ_dir,filesep,templ_files(tf).name))>0;
        [r,c]=size(template);
        
        % Try with different sizes
        for templ_size=round(linspace(maxsize,minsize,5))
            templ_size2=round((templ_size/r)*c);
            
            % Generate the border resized template
            templ_resized=zeros(templ_size+2,templ_size2+2);
            templ_resized(2:end-1,2:end-1)=imresize(template,[templ_size templ_size2]);
            curtemplate = edge(templ_resized,'canny');
            curtemplate = curtemplate/sum(curtemplate(:));
            
            % Convolve
            aux = imfilter(dt,curtemplate);
            
            % Find the minimum
            aux = aux(maxsize/2:end-(maxsize/2)-1,maxsize/2:end-(maxsize/2)-1);
            [mind,i]=min(aux);
            [mind,j]=min(mind);
            i=i(j);
            if mind<10
                BB=[BB; struct('y',round(i-templ_size/2),...
                    'x',round(j-(templ_size/r)*c/2),...
                    'w',round((templ_size/r)*c),'h',templ_size)];
            end
        end
    end
    
    % Unify windows related to the same object
    selector = true(length(BB),1);
    for b=1:length(BB)
        for j=b+1:length(BB)
            if BB(b).h > BB(j).h
                h=BB(b).h;
                w=BB(b).w;
            else
                h=BB(j).h;
                w=BB(j).w;
            end
            if BB(j).x <= BB(b).x+h && BB(j).x >= BB(b).x-h...
                    && BB(j).y <= BB(b).y+w && BB(j).y >= BB(b).y-w
                if BB(b).w > BB(j).w
                    selector(j)=false;
                else
                    selector(b)=false;
                end
            end
        end
    end
    BB=BB(selector);
end

