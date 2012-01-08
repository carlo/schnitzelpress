require_relative 'test_helper'

context Schreihals::Document do
  context "#from_string" do
    setup do
      Schreihals::Document.from_string <<-EOF
---
title: This is the title
---

This is the body.
EOF
    end

    asserts(:class).equals Schreihals::Document
    asserts(:body).equals "This is the body."
    asserts(:title).equals "This is the title"
  end
end
