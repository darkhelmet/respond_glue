# respond_glue

Inherit and override respond_to

# Example

    ./script/plugin install git://github.com/darkhelmet/respond_glue.git

In your parent controller

    include RespondGlue

    def index
      do_some_magic
      respond_glue(:html) { # render something }
      respond_glue(:js) { render(:json => @something) }
    end

In your child controller

    def index
      super
      respond_glue(:js) { render(:json => { :data => @something, :something => 1 }) }
    end

    glue_for(:index)

And for all actions where you want whatever is defined in the superclass. If nothing is explicitly defined, you don't need this.

    superglue_for(:show,create,:update)

glue_for can also take a block, which is called after calling 'super'

    glue_for(:index) do
      respond_glue(:js) { render(:json => { :data => @something, :something => 1 }) }
    end

# License

See LICENSE for details
