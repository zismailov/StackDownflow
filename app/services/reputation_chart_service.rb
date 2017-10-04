class ReputationChartService
  def initialize(user, days)
    @user = user
    @period = days
    map_to_period(prepare_array(reputations))
  end

  def chart
    @reputations if @reputations
  end

  private

  def reputations
    @user.reputations.select("cast(created_at as date)", "sum(value) as value")
         .where("created_at >= ?", @period.days.ago)
         .group("cast(created_at as date)")
         .order("sum(value) DESC")
  end

  def prepare_array(relations)
    return if relations.blank?
    max = relations[0].value
    relations.map { |r| { percentage: (r.value / max.to_f * 100).round(2), reputation: r.value, date: r.created_at } }
  end

  def map_to_period(array)
    return if array.blank?
    @reputations = ((@period - 1).days.ago.to_date..Date.today).map do |date|
      reputation = array.select { |r| r[:date] == date }
      reputation[0] ? reputation[0] : { date: date, reputation: 0, percentage: 0 }
    end
  end
end