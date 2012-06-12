module Permissify
  module Union

    include Permissify::Common

    def permissions # interface used by Permissify::Common.allowed_to?
      @union ||= construct_union
    end
  
    private

    def construct_union
      union = {}
      permissified_models = self.send(self.class::PERMISSIFIED_ASSOCIATION)
      permissions_hashes = permissified_models.collect(&:permissions)
      permissions_hashes.each do |permissions_hash|
        permissions_hash.each do |key, descriptor|
          descriptor ||= {'0' => false}
          # TODO : mothball permission extra args stuff?
          # - stuff has been dormant and is currently unused and doubt it is working at all levels of stack.
          if union[key].nil?
            union[key] = descriptor
          else
            arbitrate(union, descriptor, key, :max)
          end
          union[key]['0'] = (union[key]['0'] == true || descriptor['0'] == '1')
        end
      end
      union
    end
  end
end
