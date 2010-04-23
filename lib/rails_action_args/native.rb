module GetArgs
  def get_args
    required = []
    optional = []
 
    parameters.each do |(type, name)|
      if type == :opt
        required << [name, nil]
        optional << name
      else
        required << [name]
      end
    end
 
    return [required, optional]
  end
end
