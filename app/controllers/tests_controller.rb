class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # headers['Content-Type'] = 'w'
  end

  def create

  end

end
