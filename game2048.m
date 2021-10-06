global game_score
global game_over
game_score=0
game_over=0
grid=zeros(4,4)
initial(grid)
while game_over~=1
    %key press part does not work, but the up, left, right and down
    %functions do; game_score is kinda acting weird
    %keypress=waitforbuttonpress
    %key=double(get(gcf,'CurrentCharacter'))
    %u 30, l 28, r 29, d 31
    switch key
        case 30
            grid=up(grid)
        case 28
            grid=left(grid)
        case 29
            grid=right(grid)
        case 31
            grid=down(grid)
    end
end
%%
function [grid]=initial(grid)
    pos_1=randi(16);
    pos_2=randi(16);
    while pos_1==pos_2
        pos_1=randi(16);
        pos_2=randi(16);
    end
    positions=[pos_1 pos_2];
    for x=1:2
    chance=rand();
    if chance<0.9
        grid(positions(x))=2;
    else
        grid(positions(x))=4;
    end
    end
end

function [grid]=new(grid)
    pos=randi(16); % how about pos=randi(15)+1
    while grid(pos)~=0 % Then you cut this entire part
        pos=randi(16);
    end
        chance=rand();
        if chance<0.5
            grid(pos)=2;
        else
            grid(pos)=4;
        end
end

function [grid]=shift(grid)
    empty_mat=zeros(4,4);
    for x=1:4
        non_empty=1;
        for y=1:4
            if grid(x,y)~=0
                empty_mat(x,non_empty)=grid(x,y);
                non_empty=non_empty+1;
            end
        end
    end
    grid=empty_mat;
end

function [grid]=add(grid)
    for x=1:4
        for y=1:3
            if grid(x,y)~=0 && grid(x,y)==grid(x,y+1)
                grid(x,y)=2.*grid(x,y);
                grid(x,y+1)=0;
                global game_score;
                game_score=grid(x,y)+game_score;
            end
        end
    end
end

% We don't have to make a distinct function for each grid shift. It's enough to call the functions transposed
function [grid_left]=left(grid)
    grid_left=shift(add(shift(grid)));
    if grid_left~=grid
        grid_left=new(grid_left);
    end
end

function [grid_down]=down(grid)
    grid_down=transpose(fliplr(shift(add(shift(fliplr(transpose(grid)))))));
    if grid_down~=grid
        grid_down=new(grid_down);
    end
end

function [grid_right]=right(grid)
    grid_right=fliplr(shift(add(shift(fliplr(grid)))));
    if grid_right~=grid
        grid_right=new(grid_right);
    end
end

function [grid_up]=up(grid)
    grid_up=transpose(shift(add(shift(transpose(grid)))));
    if grid_up~=grid
        grid_up=new(grid_up);
    end
end

function [game_over]=game_over_check(grid)
    if isequal(grid,up(grid)) && isequal(grid,down(grid)) && isequal(grid,left(grid)) && isequal(grid,right(grid))
        global game_over
        game_over=1;
    else
        game_over=0;
    end
end
