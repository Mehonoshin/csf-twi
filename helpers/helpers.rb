module Csfhelpers
  def link_to(string, path)
    "<a href='#{path}'>#{string}</a>"
  end

  def h(string)
    string
  end
end
