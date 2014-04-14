module DateModul
  
  #Tester om dato for oppretting av arbeidsdag ikke allerede 
  #har en arbeidsdag knyttet til seg, vil så returnere en dato
  #samme månde som ikke er opptatt.
  def try_date(date_string, user_id)
    date = Date.parse(date_string)
    occupied_dates = Workday.select(:date).where("user_id = ? and date = ?", user_id, date)
    from = date.beginning_of_month
    to = date.end_of_month

    range = from.upto(to)
    o = occupied_dates.map {|d| d.date}
    range.each do |d|
      unless o.include? d
        return d
      end
    end

    return nil
  end
  
  #Sjekker om pager knappene skal være aktive eller ikke
  #basert på om måneden har arbeidstimer i seg.
  def pager
    @prev_class = "enabled"
    @next_class = "enabled"
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today 
    end
    
    if Workday.new.get_workdays_by_month(@user, @date.advance(months: -1), current_user).empty?
         @prev_class = "disabled"
    end
    if Workday.new.get_workdays_by_month(@user, @date.advance(months: 1), current_user).empty?
         @next_class = "disabled"
    end
  end
end
