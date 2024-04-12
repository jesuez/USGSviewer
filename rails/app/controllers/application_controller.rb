class ApplicationController < ActionController::API

	#---------------------------------------------------------------------------
  def format_data (item)

  			return {
							"id": item['id'],
							"type": item['type'],
							"attributes": {
								"external_id": item['external_id'],
								"magnitude": item['magnitude'],
								"place": item['place'],
								"time": item['time'],
								"tsunami": item['tsunami'],
								"mag_type": item['mag_type'],
								"title": item['title'],
								"coordinates": {
									"longitude": item['longitude'],
									"latitude": item['latitude'],
								}
							},
							"links": {
							"external_url": item['url'],
							}
						}
  end
	#---------------------------------------------------------------------------
  def index
		page = params[:page] ? params[:page].to_i : 1
		number = (params[:number] && params[:number].to_i <= 1000 )? params[:number].to_i : 50
		magtype = params[:magtype] ? params[:magtype].split('-') : []

  		features = nil
  		count = 0
  		if params[:magtype]
  			total = Feature.where(mag_type: magtype).count()
  			features = Feature.where(mag_type: magtype).page(page).per(number)
  		else
  			total = Feature.count()
  			features = Feature.limit(number).page(page).per(number)
		end

  			data = []
  			features.each do |item|
			  data.push(format_data (item))
			end

         mag_types = ActiveRecord::Base.connection.execute('select distinct mag_type from features')
    		render json: {
							"data": data,
							"pagination": {
								"current_page": page,
								"total": total,
								"per_page": number,
								"magtype": magtype,
								"mag_types": mag_types.map{ |item| item.values }.flatten
							}
						  }
  end
	#---------------------------------------------------------------------------
  def find
  			feature = Feature.includes(:comments).find(params[:id])
    		render json: { "data": (format_data (feature)), comments:feature.comments }
  end
	#---------------------------------------------------------------------------
  def update

	 if Feature.find(params[:id]).update(params.require(:feature).permit(:title, :magnitude, :mag_type))
      render json: { success: true } 
    else 
      render json: { success: false } 
    end 
    
  end
	#---------------------------------------------------------------------------
  def add_comment
  	if params[:comment][:body].strip.empty?
  		render json: { success: false, error: 'Empty comment body.' }
  	else	
	    @comment = Comment.new(feature_id:params[:id],body:params[:comment][:body]) 
	    if @comment.save 
	      render json: { success: true, comment_id: @comment.id } 
	    else 
	      render json: { success: false }
	    end
  	end
  end

end
