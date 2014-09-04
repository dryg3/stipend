def metod1(sum,x,k,a,b)

string=""


string<< "5 "+(11-x.compact.size).to_s+"\r\n\r\n"

kcp=0
k.each{|s| kcp+=s}
kcp=sum/kcp
p kcp
k.each{|s| string<< s.to_s+" "}
string<<"-> max\r\n"

if x[0].nil?
	string<<"\r\n1 0 0 0 0 >= " << (a[0]*kcp).to_s 
	string<<"\r\n1 0 0 0 0 <= " << (b[0]*kcp).to_s 
else
	string<<"\r\n1 0 0 0 0 = " << x[0].to_s
end

if x[1].nil?
	string<<"\r\n0 1 0 0 0 >= " << (a[1]*kcp).to_s 
	string<<"\r\n0 1 0 0 0 <= " << (b[1]*kcp).to_s 
else
	string<<"\r\n0 1 0 0 0 = " << x[1].to_s
end

if x[2].nil?
	string<<"\r\n0 0 1 0 0 >= " << (a[2]*kcp).to_s 
	string<<"\r\n0 0 1 0 0 <= " << (b[2]*kcp).to_s 
else
	string<<"\r\n0 0 1 0 0 = " << x[2].to_s 
end

if x[3].nil?
	string<<"\r\n0 0 0 1 0 >= " << (a[3]*kcp).to_s 
	string<<"\r\n0 0 0 1 0 <= " << (b[3]*kcp).to_s 
else
	string<<"\r\n0 0 0 1 0 = " << x[3].to_s 
end

if x[4].nil?
	string<<"\r\n0 0 0 0 1 >= " << (a[4]*kcp).to_s
	string<<"\r\n0 0 0 0 1 <= " << (b[4]*kcp).to_s 
else
	string<<"\r\n0 0 0 0 1 = " << x[4].to_s 
end
string<<"\r\n"

k.each{|s| string<< s.to_s+" "}
string<<"<= "+sum.to_s

File.open('simplex_data.txt', 'w'){ |file| file.write string }
system "./a.out"
system "rm simplex_data.txt"
#exec "./a.out | rm simplex_data.txt | ruby 1.rb"

File.open('simplex_out.txt', 'r'){ |file| x=file.read.split}
system "rm simplex_out.txt"
x.map!{|i| i=i.to_i}

return x
end

sum=51330
x=[3000,nil,nil,nil,nil]
k=[4,7,6,0,4]
a=[2,0.5,1,0.5,0.5]
b=[3,1,2,1,1]
otv=metod1(sum,x,k,a,b)

(otv.size!=1) ? (p otv) : (p "Error")
