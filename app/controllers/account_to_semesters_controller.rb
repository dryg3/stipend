class AccountToSemestersController < ApplicationController
  def new
    @account_to_semester = AccountToSemester.new
  end

  def create
    @account_to_semester = AccountToSemester.new(account_to_semester_params)
    @account_to_semester.faculty_id=current_user.faculty.id
    @account_to_semester.semester=sem_today
    @account_to_semester.year=year_today
    if @account_to_semester.save
      redirect_to @account_to_semester
    else
      render 'new'
    end
  end
  
  def show
    @account_to_semester = AccountToSemester.find(params[:id])
  end

  def pay
     @account_to_semester = AccountToSemester.find(params[:faculty_id])
     @pay_category_to_semester= PayCategoryToSemester.new
     @pay_category_to_semester.faculty_id=params[:faculty_id]

     (params[:social].nil? or  params[:social].empty?) ? @pay_category_to_semester.social=0 : @pay_category_to_semester.social=params[:social]
     (params[:five].nil? or  params[:five].empty?) ? @pay_category_to_semester.five=0 : @pay_category_to_semester.five=params[:five]
     (params[:four].nil? or  params[:four].empty?) ? @pay_category_to_semester.four=0 : @pay_category_to_semester.four=params[:four]

     (params[:study].nil? or  params[:study].empty?) ? @pay_category_to_semester.study=0 : @pay_category_to_semester.study=params[:study]
     (params[:public].nil? or  params[:public].empty?) ? @pay_category_to_semester.public=0 : @pay_category_to_semester.public=params[:public]
     (params[:scientific].nil? or  params[:scientific].empty?) ? @pay_category_to_semester.scientific=0 : @pay_category_to_semester.scientific=params[:scientific]
     (params[:cultural].nil? or  params[:cultural].empty?) ? @pay_category_to_semester.cultural=0 : @pay_category_to_semester.cultural=params[:cultural]
     (params[:sports].nil? or  params[:sports].empty?) ? @pay_category_to_semester.sports=0 : @pay_category_to_semester.sports=params[:sports]

     (params[:social1].nil? or  params[:social1].empty?) ? @pay_category_to_semester.social1=0 : @pay_category_to_semester.social1=params[:social1]
     (params[:five1].nil? or  params[:five1].empty?) ? @pay_category_to_semester.five1=0 : @pay_category_to_semester.five1=params[:five1]
     (params[:four1].nil? or  params[:four1].empty?) ? @pay_category_to_semester.four1=0 : @pay_category_to_semester.four1=params[:four1]

     pay_category (@account_to_semester)

     x=[@pay_category_to_semester.five,@pay_category_to_semester.four,@pay_category_to_semester.social]
     k=[@category.five,@category.four,@category.social]
     a=1
     b=2
     c=[1340,2010,6307]
     sum=100000
     otv=metod2(sum,x,k,a,b,c)
     @pay_category_to_semester.five=otv[0]
     @pay_category_to_semester.four=otv[1]
     @pay_category_to_semester.social=otv[2]
        #metod(sum_soc,sum_hor,sum_otl)

     x=[@pay_category_to_semester.five1,@pay_category_to_semester.four1,@pay_category_to_semester.social1]
     k=[@category.five1,@category.four1,@category.social1]
     a=1
     b=2
     c=[1340,2010,6307]
     sum=300000
     otv=metod2(sum,x,k,a,b,c)
     @pay_category_to_semester.five1=otv[0]
     @pay_category_to_semester.four1=otv[1]
     @pay_category_to_semester.social1=otv[2]

     sum=51330
     x=[@pay_category_to_semester.study,@pay_category_to_semester.public,@pay_category_to_semester.scientific,@pay_category_to_semester.cultural,@pay_category_to_semester.sports]
     k=[@category.study,@category.public,@category.scientific,@category.cultural,@category.sports]
     a=[1,1,1,1,1]
     b=[2,2,2,2,2]
     otv=metod1(sum,x,k,a,b)
     @pay_category_to_semester.study=otv[0]
     @pay_category_to_semester.public=otv[1]
     @pay_category_to_semester.scientific=otv[2]
     @pay_category_to_semester.cultural=otv[3]
     @pay_category_to_semester.sports=otv[4]

  end

  def index
    @account_to_semesters = AccountToSemester.where("year LIKE '%#{year_today}%'")
    @account_to_semesters = AccountToSemester.where("year LIKE '%#{params[:years].to_s}%'") unless params[:years].nil? or params[:years].empty?
    if  current_user.faculty.name == "all"
      ac= AccountToSemester.all
    else
      ac=AccountToSemester.where("faculty_id = '#{current_user.faculty_id}'")
    end
    @account_to_semesters&=ac

  end
  # def index
  #   @account_to_semesters = AccountToSemester.all
  #
  # end

  def edit
    @account_to_semester = AccountToSemester.find(params[:id])
  end
  
  def update
    @account_to_semester = AccountToSemester.find(params[:id])
    @account_to_semester.semester=sem_today
    @account_to_semester.year=year_today
    if @account_to_semester.update(account_to_semester_params)
      redirect_to @account_to_semester
    else
      render 'edit'
    end
  end
  
  def destroy
    @account_to_semester = AccountToSemester.find(params[:id])
    @account_to_semester.destroy
   
    redirect_to account_to_semesters_path
  end

