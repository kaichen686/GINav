function bits=getbitu(buff,pos,len)

bits=0;

for i=pos:pos+len-1
    tmp1=bitshift(bits,1);
    tmp2=bitand(bitshift(buff,-(7-rem(i,8))),1);
    bits=tmp1+tmp2;
end

return