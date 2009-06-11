require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

# TODO(dbalatero): remove all this shit.
describe "trap hack" do
  it "should shadily intercept trap(:INT) and set a global variable, which really sucks btw" do
    $TRAP_INT_OCCURRED.should == false
    trap(:INT) { Thread.current.exit }
    $TRAP_INT_OCCURRED.should == true

    # reset it in case of shit.
    $TRAP_INT_OCCURRED = false
  end
end
