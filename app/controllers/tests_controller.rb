class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
  end

  def create

  end

  def show
    @id = params[:id]
  end

end
