require_relative 'test_helper'

context Schreihals::Document do
  helper(:test_document_filename) { File.expand_path('../files/simple_document.md', __FILE__) }
  helper(:test_document_contents) { open(File.expand_path('../files/simple_document.md', __FILE__)).read }

  setup { Schreihals::Document }

  context "#from_string" do
    setup { topic.from_string open(test_document_filename).read }

    asserts(:class).equals Schreihals::Document
    asserts(:body).equals "This is the body."
    asserts(:title).equals "This is the title"
    asserts("automatically converts dates into Date objects") { topic.date.kind_of? Date }
    asserts("automatically converts datetimes into Time objects") { topic.datetime.kind_of? Time }
  end

  context "#from_file" do
    should "call #from_string with the contents of the file" do
      mock.proxy(topic).from_string(test_document_contents)
      topic.from_file(test_document_filename)
    end
  end
end
