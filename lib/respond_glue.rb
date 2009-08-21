module RespondGlue
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods
    def glue_for(*actions)
      blk = block_given? ? Proc.new : nil
      actions.each do |a|
        if blk.nil?
          alias_method("#{a}_original", a)
          define_method(a) do
            eval("#{a}_original")
            glue
          end
        else
          define_method(a) do
            super
            instance_eval(&blk)
            glue
          end
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
    unless respond_glue.empty?
      respond_to do |format|
        respond_glue.each do |k,v|
          format.send(k,&v)
        end
      end
    end
  end
end
