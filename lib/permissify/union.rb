module Permissify
  module Union

    include Permissify::Common

    def permission(action, category) # interface used by Permissify::Common.allowed_to?
      @union ||= construct_union # TODO : get lazier?
      permissible?(@union, action, category)
    end

    private

    def construct_union
      union = {}
      permissified_models = self.send(self.class::PERMISSIFIED_ASSOCIATION)
      permissions_hashes = permissified_models.collect(&:permissions)
      permissions_hashes.each do |permissions_hash|
        permissions_hash.each do |key, descriptor|
          union[key] ||= {'0' => false}
          # NOTE : mothballed additional permission values...
          # if union[key].nil?
          #   union[key] = descriptor # TODO : check : does this have '1' or true? is spec construction masking reality?
          # else
          #   arbitrate(union, descriptor, key, :max)
          # end
          # union[key]['0'] = (union[key]['0'] == true || descriptor['0'] == '1')
          union[key]['0'] = true if descriptor['0'] == '1'
        end
      end
      union
    end
  end
end
