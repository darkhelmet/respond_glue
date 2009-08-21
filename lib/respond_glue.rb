module RespondGlue
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods
    def glue_for(*actions)
      actions.each do |a|
        alias_method "#{a}_original", a
        define_method(a) do
          eval("#{a}_original")
          glue
        end
      end
    end

    def superglue_for(*actions)
      actions.each do |a|
        define_method(a) { super }
        glue_for(a)
      end
    end
  end

  def respond_glue(format = nil)
    @glue ||= { }
    return @glue if format.nil?
    block_given? ? @glue[format] = Proc.new : @glue[format]
  end

  def glue
    respond_to do |format|
      respond_glue.each do |k,v|
        format.send(k,&v)
      end
    end
  end
end
