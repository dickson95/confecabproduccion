require 'test_helper'

class InsumosMailerTest < ActionMailer::TestCase
  test "insumos" do
    mail = InsumosMailer.insumos
    assert_equal "Insumos", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
