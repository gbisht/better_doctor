class DoctorsController < ApplicationController

  def search
    @name = params[:name]

    if @name.present?
      cached_data = get_cached_data

      if cached_data.present?
        @doctors = JSON.parse(cached_data)
      else
        request_BD_api
      end

      respond_to do |format|
        format.js{render 'search'}
      end
    end
  end


  private

  def get_cached_data
    $redis.get("#{@name}")
  end

  # request better doctor api
  def request_BD_api
    request = "#{Rails.configuration.bd_api_url}/doctors?name=#{@name}&user_key=#{Rails.configuration.bd_user_key}"
    response = HTTParty.get(request)
    @doctors = response['data']
    $redis.set("#{@name}", @doctors.to_json)
    $redis.expire("#{@name}", 30.minutes.to_i)
  end

end