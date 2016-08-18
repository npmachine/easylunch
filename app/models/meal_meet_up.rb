# Meal Meet Up model
class MealMeetUp < ActiveRecord::Base
  has_many :meal_meet_up_logs
  has_many :meal_meet_up_tasks
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :messenger, class_name: 'CodeTable', foreign_key: 'messenger_code'
  belongs_to :status,    class_name: 'CodeTable', foreign_key: 'meetup_status'

  # 빈 MeetUp 생성
  def self.init_meetup(params)
    create(messenger_code: CodeTable.find_messenger(params[:messenger]).id,
           messenger_room_id: params[:messenger_room_id],
           meetup_status: CodeTable.find_meetup_status('created').id)
  end

  def update_status(total_price, meetup_status)
    pay_avg(total_price.to_i) if meetup_status == 'paying_avg'
    update(total_price: total_price.to_i,
           meetup_status: CodeTable.find_meetup_status(meetup_status).id)
  end

  def pay_avg(total_price)
    avg_price = total_price / meal_meet_up_tasks.count
    meal_meet_up_tasks.each do |task|
      task.meal_log.update(price: avg_price)
    end
  end
end
