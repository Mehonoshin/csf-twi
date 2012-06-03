require 'faye'

notificator = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
notificator.listen(9292)