private
  def account_to_semester_params
    params.require(:account_to_semester).permit(:type_account, :sum,:faculty_id, :year, :semester)
  end
  def pay_category_to_semester_params
    params.require(:pay_category_to_semester).permit( :date_start,:date_finish,:social,:five,:four,:study,:public,:scientific,:cultural,:sports,:social1,:five1,:four1,:faculty_id)
  end

  def pay_category(account)
    sem=account.semester
    year=account.year
    f_id=account.faculty_id#fpmtf

    sum=0
    sum_soc=0
    sum_hor=0
    sum_otl=0

    @category = PayCategoryToSemester.new
    @category.faculty_id=f_id
    @category.social=0
    @category.five=0
    @category.four=0
    @category.study=0
    @category.public=0
    @category.scientific=0
    @category.cultural=0
    @category.sports=0
    @category.social1=0
    @category.five1=0
    @category.four1=0
      if(sem==1)
        g = Group.find(:all,:conditions => ['(kurs = ? AND semester = ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
        g.each  do |c|

          s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
          sum+=s.size

          s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true])
          s.each do |s|
            s.refund=true
            #s.save!
          end
          sum_soc+=s.size

          s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2])
          s.each do |s|
            s.refund=true
            #s.save!
          end
          sum_otl+=s.size


          s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1])
          s.each do |s|
            s.refund=true
            #s.save!
          end
          sum_hor+=s.size
        end


        @category.social1=sum_soc
        @category.five1=sum_otl
        @category.four1=sum_hor


      end

      sum=0
      sum_soc=0
      sum_hor=0
      sum_otl=0
      sum_1=0
      sum_2=0
      sum_3=0
      sum_4=0
      sum_5=0

      g = Group.find(:all,:conditions => ['(kurs != ? OR semester != ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
      g.each  do |c|
        s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
        sum+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_soc+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_otl+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_hor+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND study=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_1+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND public=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_2+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND scientific=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_3+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND cultural=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_4+=s.size

        s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND sports=?',c.id,false,true])
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_5+=s.size

      end
#metod(sum_soc,sum_hor,sum_otl)
    @category.social=sum_soc
    @category.five=sum_otl
    @category.four=sum_hor

#metod(sum_soc,sum_hor,sum_otl)

    @category.study=sum_1
    @category.public=sum_2
    @category.scientific=sum_3
    @category.cultural=sum_4
    @category.sports=sum_5

#@pay_category_to_semester.save!
    end

    def metod1(sum,x,k,a,b)

      string=""
      string<< "5 "+(11-(x-[0]).size).to_s+"\r\n\r\n"

      kcp=0
      k.each{|s| kcp+=s}
      kcp=sum/kcp

      k.each{|s| string<< s.to_s+" "}
      string<<"-> max\r\n"

      if x[0]==0
        string<<"\r\n1 0 0 0 0 >= " << (a[0]*kcp).to_s
        string<<"\r\n1 0 0 0 0 <= " << (b[0]*kcp).to_s
      else
        string<<"\r\n1 0 0 0 0 = " << x[0].to_s
      end

      if x[1]==0
        string<<"\r\n0 1 0 0 0 >= " << (a[1]*kcp).to_s
        string<<"\r\n0 1 0 0 0 <= " << (b[1]*kcp).to_s
      else
        string<<"\r\n0 1 0 0 0 = " << x[1].to_s
      end

      if x[2]==0
        string<<"\r\n0 0 1 0 0 >= " << (a[2]*kcp).to_s
        string<<"\r\n0 0 1 0 0 <= " << (b[2]*kcp).to_s
      else
        string<<"\r\n0 0 1 0 0 = " << x[2].to_s
      end

      if x[3]==0
        string<<"\r\n0 0 0 1 0 >= " << (a[3]*kcp).to_s
        string<<"\r\n0 0 0 1 0 <= " << (b[3]*kcp).to_s
      else
        string<<"\r\n0 0 0 1 0 = " << x[3].to_s
      end

      if x[4]==0
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
     # system "rm simplex_data.txt"


      File.open('simplex_out.txt', 'r'){ |file| x=file.read.split}
    #  system "rm simplex_out.txt"
      x.map!{|i| i=i.to_i}

      return x
    end

  def metod2(sum,x,k,a,b,c)

    string=""
    string<< "3 "+(6+x.compact.size).to_s+"\r\n\r\n"

    k.each{|s| string<< s.to_s+" "}
    string<<"-> max\r\n"

    string<<"\r\n1 " << (-a).to_s << " 0 >= 0"
    string<<"\r\n1 " << (-b).to_s << " 0 <= 0"

    (x[0]==0) ? string<<"\r\n0 1 0 >= " << c[0].to_s : string<<"\r\n0 1 0 = " << x[0].to_s

    string<<"\r\n0 1 = " << x[1].to_s if x[1]!=0
    (x[2]==0) ? string<<"\r\n0 0 1 >= " << c[1].to_s : string<<"\r\n0 0 1 = " << x[2].to_s
    string<<"\r\n0 1 1 >= " << c[2].to_s #if (x[2].nil?)
    string<<"\r\n"

    k.each{|s| string<< s.to_s+" "}
    string<<"<= "+sum.to_s

    File.open('simplex_data.txt', 'w'){ |file| file.write string }
    system "./a.out"
#system "rm simplex_data.txt"


    File.open('simplex_out.txt', 'r'){ |file| x=file.read.split}
#   system "rm simplex_out.txt"
    x.map!{|i| i=i.to_i}

    return x
  end

=begin
    @pay_category_to_semester =PayCategoryToSemester.new
    @pay_category_to_semester.faculty_id=f_id
    @pay_category_to_semester.social=0
    @pay_category_to_semester.five=0
    @pay_category_to_semester.four=0
    @pay_category_to_semester.study=0
    @pay_category_to_semester.public=0
    @pay_category_to_semester.scientific=0
    @pay_category_to_semester.cultural=0
    @pay_category_to_semester.sports=0
    @pay_category_to_semester.social1=0
    @pay_category_to_semester.five1=0
    @pay_category_to_semester.four1=0
  sum=972774+40200
  x=[nil,nil,2010]
  k=[74,142,20]
  a=1
  b=2
  c=[1340,2010,6307]
  otv=metod2(sum,x,k,a,b,c)

  (otv.size!=1) ? (p otv) : (p "Error")

  x=[nil,nil,nil]
  k=[sum_otl,sum_hor,sum_soc]
  a=1
  b=2
  c=[1340,2010,6307]
         otv=metod2(summa,x,k,a,b,c)
        #metod(sum_soc,sum_hor,sum_otl)
=end

end
