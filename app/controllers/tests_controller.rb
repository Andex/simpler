class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # headers['Content-Type'] = 'w'
    # status(203)
  end

  def create

  end

end
