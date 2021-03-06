class PostUserSerializer < ActiveModel::Serializer
  attributes :id, :updated_at , :title, :status , :writer , :bookmark , :checkin_likes , :likes , :shares , :checkin
  #has_one :checkin
  has_many :comments
  has_many :photos

  def checkin_likes
    fo = false
    if scope[:option_name].present?
      fo = scope[:option_name].likes?(object)
    end
    fo
  end

  def checkin
    ch = {}
    if object.checkin.present?
      #ch = ActiveModel::Serializer.serializer_for()
      ch = CheckinSerializer.new(object.checkin , {root: false})
    end
    ch
  end

  def status
    st = ''
    if object.status.present?
      st = object.status
    end
    st
  end

  def writer
    c = object.user
    if c.dp.present?
      k = c.dp.url.gsub('upload','upload/g_face,c_thumb,w_150,h_150')
    else
      k = c.avatar
    end
  	d = c.as_json(only: [:id , :name , :username , :email , :location , :gender , :dob , :role , :followees_count , :followers_count , :likees_count , :referal_code])
    d = d.merge(avatar: k)
  end

  def likes
  	object.likers(User).as_json(only: [:id , :name , :username , :email , :avatar , :location , :gender , :dob , :role , :followees_count , :followers_count , :likees_count , :referal_code])
  end

  def bookmark
  	fo = false
    if scope[:option_name].present?
      if object.checkin.present?
        if object.checkin.restaurant.present?
          fo = scope[:option_name].likes?(object.checkin.restaurant)
        end
      end
    end
    fo
  end
end
