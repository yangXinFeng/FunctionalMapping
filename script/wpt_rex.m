function rex = wpt_rex(data,wavelet_level,wavelet_name)
    wpt=wpdec(data,wavelet_level,wavelet_name);
    %level>=3 3:2^(8-3)=32hz  4:16hz  5:8hz  6:4hz
    %7:[2 4]_2;  6:[4 8]_2;  6:[8 12]_3 + 7:[12 14]_7; 4:[16 32]_2+7:[14 16]_8;   4:[32 48] 3  3:[64 96] 3
    level=7;
    nodes=2*(2^(level-1)-1)+1:2*(2^level-1);
    ord=wpfrqord(nodes');  %小波包系数重排，ord是重排后小波包系数索引构成的矩阵　如3层分解的[1;2;4;3;7;8;6;5]
    nodes_ord=nodes(ord); %重排后的小波系数
    rex_delta=wprcoef(wpt,nodes_ord(2));
    rex_14=wprcoef(wpt,nodes_ord(7));
    rex_16=wprcoef(wpt,nodes_ord(8));

    level=6;
    nodes=2*(2^(level-1)-1)+1:2*(2^level-1);
    ord=wpfrqord(nodes');  %小波包系数重排，ord是重排后小波包系数索引构成的矩阵　如3层分解的[1;2;4;3;7;8;6;5]
    nodes_ord=nodes(ord); %重排后的小波系数
    rex_theta=wprcoef(wpt,nodes_ord(2));
    rex_alpha=wprcoef(wpt,nodes_ord(3))+rex_14; 

    level=4;
    nodes=2*(2^(level-1)-1)+1:2*(2^level-1);
    ord=wpfrqord(nodes');  %小波包系数重排，ord是重排后小波包系数索引构成的矩阵　如3层分解的[1;2;4;3;7;8;6;5]
    nodes_ord=nodes(ord); %重排后的小波系数
    rex_beta=wprcoef(wpt,nodes_ord(2))+rex_16; 
    rex_low_gama=wprcoef(wpt,nodes_ord(3)); 

    level=3;
    nodes=2*(2^(level-1)-1)+1:2*(2^level-1);
    ord=wpfrqord(nodes');  %小波包系数重排，ord是重排后小波包系数索引构成的矩阵　如3层分解的[1;2;4;3;7;8;6;5]
    nodes_ord=nodes(ord); %重排后的小波系数
    cfs_high_gama=wpcoef(wpt,nodes_ord(3));
    rex_high_gama=wprcoef(wpt,nodes_ord(3)); 

    %       cfs=[cfs_theta;cfs_alpha;cfs_beta;cfs_low_gama;cfs_high_gama];
    rex=[rex_delta;rex_theta;rex_alpha;rex_beta;rex_low_gama;rex_high_gama];
