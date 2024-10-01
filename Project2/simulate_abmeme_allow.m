function [S] = simulate_abmeme_allow(M, T)
%S is 90*90*25 state matrix (which 3 memes each person has for each round)
    S=zeros(90, 90, 25);
    S(:, :, 1)=eye(90);
    for t=2:T
        S(:, :, t)=S(:, :, t-1);
        partner_used=zeros(1,90);
        M_temp=M;
        for i=randperm(90)
            if partner_used(i)==0
                % choose partner
                alpha=rand(1, 90);
                M_alpha = M_temp(i,:).*alpha; % both are 1 by 90 -> return 1 by 90
                [~, Ind] = max(M_alpha);
                % find which memes each person has
                memes_owned_idx_i=find(S(i,:,t-1));
                for x = memes_owned_idx_i
                    if S(i, x, t-1)==2
                        memes_owned_idx_i=[memes_owned_idx_i, x];
                    elseif S(i, x, t-1)==3
                        memes_owned_idx_i=[memes_owned_idx_i, x, x];
                    end
                end
                memes_owned_idx_Ind=find(S(Ind,:,t-1));
                for x = memes_owned_idx_Ind
                    if S(Ind, x, t-1)==2
                        memes_owned_idx_Ind=[memes_owned_idx_Ind, x];
                    elseif S(Ind, x, t-1)==3
                        memes_owned_idx_Ind=[memes_owned_idx_Ind, x, x];
                    end
                end
                % choose which meme to give
                given_meme_i_idx=randi(length(memes_owned_idx_i));
                given_meme_Ind_idx=randi(length(memes_owned_idx_Ind));
                given_meme_i=memes_owned_idx_i(given_meme_i_idx);
                given_meme_Ind=memes_owned_idx_Ind(given_meme_Ind_idx);
                % give
                S(i, given_meme_Ind, t)=S(i, given_meme_Ind, t)+1;
                S(Ind, given_meme_i, t)=S(Ind, given_meme_i, t)+1;
                if length(memes_owned_idx_i)==3
                    % choose which meme to delete
                    deleted_meme_i_idx=randi(length(memes_owned_idx_i));
                    deleted_meme_Ind_idx=randi(length(memes_owned_idx_Ind));
                    deleted_meme_i=memes_owned_idx_i(deleted_meme_i_idx);
                    deleted_meme_Ind=memes_owned_idx_Ind(deleted_meme_Ind_idx);
                    % delete
                    S(i, deleted_meme_i, t)=S(i, deleted_meme_i, t)-1;
                    S(Ind, deleted_meme_Ind, t)=S(Ind, deleted_meme_Ind, t)-1;
                end
                % save used partner
                partner_used(i)=1;
                partner_used(Ind)=1;
                M_temp(i, :)=0;
                M_temp(Ind, :)=0;
                M_temp(:, i)=0;
                M_temp(:, Ind)=0;
            end
        end
    end
