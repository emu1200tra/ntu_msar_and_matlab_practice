function [ result ] = QM2( vari_num , m , d )
    inputstring = char([]);
    result = char([]);
    sign = 0;
    for i=0:2^vari_num-1
       for j=1:size(m,2)
           if m(j) == i
               inputstring(end+1) = '1';
               sign = 1;
           end
       end
       for j = 1 : size(d , 2)
           if d(j) == i
               inputstring(end+1) = '-';
               sign = 1;
           end
       end
       if sign == 0
            inputstring(end+1) = '0';
       else
           sign = 0;
       end
    end
   
    [Bins] = minTruthtable(inputstring);
    
    for i=1:size(Bins,1)
        for j=1:size(Bins,2)
            if Bins(i,j) == '0'
                result(end+1) = 'A'+ j - 1;
                result(end+1) = '"';
            elseif Bins(i,j) == '1'
                result(end+1) = 'A'+ j - 1;
            end
        end
        if i ~= size(Bins,1)
            result(end+1) = '+';
        end
    end
end

function [Bins] = minTruthtable(tt)
      if size(tt,2) == 1
          tt = tt'; 
      end
      N = round(log2(size(tt,2)));
      Ons = find(tt=='1'); 
      Dcs = find(tt=='-');
      nOn = length(Ons);
      nDc = length(Dcs);
      Bins1 = [dec2bin(Ons-1,N); dec2bin(Dcs-1,N)]; 
      Covs1 = [false(nOn,1); true(nDc,1)];      
      Nums1 = [Ons'-1; Dcs'-1];                 
      nVars1 = size(Bins1,1);
      twoexp = 2.^(N-1:-1:0)';                 
      MINC = 100; 
      BinsNew = char('X'*ones(MINC,N));         
      Bins2 = BinsNew;
      Covs2 = false(MINC,1);
      Nums2 = int16(-ones(MINC,1));
      Bins3 = BinsNew;
      Nums3 = cell(MINC,1);
      nVars3 = 0;
      for n=1:N 
        if ~nVars1
            break;
        end
        six = [find(~Covs1); find(Covs1)]; 
        Bins1 = Bins1(six,:);
        Covs1 = Covs1(six,:);
        Nums1 = Nums1(six,:);
        Dons1 = int16((Bins1 == '-')*twoexp);  
        Ones1 = uint16((Bins1 == '1')*twoexp);
        Nums2 = [Nums2,Nums2]; 
        nVars2 = 0;
        for ix0 = 1:nVars1-1
          Dons10 = Dons1(ix0);
          if Dons10 < 0
              continue;
          end
          Bins10 = Bins1(ix0,:);
          Covs10 = Covs1(ix0);
          Nums10 = Nums1(ix0,:);
          Ones10 = Ones1(ix0);
          for ix1 = ix0+1:nVars1
            if Dons10 ~= Dons1(ix1)
                continue; 
            end 
            tmp = bitxor(Ones10,Ones1(ix1)); 
            if tmp > 0 && bitand(tmp, tmp-1) > 0
                continue; 
            end 
            diffs = find(Bins10 ~= Bins1(ix1,:), 1); 
            if ~isempty(diffs) 
              nVars2 = nVars2 + 1;
              if length(Covs2) < nVars2 
                Bins2 = [Bins2; BinsNew];
                Covs2 = [Covs2; false(MINC,1)];
                Nums2 = [Nums2; -ones(MINC,2^n)];
              end
              Bins2(nVars2,:) = Bins10;
              Bins2(nVars2,diffs) = '-';
              Covs2(nVars2) = false;
              Nums2(nVars2,:) = [Nums10 Nums1(ix1,:)];
              Covs1([ix0 ix1]) = true;
              Covs10 = true;
            else 
              Dons1(ix1) = -1;    
              if ~Covs10
                  Covs1(ix1) = true; 
              end 
            end
          end
        end
        ixUC1 = find(~Covs1); 
        if ~isempty(ixUC1)
          ixUCRng3 = nVars3 + (1:length(ixUC1)); 
          nVars3 = ixUCRng3(end);
          Bins3(ixUCRng3,:) = Bins1(ixUC1,:);
          Nums3(ixUCRng3) = num2cell(Nums1(ixUC1,:),2); 
        end
        Bins1 = Bins2(1:nVars2,:);
        Covs1 = Covs2(1:nVars2);
        Nums1 = Nums2(1:nVars2,:);
        nVars1 = nVars2;
      end
      if nVars1 > 0 
        ixUCRng3 = nVars3 + (1:nVars1); 
        nVars3 = ixUCRng3(end);
        Bins3(ixUCRng3,:) = Bins1;
        Nums3(ixUCRng3) = num2cell(Nums1,2); 
      end
      A = false(nVars3,2^N);   
      for i = 1:nVars3          
        A(i,Nums3{i}+1) = true; 
      end                       
      vcnt = sum(A,1);          
      ttEq1 = tt=='1';        
      A = A(:,ttEq1);         
      vcnt = vcnt(:,ttEq1);   
      vars3 = (1:nVars3)'; 
      vars4 = zeros(0,1);  
      vcntEq1 = find(vcnt==1);
      for c = vcntEq1(end:-1:1)
        if vcnt(c) == 1
          r = find(A(vars3,c),1);
          vcnt(A(vars3(r),:)) = 0;        
          vars4 = [vars4; vars3(r)];      
          vars3 = vars3([1:r-1,r+1:end]); 
        end
      end
      cntDC = sum(Bins3(1:nVars3,:) == '-',2); 
      while any(vcnt > 0)
        A = A(:,vcnt > 0);
        vcnt = vcnt(vcnt > 0);
        hcnt = sum(A(vars3,:),2);       
        vars3 = vars3(hcnt > 0);        
        hcnt = hcnt(hcnt > 0);          
        cntDC2 = cntDC(vars3);          
        [~,r] = max(hcnt*N+cntDC2);    
        vcnt(A(vars3(r),:)) = 0;        
        vars4 = [vars4; vars3(r)];      
        vars3 = vars3([1:r-1,r+1:end]); 
      end
      vars4 = sort(vars4);
      Bins = Bins3(vars4,:);
end





