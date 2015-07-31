class GithubAuthOptions
  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def to_hash
    if @request.params["access"] == "full"
      { scope: "user:email,repo" }
    else
      { scope: "user:email" }
    end
  end
end
