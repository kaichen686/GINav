function buff=setbitu(buff,pos,len,data)

mask=bitshift(1,len-1);
if len<=0||len>32,return;end

for i=pos:pos+len-1
    if bitand(data,mask)
        tmp=bitshift(1,7-rem(i,8));
        buff=bitor(buff,tmp);
    else
        tmp=bitcmp(bitshift(1,7-rem(i,8)),'uint8');
        buff=bitand(buff,tmp);
    end
    mask=bitshift(mask,-1);
end

return