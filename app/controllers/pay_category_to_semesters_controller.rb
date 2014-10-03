class PayCategoryToSemestersController < ApplicationController
  def kalkul
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where("commerce = ? AND groups.semester = ? AND groups.faculty_id = ? AND groups.year = ? AND account_to_semesters.type_account = ?",false,sem_today, params[:faculty_id], year_today,1).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.study=@s_g_all.find_all{|x| x.study}.size
    @category.public=@s_g_all.find_all{|x| x.public}.size
    @category.scientific=@s_g_all.find_all{|x| x.scientific}.size
    @category.cultural=@s_g_all.find_all{|x| x.cultural}.size
    @category.sports=@s_g_all.find_all{|x| x.sports}.size
    @sum[1]=@s_g_all.find_all{|x| x.study or x.public or x.scientific or x.cultural or x.sports}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    # [sum account,size, default, sum_end]
    @sum[3]=0
    @sum[3]+= @category.study* params[:study].to_i unless params[:study].nil? or params[:study].empty?
    @sum[3]+= @category.public* params[:public].to_i unless params[:public].nil? or params[:public].empty?
    @sum[3]+= @category.scientific* params[:scientific].to_i unless params[:scientific].nil? or params[:scientific].empty?
    @sum[3]+= @category.cultural* params[:cultural].to_i unless params[:cultural].nil? or params[:cultural].empty?
    @sum[3]+= @category.sports* params[:sports].to_i unless params[:sports].nil? or params[:sports].empty?
  end

  def stip1
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where('commerce = ? AND (groups.kurs = ? AND groups.semester = ?) AND groups.semester = ? AND groups.faculty_id= ? AND groups.year=? AND account_to_semesters.type_account = ?',false,1,1,sem_today, params[:faculty_id], year_today,0).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.social=@s_g_all.find_all{|x| x.social}.size
    @category.five=@s_g_all.find_all{|x| x.type_stipend == 2}.size
    @category.four=@s_g_all.find_all{|x| x.type_stipend == 1}.size
    @sum[1]=@s_g_all.find_all{|x| x.social or x.type_stipend == 2 or x.type_stipend == 1}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    @sum[3]=0
    @sum[3]+=@category.social* params[:social1].to_i unless params[:social1].nil? or params[:social1].empty?
    @sum[3]+=@category.five* params[:five1].to_i unless params[:five1].nil? or params[:five1].empty?
    @sum[3]+=@category.four* params[:four1].to_i unless params[:four1].nil? or params[:four1].empty?
  end

  def stip2
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where('commerce = ? AND (groups.kurs != ? OR groups.semester != ?) AND groups.semester = ? AND groups.faculty_id= ? AND groups.year=? AND account_to_semesters.type_account = ?',false,1,1,sem_today, params[:faculty_id], year_today,2).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.social=@s_g_all.find_all{|x| x.social}.size
    @category.five=@s_g_all.find_all{|x| x.type_stipend == 2}.size
    @category.four=@s_g_all.find_all{|x| x.type_stipend == 1}.size
    @socfive=[@s_g_all.find_all{|x| x.type_stipend == 2 and x.social and (x.group.kurs == 1 or x.group.kurs == 2)}.size]
    @socfour=[@s_g_all.find_all{|x| x.type_stipend == 1 and x.social and (x.group.kurs == 1 or x.group.kurs == 2)}.size]
    @sum[1]=@s_g_all.find_all{|x| x.social or x.type_stipend == 2 or x.type_stipend == 1}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    @socfive[1]=0 if (@socfive[1]=6307-params[:social].to_i-params[:five].to_i)<0
    @socfour[1]=0 if (@socfour[1]=6307-params[:social].to_i-params[:four].to_i)<0
    @sum[3]=0
    @sum[3]+=@category.social* params[:social1].to_i unless params[:social1].nil? or params[:social1].empty?
    @sum[3]+=@category.five* params[:five1].to_i unless params[:five1].nil? or params[:five1].empty?
    @sum[3]+=@category.four* params[:four1].to_i unless params[:four1].nil? or params[:four1].empty?
    @sum[3]+=@socfive[0]*@socfive[1]
    @sum[3]+=@socfour[0]*@socfour[1]
  end

  def new2
    @account_to_semester = AccountToSemester.find(:all, :conditions => ['faculty_id = ? AND year = ? AND semester = ? ', params[:faculty_id],year_today,sem_today])[0]
    @sum1=AccountToSemester.find(:all, :conditions => ['faculty_id = ? AND type_account = ? AND year = ? AND semester = ?', params[:faculty_id],2,year_today,sem_today])[0]
    @sum2=AccountToSemester.find(:all, :conditions => ['faculty_id = ? AND type_account = ? AND year = ? AND semester = ?', params[:faculty_id],0,year_today,sem_today])[0]
    @sum3=AccountToSemester.find(:all, :conditions => ['faculty_id = ? AND type_account = ? AND year = ? AND semester = ?', params[:faculty_id],1,year_today,sem_today])[0]
    @pay_category_to_semester= PayCategoryToSemester.new
    @pay_category_to_semester.faculty_id=params[:faculty_id]

    (params[:social].nil? or params[:social].empty?) ? @pay_category_to_semester.social=0 : @pay_category_to_semester.social=params[:social]
    (params[:five].nil? or params[:five].empty?) ? @pay_category_to_semester.five=0 : @pay_category_to_semester.five=params[:five]
    (params[:four].nil? or params[:four].empty?) ? @pay_category_to_semester.four=0 : @pay_category_to_semester.four=params[:four]

    (params[:study].nil? or params[:study].empty?) ? @pay_category_to_semester.study=0 : @pay_category_to_semester.study=params[:study]
    (params[:public].nil? or params[:public].empty?) ? @pay_category_to_semester.public=0 : @pay_category_to_semester.public=params[:public]
    (params[:scientific].nil? or params[:scientific].empty?) ? @pay_category_to_semester.scientific=0 : @pay_category_to_semester.scientific=params[:scientific]
    (params[:cultural].nil? or params[:cultural].empty?) ? @pay_category_to_semester.cultural=0 : @pay_category_to_semester.cultural=params[:cultural]
    (params[:sports].nil? or params[:sports].empty?) ? @pay_category_to_semester.sports=0 : @pay_category_to_semester.sports=params[:sports]

    (params[:social1].nil? or params[:social1].empty?) ? @pay_category_to_semester.social1=0 : @pay_category_to_semester.social1=params[:social1]
    (params[:five1].nil? or params[:five1].empty?) ? @pay_category_to_semester.five1=0 : @pay_category_to_semester.five1=params[:five1]
    (params[:four1].nil? or params[:four1].empty?) ? @pay_category_to_semester.four1=0 : @pay_category_to_semester.four1=params[:four1]

    pay_category (@account_to_semester)

    x=[@pay_category_to_semester.five, @pay_category_to_semester.four, @pay_category_to_semester.social]
    k=[@category.five, @category.four, @category.social]
    a=params[:a].to_f
    b=params[:b].to_f
    c=[1340, 2010, 6307]
    otv=metod2(@sum1.sum, x, k, a, b, c)

    p otv
    @pay_category_to_semester.five=otv[0] unless otv[0].nil?
    @pay_category_to_semester.four=otv[1] unless otv[1].nil?
    @pay_category_to_semester.social=otv[2] unless otv[2].nil?
    #metod(sum_soc,sum_hor,sum_otl)



    x=[@pay_category_to_semester.five1, @pay_category_to_semester.four1, @pay_category_to_semester.social1]
    k=[@category.five1, @category.four1, @category.social1]
    a=params[:a1].to_f
    b=params[:b1].to_f
    c=[1340, 2010, 6307]

    if x.uniq==[0]
      otv=x
    else
      otv=metod2(@sum2.sum, x, k, a, b, c)
    end
    @pay_category_to_semester.five1=otv[0] unless otv[0].nil?
    @pay_category_to_semester.four1=otv[1] unless otv[1].nil?
    @pay_category_to_semester.social1=otv[2] unless otv[2].nil?

    #sum=51330
    x=[@pay_category_to_semester.study, @pay_category_to_semester.public, @pay_category_to_semester.scientific, @pay_category_to_semester.cultural, @pay_category_to_semester.sports]
    k=[@category.study, @category.public, @category.scientific, @category.cultural, @category.sports]
    a=[params[:aq0].to_f, params[:aq1].to_f, params[:aq2].to_f, params[:aq3].to_f, params[:aq4].to_f]
    b=[params[:bq0].to_f, params[:bq1].to_f, params[:bq2].to_f, params[:bq3].to_f, params[:bq4].to_f]
    if params[:simplex].nil? or params[:simplex].empty?
      otv=metod1(@sum3.sum, x, k, a, b)
    else
      otv=x
      @summa=0
      for i in 0...x.size
        @summa+=k[i]*x[i]
      end
    end
    @pay_category_to_semester.study=otv[0] unless otv[0].nil?
    @pay_category_to_semester.public=otv[1] unless otv[1].nil?
    @pay_category_to_semester.scientific=otv[2] unless otv[2].nil?
    @pay_category_to_semester.cultural=otv[3] unless otv[3].nil?
    @pay_category_to_semester.sports=otv[4]  unless otv[4].nil?


    @pay_category_to_semester.date_start= params[:date_start]
    @pay_category_to_semester.date_finish= params[:date_finish]

  end

  def new1
    @pay_category_to_semester = PayCategoryToSemester.new
  end
  def new
    @pay_category_to_semester = PayCategoryToSemester.new
  end

  def create
    @pay_category_to_semester = PayCategoryToSemester.new(pay_category_to_semester_params)
   p @pay_category_to_semester
    if @pay_category_to_semester.save
      redirect_to @pay_category_to_semester
    else
      render 'new1'
      # render :controller => 'pay_category_to_semesters', :action => 'new',:faculty_id => params[:pay_category_to_semester][:faculty_id],:step => 1
      # render inline: "<% params.each do |p| %><p><%= params[:pay_category_to_semester][:faculty_id] %></p><% end %>"
      # render :action => "new",:locals => { :faculty_id => params[:pay_category_to_semester][:faculty_id],:step => 1}
      #redirect_to :controller => 'pay_category_to_semesters', :action => 'new',:params => params[:pay_category_to_semester],:step => 1
    end
    #redirect_to @pay_category_to_semester
  end

  def show
    @pay_category_to_semester = PayCategoryToSemester.find(params[:id])
  end

  def index
    if current_user.faculty.name== "all"
      @pay_category_to_semesters =PayCategoryToSemester.all
    else
      @pay_category_to_semesters = PayCategoryToSemester.where("faculty_id = '#{current_user.faculty_id}'")
    end
  end

  def update
    @pay_category_to_semester = PayCategoryToSemester.find(params[:id])

    if @pay_category_to_semester.update(pay_category_to_semester_params)
      redirect_to @pay_category_to_semester
    else
      render 'edit'
    end
  end

  def destroy
    @pay_category_to_semester = PayCategoryToSemester.find(params[:id])
    @pay_category_to_semester.destroy

    redirect_to pay_category_to_semesters_path
  end
  def edit
    @pay_category_to_semester = PayCategoryToSemester.find(params[:id])
  end



  private
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
      g = Group.where("(kurs = ? AND semester = ?) AND semester = ? AND faculty_id= ? AND year=?",1,1,sem,f_id,year)
      g.each  do |c|

        s = StudentGroup.where('group_id = ? AND commerce= ?',c.id,false)
        sum+=s.size

        s = StudentGroup.where('group_id = ? AND commerce= ? AND social=?',c.id,false,true)
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_soc+=s.size

        s = StudentGroup.where('group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2)
        s.each do |s|
          s.refund=true
          #s.save!
        end
        sum_otl+=s.size


        s = StudentGroup.where('group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1)
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

    g = Group.where('(kurs != ? OR semester != ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year)
    g.each  do |c|
      s = StudentGroup.where('group_id = ? AND commerce= ?',c.id,false)
      sum+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND social=?',c.id,false,true)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_soc+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_otl+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_hor+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND study=?',c.id,false,true)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_1+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND public=?',c.id,false,true)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_2+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND scientific=?',c.id,false,true)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_3+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND cultural=?',c.id,false,true)
      s.each do |s|
        s.refund=true
        #s.save!
      end
      sum_4+=s.size

      s = StudentGroup.where('group_id = ? AND commerce= ? AND sports=?',c.id,false,true)
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


end
